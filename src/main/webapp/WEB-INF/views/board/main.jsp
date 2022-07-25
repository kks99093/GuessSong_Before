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
<style>
body{
	width: 100%;
	height: 100%;
	background-color: #F2F2F2;
}
.container{
	width: 100%;
	height: 100%;
	
}

.left_div{
	display: flex;
	background-color: white;
}

.left_border{
	margin : 10px;
	padding : 10px;
	border: 1px solid black;
    background: #85DCFF;
    color: white;
}

.left_span{
	font-size: 25px;
	font-weight: 500;

}
.rigth_div{
	display: flex;
    flex-direction: column;
}

.rigth_div .search_div{
	padding: 10px;
    margin: 10px;
    display: flex;
    justify-content: center;
    align-items: center;
    font-size : 20px;
}

#searchText{
	margin: 10px;
    min-width: 500px;
    font-size : 20px;
}

#search_span{
    margin: 10px;
    border: 1px solid black;
    padding: 0 10px;
    background: #85DCFF;
    color : white;
}

.songBoardList_div{
    padding: 10px;
    margin: 10px;
    display: flex;
    flex-wrap: wrap;
}

.songBoard_div{
	padding: 10xp;
	margin: 10px;
	background-color: white;
}

#board_title_div{
	margin:10px;
}
</style>
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
			<input type="text" placeholder="검색" name="searchText" id="searchText"><span id="search_span">검색</span>
		</div>
		<div class="songBoardList_div">
			<c:forEach var="songBoard" items="${songBoardList.content }">
				<div class="songBoard_div" id="songBoard_div" onclick="moveBoard(${songBoard.boardPk})">
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
					<div id="board_title_div">
							<span class="board_title_span">${songBoard.title}</span>
					</div>
				</div>
			</c:forEach>
		</div>
	</div>
</div>

<script>
	$(document).ready(function(){
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