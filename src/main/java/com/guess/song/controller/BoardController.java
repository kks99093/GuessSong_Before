package com.guess.song.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort.Direction;
import org.springframework.data.web.PageableDefault;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.guess.song.auth.PrincipalDetailsService;
import com.guess.song.model.RestFile;
import com.guess.song.model.dto.SongInfoDTO;
import com.guess.song.model.entity.GameRoom;
import com.guess.song.model.entity.SongBoard;
import com.guess.song.model.param.GameRoomParam;
import com.guess.song.model.param.SongBoardParam;
import com.guess.song.model.param.SongInfoParam;
import com.guess.song.model.param.UserInfoParam;
import com.guess.song.service.BoardService;



@Controller
public class BoardController {
	
	@Autowired
	private PrincipalDetailsService principalDetailService;
	
	@Autowired
	private BoardService boardService;
	
	
	@GetMapping("/board/main")
	public String main(@PageableDefault(sort = {"createTime"}, direction = Direction.DESC, size = 10) Pageable pageable, Model model) {
		Page<SongBoard> songBoardList = boardService.selSongBoardList(pageable);
		model.addAttribute("songBoardList", songBoardList);
		
				
		return "/board/main";
	}

	@GetMapping("/board/regSong")
	public String regSong() {
		
		return "/board/regSong";
	}
	
	@PostMapping("/proc/regSong")	
	public String regSong(HttpServletRequest request, SongInfoParam songInfoParam, RestFile restFile) {
		
		
		boardService.regSong(songInfoParam, restFile, request);
		return "redirect:/board/main";
	}
	
	@GetMapping("/board/modeSel")
	public String modSel(SongBoardParam songBoardParam, Model model) {
		model.addAttribute("boardPk", songBoardParam.getBoardPk());
		return "/board/modeSel";
	}
	
	@GetMapping("/board/soloGameBoard")
	public String soloGameBoard(SongBoardParam songBoardParam, Model model) {
		List<SongInfoDTO> songList = boardService.findSongList(songBoardParam.getBoardPk());
		model.addAttribute("songList", songList);
		model.addAttribute("userName", songBoardParam.getUserName());
		return "/board/soloGameBoard";
	}
	

	@PostMapping("/board/multiGameBoard")
	public String multiGameBoardPost(UserInfoParam userInfoParam, Model model, GameRoomParam gameRoomParam, SongBoardParam songBoardParam) {
		GameRoom gameRoom = boardService.selRoomNumber(gameRoomParam, userInfoParam, songBoardParam);
		if(userInfoParam.getUserRole() == null) {
			userInfoParam.setUserRole(0);
		}
		model.addAttribute("userInfo", userInfoParam);
		model.addAttribute("gameRoom", gameRoom);
		return "/board/multiGameBoard";
	}
	
	@GetMapping("/board/gameList")
	public String gameList(@PageableDefault(sort = {"createTime"}, direction = Direction.DESC, size = 10) Pageable pageable, Model model) {
		Page<GameRoom> gameRoomList =  boardService.selGameRoom(pageable);
		model.addAttribute("startIdx", (int)(gameRoomList.getPageable().getPageNumber()/10)*10);
		model.addAttribute("gameRoomList", gameRoomList);
	
		return "/board/gameList";
	}
	
	

	
	// 세션 강제 부여	
//		@PostMapping("/board/main")
//		public String main(@AuthenticationPrincipal PrincipalDetails principalDetails,UserInfo userInfo, HttpSession session) {
//			UserDetails userDetail = principalDetailService.loadUserByUsername(userInfo.getUsername());
//			Authentication authentication = 
//			new UsernamePasswordAuthenticationToken(userDetail, userDetail.getPassword(), userDetail.getAuthorities());
//			SecurityContext securityContext = SecurityContextHolder.getContext();
//			securityContext.setAuthentication(authentication);
//			session.setAttribute("SPRING_SECURITY_CONTEXT", securityContext);
//			
//			return "redirect:/board/main";
//		}

}
