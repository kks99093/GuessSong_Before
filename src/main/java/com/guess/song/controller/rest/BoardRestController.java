package com.guess.song.controller.rest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

import com.guess.song.model.param.SongBoardParam;
import com.guess.song.service.BoardService;

@RestController
public class BoardRestController {
	
	@Autowired
	private BoardService boardService;
	
	@PostMapping("/rest/boardDel")
	public void boardDel(@RequestBody SongBoardParam songBoardParam) {
		boardService.delSongBoard(songBoardParam);
		
	}

}
