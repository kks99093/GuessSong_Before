<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>     
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="/css/multiGameBoard.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

		
		<div class="gameBoard_container">
			<div class="gaomeBoard_songInfo">
			<c:choose>
				<c:when test="${userInfo.userRole == 1 }">
					<div class="border startGame_div" id="startGame_div"><span id="startGame_span">시작하기</span></div>
				</c:when>
				<c:otherwise>
					<div class="border startGame_div" id="readyGame_div"><span id="readyGame_span">레디</span></div>
				</c:otherwise>
			</c:choose>
				<div class="border skipSong_div" id="skip_div"><span id="skip_span">넘기기</span></div>
				<div class="border skipSong_div" id="skipCount_div"><span id="skipCount_span"></span></div>
				<div id="songHint_div"><span></span></div>
			</div>
			<div class="gameBoard_chat">
				<div class="chatOutput_div border" id="chatData"></div>
				<div class="chatInput_div"><input type="text" class="chatInput_input" id="chatInput"></div>
			</div>
			<div class="gameBoard_userInfo border">

			</div>			
		</div>
		<div id="youtubePlayer">
			<div id="player"></div>
		</div>
		<input type="hidden" value="${userInfo.userName }" id="userName">
		<input type="hidden" value="" id="sessionId">
		<input type="hidden" value="${gameRoom.roomPk }" id="roomNumber">
		<input type="hidden" value="${gameRoom.boardPk }" id="songBoardPk">		
		
		
<script src="/js/multiGameBoard.js"></script>
</body>
</html>