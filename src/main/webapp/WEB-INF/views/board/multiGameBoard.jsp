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

<div class="gameBoard_div">
	<div class="gameBoard_container">
		<div class="gameBoard_songInfo">
			<div class="skipSong_div" id="skip_div"><span id="skip_span">넘기기 <span id="skip_count_span"></span></span></div>
			<div class="skipSong_div" id="result_div"><span id="skip_span">결과창 보기 <span id="result_count_span"></span></span></div>
			<div id="songHint_div"><span></span></div>
		</div>
		<div class="gameBoard_chat">
			<div class="chatOutput_div border" id="chatData"></div>
			<div class="chatInput_div">
				<input type="text" class="chatInput_input" id="chatInput"> 
				<span class="chat_submit">전송</span>
			</div>
		</div>
		<div class="songListNum_div">
			<span>남은 곡 : </span><span id="currentSong">&nbsp;</span>&nbsp;/&nbsp;<span id="totalSong">&nbsp;</span>
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
</div>

<script src="/js/multiGameBoard.js"></script>
</body>
</html>