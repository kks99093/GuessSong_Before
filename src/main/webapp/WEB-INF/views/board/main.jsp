<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal" var="principal"/>     
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<a href="/board/regSong">노래 등록</a>
	</div>
	<div>
		<button id="joinMultiGame">게임 참여하기</button>
	</div>
	<div>
		<c:forEach var="songBoard" items="${songBoardList.content}">
			<div id="songBoard_div" onclick="moveBoard(${songBoard.boardPk})">
				<div id="board_img_div">
					이미지 넣을 예정
				</div>
				<div id="board_title_div">
					${songBoard.title}
				</div>
			</div>
		</c:forEach>
	</div>
<script>
	$(document).ready(function(){
		$('#joinMultiGame').click(function(){
			location.href = "/board/gameList";
		})
		
		
	})
	function moveBoard(boardPk){
		location.href = "/board/modeSel?boardPk="+boardPk;
	}
	

</script>
</body>
</html>