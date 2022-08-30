<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal" var="principal"/>     
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="/css/main.css">
<meta charset="UTF-8">
<title>노래 맞추기</title>
</head>
<body>
<div class="container">
	<div class="left_div">
		<div class="regSong_div left_border" id="regSong_btn">
			<span class="left_span" id="regSong_span">노래 등록</span>
		</div>
		<div class="joinMultiGame_div left_border" id="joinMultiGame">
			<span class="left_span" id="joinMultiGame_span">게임 참여하기</span>
		</div>
	</div>
	
	<div class="rigth_div">
		<div class="search_div">
			<input type="text" placeholder="노래 검색" name="searchText" id="searchText"><span id="search_span">검색</span>
		</div>
		<div class="songBoardList_div">
			<c:forEach var="songBoard" items="${songBoardList.content }">
			<div class="songBoard_div">
				<div class="songBoard_img_div" id="songBoard_img_div" onclick="moveBoard(${songBoard.boardPk})">
					<div id="board_img_div">
						<c:choose>
							<c:when test="${songBoard.img != null }">
								<img src="/upload/songBoard/${songBoard.img}" width="200" height="200">
							</c:when>
							<c:otherwise>
								<img src="/upload/songBoard/defaultImg.png" width="200" height="200">
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				<div class="board_title_div">
					<span class="board_title_span">${songBoard.title}</span>
					<span class="drop_menu" param1="${songBoard.boardPk }">...</span>
				</div>
				<div class="drop_menu_board" id="drop_menu_board${songBoard.boardPk}">
					<div>수정</div>
					<div>삭제</div>
				</div>
			</div>
			</c:forEach>
		</div>
	</div>
</div>

<script>
	$(document).ready(function(){
		
		$('.drop_menu').click(function(){
			let boardPk = $(this).attr("param1")
			let displayStatus = $('#drop_menu_board'+boardPk).css('display')
			if(displayStatus === 'none'){
				$('#drop_menu_board'+boardPk).css('display', 'block')
			}else{
				$('#drop_menu_board'+boardPk).css('display', 'none')
			}
			
			
			
		})
		
		$('#joinMultiGame').click(function(){
			location.href = "/board/gameList";
		})
		
		$('#regSong_btn').click(function(){
			location.href = "/board/regSong";
			
		})
		
		
	})
	function moveBoard(boardPk){
		location.href = "/board/modeSel?boardPk="+boardPk;
	}
	

</script>
</body>
</html>