<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<script src="/js/modeSel.js"></script>
<link rel="stylesheet" href="/css/modeSel.css">
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>	
	<div class="title_div">
		<span class="title_span">${songBoard.title }</span>
	</div>
	<div class="modSel_container">
		<input type="hidden" id="boardPk" value="${songBoard.boardPk}" >
		<div class="mode_div">
			<div id="soloPlay_div">
				<span>솔로</span>
			</div>
			<div id="multiPlay_div">
				<span>멀티</span>
			</div>
		</div>
		<div class="name_div">
			<span class="name_span">닉네임 : <input type="text" id="userName" ></span>
		</div>
	</div>
</body>
</html>