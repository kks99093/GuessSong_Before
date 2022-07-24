package com.guess.song.controller.rest;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.HashMap;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.guess.song.handller.SocketHandler;
import com.guess.song.model.param.GameRoomParam;

@RestController
public class UserRestController {
	
	
	@SuppressWarnings("unchecked")
	@PostMapping("/rest/userNameChk")
	public int userNameChk(@RequestBody GameRoomParam gameRoomParam) throws UnsupportedEncodingException {
		int result = 0;
		String roomNumber = gameRoomParam.getRoomPk()+"";
		String userNameParam = gameRoomParam.getUserName();
		
		HashMap<String, HashMap<String, Object>> roomList = SocketHandler.getRoomList();
		HashMap<String, HashMap<String, Object>> userList = (HashMap<String, HashMap<String, Object>>) roomList.get(roomNumber).get("userList");
		
		for(String key : userList.keySet()) {
			System.out.println(userList.get(key));
			String userName = (String) userList.get(key).get("userName");
//			String userNameDec = URLDecoder.decode(userNameEnc, "UTF-8");
			if(userNameParam.equals(userName)) {
				result = 1;
				break;
			}
		}
		return result;
	}

}
