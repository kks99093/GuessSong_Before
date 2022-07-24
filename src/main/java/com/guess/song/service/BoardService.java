package com.guess.song.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import com.guess.song.model.dto.SongInfoDTO;
import com.guess.song.model.entity.GameRoom;
import com.guess.song.model.entity.SongBoard;
import com.guess.song.model.entity.SongInfo;
import com.guess.song.model.param.GameRoomParam;
import com.guess.song.model.param.SongBoardParam;
import com.guess.song.model.param.SongInfoParam;
import com.guess.song.model.param.UserInfoParam;
import com.guess.song.repository.GameRoomRepository;
import com.guess.song.repository.SongBoardRepository;
import com.guess.song.repository.SongInfoRepository;

@Service
public class BoardService {
	
	@Autowired
	private SongInfoRepository songRep;
	
	@Autowired
	private SongBoardRepository songBoardRep;
	
	@Autowired
	private GameRoomRepository gameRoomRep;
	
//	public int regSong(HttpServletRequest request, RestFile restFile) {
//		String rPath = request.getServletContext().getRealPath("/");
//		String path = rPath + "upload/song/";
//		List<SongInfo> songList = FileUtils.creatFile(path, restFile);
//		for(int i = 0; i < songList.size(); i++) {
//			System.out.println(" 정답 : " + songList.get(i).getAnswer() + " , 파일이름 : " + songList.get(i).getSongNm());
//			songRep.save(songList.get(i));
//		}
//		
//		return 0;
//	}
	
	
	//게임방 + 목록 등록
	public void regSong(SongInfoParam songInfoParam) {

		
		SongBoard songBoard = new SongBoard();
		songBoard.setTitle(songInfoParam.getTitle());
		songBoard = songBoardRep.save(songBoard);
		
		for(int i = 0; i < songInfoParam.getAnswer().size(); i++) {
			SongInfo songInfo = new SongInfo();
			songInfo.setAnswer(songInfoParam.getAnswer().get(i));
			songInfo.setYoutubeUrl(songInfoParam.getYoutubeUrl().get(i));
			songInfo.setHint(songInfoParam.getHint().get(i));
			songInfo.setSongBoard(songBoard);
			songRep.save(songInfo);
		}
	}
	
	//방목록 불러오기
	public Page<SongBoard> selSongBoardList(Pageable pageable){
		Page<SongBoard> songBoardList = songBoardRep.findAll(pageable);		
		return songBoardList;
	}
	
	public List<SongInfoDTO> findSongList(int songBoardPk){

		List<SongInfo> songList = songRep.findByBoardPk(songBoardPk);
		List<SongInfoDTO> songInfoDTOList = new ArrayList<SongInfoDTO>();
		//리스트 랜덤 재정렬
		
		
		for(SongInfo songInfo : songList) {
			SongInfoDTO songInfoDTO = new SongInfoDTO();
			songInfoDTO.setAnswer(songInfo.getAnswer());
			songInfoDTO.setSongPk(songInfo.getSongPk());
			songInfoDTO.setHint(songInfo.getHint());
			songInfoDTO.setYoutubeUrl(songInfo.getYoutubeUrl());
			songInfoDTOList.add(songInfoDTO);
		}
		
		Collections.shuffle(songInfoDTOList);
		return songInfoDTOList;
		
	}
	
	public GameRoom selRoomNumber(GameRoomParam gameRoomParam, UserInfoParam userInfoParam, SongBoardParam songBoardParam) {
		GameRoom result = new GameRoom();
		
		if(gameRoomParam.getCreateRoom() == 1) {
			//방이 없을경우 방 생성
			GameRoom gameRoom = new GameRoom();
			SongBoard songBoard = songBoardRep.findByBoardPk(songBoardParam.getBoardPk());
			gameRoom.setTitle(gameRoomParam.getTitle());
			gameRoom.setSongBoard(songBoard);
			gameRoom.setReader(userInfoParam.getUserName());
			if(gameRoomParam.getPassword() != null) {
				gameRoom.setPassword(gameRoomParam.getPassword());
			}
			gameRoom = gameRoomRep.save(gameRoom);
			result = gameRoom;
		}else {
			//방이 있을 경우 그 방의 정보를 가져다줌
			GameRoom gameRoom = gameRoomRep.findByRoomPk(gameRoomParam.getRoomPk());
			
			//나중에 비밀번호 넣기
			result = gameRoom;
		}
		
		
		return result;
	}
	
	public Page<GameRoom> selGameRoom(Pageable pageable){
		Page<GameRoom> gameRoomList = gameRoomRep.findAll(pageable);
		return gameRoomList;
	}
	
	public void delGameRoom(String roomNumberParam) {
		int roomNumber = Integer.parseInt(roomNumberParam);
		GameRoom gameRoom = gameRoomRep.findByRoomPk(roomNumber);
		gameRoomRep.delete(gameRoom);
	}

}
