<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<div>
		<div id="regSong_title_div" >
			<h1>노래 등록</h1>
		</div>
		<div id="add_songList_div">
			<button id="add_songList_btn">노래 추가</button>
		</div>
		<div id="songReg_snogInfo_div">
			<form action="/proc/regSong" method="post" >			
				<ul id="regSong_songInfo_addList_Ul">
					<li><button>등록</button></li>
					<li><span>제목 : <input type="text" placeholder="제목" name="title"></span></li>
					<li>
						<span>유튜브 주소 : </span><input type="text" placeholder="유튜브 주소" name="youtubeUrl">
						<span>정답 : </span><input type="text" placeholder="정답" name="answer"> 
						<span>힌트 : </span><input type="text" placeholder="힌트" name="hint">
					</li>
				</ul>				
			</form>
		</div>
	</div>
</body>
<script>
	$(document).ready(function(){
		$('#add_songList_btn').click(function(){
			$('#regSong_songInfo_addList_Ul').append('<li><span>유튜브 주소 : </span><input type="text" placeholder="유튜브 주소" name="youtubeUrl"> <span>정답 : </span><input type="text" placeholder="정답" name="answer"> <span>힌트 : </span><input type="text" placeholder="힌트" name="hint"></li>')
		})
	})
</script>
</html>