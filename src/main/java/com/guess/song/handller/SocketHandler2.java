package com.guess.song.handller;

import java.io.IOException;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.TextMessage;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.guess.song.model.dto.SongInfoDTO;
import com.guess.song.service.BoardService;
import com.guess.song.util.Utils;

@Component
public class SocketHandler2 extends TextWebSocketHandler{

	@Autowired
	private BoardService boardService;
	
	//session을 입력하면 session을 주고 userName을 입력하면 userName을 주는 등 얘가 제일 마지막에있는 hashMap 
	//HashMap<String, Object> userInfo = new HashMap<>();
	
	//GetId를 받아서 위의 HashMap을 찾아주는 HashMap 얘는 어차피 위의 HashMap이랑만 연결됨으로 Object가 아니라 HashMap타입 넣어줘도 됨
	//HashMap<String, HashMap<String, Object>> userList = new HashMap<>();
	
	//위의 userGetId, SongList, readerId등 으로 방에대한 정보를 담음
	//HashMap<String, Object> roomInfo = new HashMap<>();
	
	//roomNumber로 위의 Hash맵을 불러오는 최상위 HashMap 위의 정보만 불러올거라 HashMap타입을 넣어줘도 됨
	private static HashMap<String, HashMap<String, Object>>  roomList = new HashMap<>();
	
	
	
	
	
	@SuppressWarnings("unchecked")
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		
		// TODO Auto-generated method stub
		super.afterConnectionEstablished(session);
		
		String url = session.getUri().toString(); // js에서 접속한 localhst/chating/방번호 의 주소가 담겨있음
		String roomNumber = (url.split("/chating/")[1]).split("/")[0]; // chating뒤의 방번호만 잘라냄
		String userName = (url.split("/chating/")[1]).split("/")[2];
		userName = URLDecoder.decode(userName, "UTF-8");
		int roomSize = roomList.size(); //전체 방이 몇개인지 가져옴
		boolean flag = false; //접속하려는 방이 존재하는지 존재하지 않는지 체크할떄 씀
		if(roomSize > 0 && roomList.get(roomNumber) != null) { //방이 한개 이상일경우 현재 내가 접속하려는 방이 있는지 확인
				flag = true; //접속하려는 방이 존재함으로 true로 바꿔줌
		}
		
		

		
		//방 입장시
		if(flag == true) {
			//본인한테 보낼거 : 다른사람의 sessionId와 닉네임 ==> userList를 보내면 될듯
			HashMap<String, HashMap<String, Object>> userList = (HashMap<String, HashMap<String, Object>>) roomList.get(roomNumber).get("userList");
			//본인한테 이미 접속해있던 userList를 보냄
			sendUserList(session, userList);
			//이미 입장해 있는 다른 유저에게 본인 닉네임과 sessionId를 보냄 (메세지를 보낼때는 해당유저의 session을 가져와서 .sendMessage 메서드로 보냄)
			sendMyInfo(session, userList, userName);
			int songNumber = 0; //이걸로 방 생성인지 참가인지 구분
			joinRoom(session, roomNumber ,songNumber, userName); //해당방의 userList에 입장한사람의 정보를 추가
			
		}else {
			//방 생성시 Map에다가 유저정보를 넣는처리 (songNumber 써서 메서드 하나로 생성 참가 다 처리할 수 있을듯?) 
			String songNumberStr = (url.split("/chating/")[1]).split("/")[1]; // 노래목록 pk값
			int songNumber = Integer.parseInt(songNumberStr);
			joinRoom(session, roomNumber ,songNumber, userName);

		}
		
		// 내 정보(sessionId)를 클라이언트로 넘겨서 저장함(이후에 보내는 메세지가 누군지 구분하기 위함)
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("type", "sessionId");
		jsonObject.put("sessionId", session.getId());
		List<SongInfoDTO> songInfoList = (List<SongInfoDTO>)roomList.get(roomNumber).get("songList");
		jsonObject.put("youtubeUrl", songInfoList.get(0).getYoutubeUrl());
		session.sendMessage(new TextMessage(jsonObject.toString()));

	}
	
	
	
	
	@SuppressWarnings("unchecked")
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// TODO Auto-generated method stub
		JSONObject jsonObject = Utils.JsonToObjectParser(message.getPayload());
		String roomNumber = (String)jsonObject.get("roomNumber");
		String type = (String)jsonObject.get("type");
		String youtubeUrl = "";
		HashMap<String, Object> roomInfo = roomList.get(roomNumber);
		
		
		
		switch(type) {
			case "gameStart" :
				roomInfo.put("currentSong", 0);
				break;
			case "skipSong" :
				int skipChk = skipSong(roomInfo);
				if(skipChk == 1) {
					youtubeUrl = nextYoutubeUrl(roomInfo);
					jsonObject.put("youtubeUrl", youtubeUrl);
				}else if(skipChk == 2){
					jsonObject.put("skipChk", skipChk);
				}else {
					int skipNum = (int)roomInfo.get("skipNum");
					jsonObject.put("skipNum", skipNum);
				}
				break;
			case "ready":
				int readyChk = userReady(roomInfo);
				jsonObject.put("readyChk", readyChk);
				break;
			case "message" :
				if(roomInfo.get("currentSong") != null) {
					String userMsg = ((String)jsonObject.get("msg")).replaceAll("\\s", "");
					int answerChk = answerChk(roomInfo, userMsg);
					String nextYoutubeUrl = nextYoutubeUrl(roomInfo);
					jsonObject.put("answerChk", answerChk);
					jsonObject.put("youtubeUrl", nextYoutubeUrl);
				}
				break;
			
		}

		HashMap<String, HashMap<String, Object>> userList = (HashMap<String, HashMap<String, Object>>) roomList.get(roomNumber).get("userList");
			
		//userList를 돌며 session을 가져와서 메세지를 보냄
		for(String key : userList.keySet()) {
			WebSocketSession wss = (WebSocketSession)userList.get(key).get("session");
			try {
				wss.sendMessage(new TextMessage(jsonObject.toString()));
			}catch(Exception e) {
				e.printStackTrace();
			}
		}

		super.handleTextMessage(session, message);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		// TODO Auto-generated method stub
		
		String roomNumber = "";
		String mySessionId = session.getId();
		HashMap<String, HashMap<String, Object>> userList = new HashMap<>();
		//모든 방을 돌며 해당 유저의 sessionId를 지운다(사실상 하나의 방에서만 지움)
		for(String key : roomList.keySet()) {
			userList = (HashMap<String, HashMap<String, Object>>) roomList.get(key).get("userList");
			if(userList.get(mySessionId) != null) {
				userList.remove(mySessionId);
				roomNumber = key;
				break;
			}
		}
		
		
		// 방에 있는 사람들에게 sessionId를 보내 클라이언트 유저목록에서 지움
		for(String key : userList.keySet()) {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("type", "left");
			jsonObject.put("sessionId", mySessionId);
			WebSocketSession wss = (WebSocketSession)userList.get(key).get("session");
			wss.sendMessage(new TextMessage (jsonObject.toString()));
		}
		
		
		//방에 사람이 0명이면 게임방 삭제
		userList = (HashMap<String, HashMap<String, Object>>) roomList.get(roomNumber).get("userList");
		if(userList.size() < 1 && !roomNumber.equals("")) {
			boardService.delGameRoom(roomNumber);
		}


		super.afterConnectionClosed(session, status);
	}
	
	
	//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ Not Override 메서드 ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ
	
	//방 만들시 처리해줄 로직
	@SuppressWarnings("unchecked")	
	public void joinRoom(WebSocketSession session, String roomNumber, int songNumber, String userName) {
		HashMap<String, Object> roomInfo = new HashMap<String, Object>();
		HashMap<String, Object> userInfo = new HashMap<String, Object>();
		HashMap<String, HashMap<String, Object>> userList = new HashMap<String, HashMap<String, Object>>();
		//노래목록을 여기서 추가?
		if(songNumber != 0) { //songNumber가 0이 아니면 방 생성
			List<SongInfoDTO> songList = boardService.findSongList(songNumber);
			roomInfo.put("songList", songList);
		}else {
			userList = (HashMap<String, HashMap<String, Object>>) roomList.get(roomNumber).get("userList");
		}
		userInfo.put("session", session); //유저정보에 session저장
		userInfo.put("userName", userName); //유저정보에 유저이름 저장
		userList.put(session.getId(), userInfo); // 위의 유저정보를 userList에 sessionId로 추가
		
		if(songNumber != 0) {
			roomInfo.put("userList", userList); // 위의 유저리스트를 roomInfo에 userList형태로 저장
			roomInfo.put("reader", session.getId()); // 만든사람의 session을 받아와서 roomInfo에 방장을 저장
			
			roomList.put(roomNumber, roomInfo); //위의 roomInfo를 roomList에 추가
		}		
	}
	
	
	@SuppressWarnings("unchecked")
	public void sendUserList(WebSocketSession session, HashMap<String, HashMap<String, Object> >userListParam) {
		List<HashMap<String, String>> userList = new ArrayList<>();
		
		for(String key : userListParam.keySet()) {
			HashMap<String, String> userInfo = new HashMap<>();
			String userName = (String)userListParam.get(key).get("userName");
			userInfo.put("sessionId", key);
			userInfo.put("userName", userName);
			userList.add(userInfo);
		}
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("type", "join");
		jsonObject.put("userList", userList);
		try {
			session.sendMessage(new TextMessage(jsonObject.toString()));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
	}
	
	
	// 내 정보를 방의 사람들에게 보냄
	@SuppressWarnings("unchecked")
	public void sendMyInfo(WebSocketSession session, HashMap<String, HashMap<String, Object>> userList, String userName) {		
		
		HashMap<String, String> userInfo = new HashMap<String, String>();
		userInfo.put("userName", userName);
		userInfo.put("sessionId", session.getId());
		for(String key : userList.keySet()) {
			JSONObject jsonObject = new JSONObject();
			jsonObject.put("type", "join");
			jsonObject.put("user", userInfo);
			WebSocketSession wss = (WebSocketSession)userList.get(key).get("session");
			try {
				wss.sendMessage(new TextMessage(jsonObject.toString()));
			}catch(Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	
	
	@SuppressWarnings("unchecked")
	public int skipSong(HashMap<String, Object> roomInfo) {
		int skipChk = 0;
		
		if("".equals(nextYoutubeUrl(roomInfo))) {
			skipChk = 2; //마지막 곡이었음
		}else {
			HashMap<String, HashMap<String, Object>> userList = (HashMap<String, HashMap<String, Object>>) roomInfo.get("userList");
			if(roomInfo.get("skipNum") == null) {
				roomInfo.put("skipNum", 1);
			}else {
				int skipNum = (int)roomInfo.get("skipNum");
				roomInfo.put("skipNum", skipNum+1);
			}
			int skipNum = (int)roomInfo.get("skipNum");
			int userListNum = userList.size();
			if(skipNum>(userListNum/2)) {
				roomInfo.remove("skipNum");
				skipChk = 1;
			}
		}
		
		return skipChk;
	}
	
	@SuppressWarnings("unchecked")
	public String nextYoutubeUrl(HashMap<String, Object> roomInfo) {
		String youtubeUrl = "";
		int currentSong = (int)roomInfo.get("currentSong");
		List<SongInfoDTO> songList = (List<SongInfoDTO>)roomInfo.get("songList");
		if(songList.size() > (currentSong+1)) {
			youtubeUrl = songList.get(currentSong+1).getYoutubeUrl();
		}
		return youtubeUrl;
		
	}
	
	@SuppressWarnings("unchecked")
	public int userReady(HashMap<String, Object> roomInfo) {
		int readyChk = 0;
		HashMap<String, HashMap<String, Object>> userList = (HashMap<String, HashMap<String, Object>>) roomInfo.get("userList");
		if(roomInfo.get("readyUser") == null) {
			roomInfo.put("readyUser", 1);
		}else {
			int currentReadyNum = (int)roomInfo.get("readyUser");
			roomInfo.put("readyUser", currentReadyNum+1);
		}
		
		int readyNum = (int)roomInfo.get("readyUser");
		int userListNum = userList.size();

		if(readyNum == userListNum) {
			int currentSong = (int)roomInfo.get("currentSong");
			roomInfo.put("currentSong", currentSong+1);
			roomInfo.remove("readyUser");
			readyChk = 1;
		}
		return readyChk;
	}
	
	
	
	//게임 시작한 후 보낸 메세지가 정답인지 확인하는 로직
	@SuppressWarnings("unchecked")
	public int answerChk(HashMap<String, Object> roomInfo, String userMsg) {
		int answerChk = 0;
		
		List<SongInfoDTO> songList = (List<SongInfoDTO>)roomInfo.get("songList");
		int currentSong = (int)roomInfo.get("currentSong");
		if(songList.get(currentSong).getAnswer() != null) { //정답칸이 비어있다 => 이미 정답자가 나왔다는 뜻이므로 정답체크 할 필요가 없음
			String answer = songList.get(currentSong).getAnswer().replaceAll("\\s", ""); //정답
			userMsg = userMsg.replaceAll("\\s", ""); //공백 제거한 msg
			if(answer.equals(userMsg)) {
				answerChk = 1; //정답일경우 answerChk에 1을 넣어서 리턴, 오답일경우 0임					
				songList.get(currentSong).setAnswer(null); //정답자가 중복해서 나오지않게 정답칸을 바로 비워줌
			}
		}
		return answerChk;
	}
	
	public static HashMap<String, HashMap<String, Object>> getRoomList(){
		return roomList;
	}
	
}
