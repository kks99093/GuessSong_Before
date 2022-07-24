package com.guess.song.handller;

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
import com.guess.song.model.param.UserInfoParam;
import com.guess.song.service.BoardService;
import com.guess.song.util.Utils;

@Component
public class SocketHandler3 extends TextWebSocketHandler{

	@Autowired
	private BoardService boardService;
	
	// 내 생각에는 이 hashmap에 담기는게 내 정보 같거든 id는 내 세션id , uri는 내가 접속한 주소
	//HashMap<String, WebSocketSession> sessionMap = new HashMap<>();
	
	
	// {RoomNumber : 1, sessionId1 : sessionId, sessionId2 : sessionId}
	// 이런식으로 방번호 +그 방에 속한 사람들의 sessionId로 이루어진 List
	List<HashMap<String, Object>> roomUserList = new ArrayList<>();
	HashMap<String, String> userInfo = new HashMap<String, String>();
	HashMap<String, HashMap<String, String>> userMap = new HashMap<>();
	
	
	
	@SuppressWarnings("unchecked")
	@Override
	public void afterConnectionEstablished(WebSocketSession session) throws Exception {
		// TODO Auto-generated method stub
		super.afterConnectionEstablished(session);
		String url = session.getUri().toString(); // js에서 접속한 localhst/chating/방번호 의 주소가 담겨있음
		String roomNumber = (url.split("/chating/")[1]).split("/")[0]; // chating뒤의 방번호만 잘라냄
		String userName = (url.split("/chating/")[1]).split("/")[2];
		int idx = roomUserList.size(); //전체 방이 몇개인지 가져옴
		boolean flag = false; //접속하려는 방이 존재하는지 존재하지 않는지 체크할떄 씀
		
		if(idx > 0) { //방이 한개 이상일경우 현재 내가 접속하려는 방이 있는지 확인
			for(int i=0; i<roomUserList.size(); i++) {
				String rN = (String) roomUserList.get(i).get("roomNumber");
				if(rN.equals(roomNumber)) {
					flag = true; //접속하려는 방이 존재함으로 true로 바꿔줌
					idx = i; //접속하려는 방이 있다면 인덱스를 저장
					break;
				}
			}
		}
		
		
		// 내 정보(sessionId)를 클라이언트로 넘겨서 저장함
		// 이후에 보내는 메세지가 누군지 구분하기 위함
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("type", "sessionId");
		jsonObject.put("sessionId", session.getId());
		session.sendMessage(new TextMessage(jsonObject.toString()));
		
		if(flag == true) {
			roomUserList.get(idx).put(session.getId(), session); // 방 + 그방에 속한사람들이 있는 map에다가 현재 접속하는 사람의 정보를 추가해준다
						
			//본인한테 보낼 유저정보를 담음
			List<HashMap<String, String>> userList = new ArrayList<>();
			for(String key : roomUserList.get(idx).keySet()) {
				if(!key.equals("roomNumber") && !key.equals("songList") && !key.equals("currentSong") && !key.equals(session.getId()) && !key.equals("reader")) {
					HashMap<String, String> user =  new HashMap<String, String>();
					String name = userMap.get(key).get("userName");
					String id = userMap.get(key).get("sessionId");
					user.put("userName", name);
					user.put("sessionId", id);
					userList.add(user);
				}
			}
			//본인한테 보내는 방인원 정보
			jsonObject = new JSONObject();
			jsonObject.put("type", "join");
			jsonObject.put("userList", userList);			
			session.sendMessage(new TextMessage(jsonObject.toString()));
			
			//본인 정보를 userMap에 넣음
			HashMap<String, String> user =  new HashMap<String, String>();
			user.put("userName", userName);
			user.put("sessionId", session.getId());
			userMap.put(session.getId(), user);
			
			
			
			//이미 입장해 있는 다른 유저에게 보내는 본인 정보
			for(String key : roomUserList.get(idx).keySet()) {
				if(!key.equals("roomNumber") && !key.equals("songList") && !key.equals("currentSong") && !key.equals("reader") &&!key.equals(session.getId())) {
					jsonObject = new JSONObject();
					jsonObject.put("type", "join");
					jsonObject.put("user", user);
					WebSocketSession wss = (WebSocketSession)roomUserList.get(idx).get(key);
					try {
						wss.sendMessage(new TextMessage(jsonObject.toString()));
					}catch(Exception e) {
						e.printStackTrace();
					}
				}
			}
			
			
		}else {
			String songNumberStr = (url.split("/chating/")[1]).split("/")[1]; // 노래목록 pk값
			int songNumber = Integer.parseInt(songNumberStr);
			HashMap<String, Object> map = new HashMap<String, Object>();
			//노래목록을 여기서 추가?
			if(songNumber != 0) {
				List<SongInfoDTO> songList = boardService.findSongList(songNumber);
				map.put("songList", songList);
			}
			
			
			
			map.put("roomNumber", roomNumber);
			map.put("reader", session.getId());
			map.put(session.getId(), session);
			UserInfoParam userInfo = new UserInfoParam();
			userInfo.setSessionId(session.getId());
			userInfo.setUserName(userName);
			HashMap<String, String> user = new HashMap<String, String>();
			user.put("sessionId", session.getId());
			user.put("userName", userName);
			userMap.put(session.getId(),user);
			
			roomUserList.add(map);
			// 접속하려는 방이 존재 하지 않을경우 새로운 map을 반들어서 방번호 와 본인의정보를 담은후 list에 추가해준다
		}
		


		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	protected void handleTextMessage(WebSocketSession session, TextMessage message) throws Exception {
		// TODO Auto-generated method stub
		JSONObject jsonObject = Utils.JsonToObjectParser(message.getPayload());
		HashMap<String, Object> roomInfo = new HashMap<String, Object>(); //밑의 for문을 돌아서 찾은 방의 정보를 여기다가 담을꺼
		String roomNumber = (String)jsonObject.get("roomNumber");
		String type = (String)jsonObject.get("type");
		 // roomNumber를 비교하면서 해당 방의 HashMap을 찾아서 위의 roomInfo에 넣어줄꺼
			for(int i = 0; i < roomUserList.size(); i++) {
				if(roomNumber.equals(roomUserList.get(i).get("roomNumber"))) {
					roomInfo = roomUserList.get(i);
					break;
				}		
			}
			
			
			//게임 시작, 다음 노래 눌럿을경우
			if(type.equals("gameStart") || type.equals("nextSong")) {
				if(roomInfo.get("currentSong") == null) {
					roomInfo.put("currentSong", 0);
				}else {
					int temp = (int)roomInfo.get("currentSong");
					roomInfo.put("currentSong", temp+1);
				}
				int currentSong = (int)roomInfo.get("currentSong");
				List<SongInfoDTO> songList = (List<SongInfoDTO>)roomInfo.get("songList");				
				jsonObject.put("songInfo", songList.get(currentSong).getYoutubeUrl());
				
			}
			
			
			//게임 시작후 보낸 메세지가 정답일 경우
			if(type.equals("message") && roomInfo.get("currentSong") != null) { //roomInfo.get("currentSong")가 null이 아니란건 게임이 시작됐단뜻
				List<SongInfoDTO> songList = (List<SongInfoDTO>)roomInfo.get("songList");
				int currentSong = (int)roomInfo.get("currentSong");
				if(songList.get(currentSong).getAnswer() != null) { //정답칸이 비어있다 => 이미 정답자가 나왔다는 뜻이므로 정답체크 할 필요가 없음
					String answer = songList.get(currentSong).getAnswer().replaceAll("\\s", ""); //정답
					String userMsg = ((String)jsonObject.get("msg")).replaceAll("\\s", ""); //공백 제거한 msg
					if(answer.equals(userMsg)) {
						jsonObject.put("answerChk", 1); //정답일경우 answerChk에 1을 넣어서 리턴, 오답일경우 0임					
						songList.get(currentSong).setAnswer(null); //정답자가 중복해서 나오지않게 정답칸을 바로 비워줌
					}
				}else{
					jsonObject.put("answerChk", 0); //뭔가 js에서 null값 경우의수 만들어줘야 할거같아서 그냥 그럴일 없게 만들어 놨음
				}
				
				
			}
			
			
			//위에서 찾은 방의 hashmap을 돌면서 key값이 roomNumber가 아닌 sessionId로 되어있는 사람들에게 메세지를 전송
			for(String key : roomInfo.keySet()) {
				if(!key.equals("roomNumber") && !key.equals("songList") && !key.equals("currentSong") && !key.equals("reader")) {
										//현재 roomInfo를 담는 Hashmap은 방번호도 함꼐 담기위해 Object의 value를 받기 떄문에 WebSocketSession으로 형변환을 해줌
					WebSocketSession wss = (WebSocketSession)roomInfo.get(key);
					try {
						wss.sendMessage(new TextMessage(jsonObject.toString()));
					}catch(Exception e) {
						e.printStackTrace();
					}
				}
			}
	

		
		
		super.handleTextMessage(session, message);
	}
	
	@Override
	public void afterConnectionClosed(WebSocketSession session, CloseStatus status) throws Exception {
		// TODO Auto-generated method stub
		
		int idx = 0;
		String mySessionId = session.getId();
		for(int i=0 ; i < roomUserList.size(); i++) {
			//모든 방을 돌며 현재 접속한사람의 session아이디를 전부 지운다
			if(roomUserList.get(i).get(mySessionId) != null) {
				roomUserList.get(i).remove(session.getId());
				idx = i;
				break;
			}		
		}
		//roomNumber, songList, reader 고정  게임시작할경우 currentSong 생김
		if(roomUserList.get(idx).get("currentSong") != null && roomUserList.get(idx).size() < 5) {
			String roomNumber = (String) roomUserList.get(idx).get("roomNumber");
			boardService.delGameRoom(roomNumber);
		}else if(roomUserList.get(idx).size() < 4) {
			String roomNumber = (String) roomUserList.get(idx).get("roomNumber");
			boardService.delGameRoom(roomNumber);
		}

		super.afterConnectionClosed(session, status);
	}

}
