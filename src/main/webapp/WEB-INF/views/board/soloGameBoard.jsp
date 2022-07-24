<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<style >

	.border {
		border: solid black 1px;
	}
	
	.gameBoard_container{

	}
	
	.gameBoard_songInfo{
		width: 200px;
    	height: 200px;
		margin: auto;
	}
	#startGame_div{
		width: 100px;
	    height: 40px;
	    text-align: center;
	    margin: 10px auto;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	}

	
	#nextSong_div{
		width: 100px;
	    height: 40px;
	    text-align: center;
	    margin: 10px auto;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	}

	
	.gameBoard_chat{
	    width: 600px;
	    height: 350px;
	    margin: 10px 10px;
	}
	
	.chatOutput_div{
		width: 100%;
    	height: 300px;
    	overflow: auto;
    	background-color: #EEE6C4;
	}
	
	.chatInput_div{
	    width: 100%;
    	height: 40px;
    	text-align: right;
    	margin-top: 5px;	
	}
	
	.chatInput_input{
		width: 100%;
		height: 100%;
	}
	
	.gameBoard_userInfo{
	    width: 100%;
    	margin: 50px 10px 10px 10px;
	}
	
	.userName{
		width: 100px;
	    height: 50px;
	    text-align: center;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	}
	
	.userPoint{
	    width: 100px;
	    height: 50px;
	    margin-top: 10px;
	    text-align: center;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	}
	
	#youtubePlayer{
		display: none;
	}
	
	.answerColor{
		color: purple;
	}
</style>
</head>
<body>
		<c:forEach var="songInfo" items="${songList }" varStatus="status">		
			<input type="hidden" value="${songInfo.answer }" id="answer${status.index}">
			<input type="hidden" value="${songInfo.youtubeUrl}" id="url${status.index }" >
			<input type="hidden" value="${songInfo.hint }" id="hint${status.index }">
		</c:forEach>
		
		<div class="gameBoard_container">
			<div class="gaomeBoard_songInfo">
				<div class="border" id="startGame_div"><span id="startGame_span">시작하기</span></div>
				<div class="border" id="nextSong_div"><span>넘기기</span></div>
				<div id="songHint_div"><span></span></div>
			</div>
			<div class="gameBoard_chat">
				<div class="chatOutput_div border" id="chatData"><p>ddd</p><p>sss</p></div>
				<div class="chatInput_div"><input type="text" class="chatInput_input" id="chatInput"></div>
			</div>
			<div class="gameBoard_userInfo border">
				<div class="userName border"><span>${userName }</span></div>
				<div class="userPoint border"><span id="userPoint" >0</span></div>
			</div>			
		</div>
		<div id="youtubePlayer">
			<div id="player"></div>
		</div>
		
<script>

var songIndex = 0;
var userPoint = 0;
var player;
$(document).ready(function(){

	
	
	
	
	
	//게임 시작
	$('#startGame_span').click(function(){
		var tag = document.createElement('script');
		tag.src = "https://www.youtube.com/iframe_api";
		var firstScriptTag = document.getElementsByTagName('script')[0];
		firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
	})
	
	//다음노래
	$('#nextSong_div').click(function(){
		nextSong();		
	})
	
	//정답 확인
	$('#chatInput').keydown(function(key){
		if(key.keyCode == 13){
			//공백제거후 정답 비교
			var answer = $('#answer'+songIndex).val();
			answer = answer.split(' ').join('');
			
			var chat = $('#chatInput').val();
			//공백 제거 후 정답비교
			var userAnswer = chat.split(' ').join('');
			if(answer == userAnswer){
				$('#chatData').append('<p class="answerColor" >'+chat+'</p>')
				userPoint++
				$('#userPoint').html(userPoint);
				nextSong();
			}else{
				$('#chatData').append('<p>'+chat+'</p>')
			}
			$('#chatInput').val('');
			$('#chatData').scrollTop(600)
		}
		
	})
	
})




//ㅡㅡㅡ 유튜브 iframe apiㅡㅡㅡㅡ
function youtubePlay(){
	var tag = document.createElement('script');
	tag.src = "https://www.youtube.com/iframe_api";
	var firstScriptTag = document.getElementsByTagName('script')[0];
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
}

	
function onYouTubeIframeAPIReady(videoIdParam) {
	if(videoIdParam == null){
		elementId = 'url'+songIndex
		videoIdParam = document.getElementById(elementId).value;
	}
	
  	player = new YT.Player('player', {
    height: '300',
    width: '300',
    videoId: videoIdParam, //여기에 비디오 ID를 삽입한다. 
    playerVars: { 'autoplay': 1}
	//만약에 유튜브 공유 주소가 https://www.youtube.com/watch?v=Wac9LIURW1I라면 v=뒤의 값을 넣는다
	  });
}
//ㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡㅡ

function nextSong(){
	player.stopVideo()
	player.clearVideo()
	$('#player').remove();
	$('#youtubePlayer').append('<div id="player"></div>')
	songIndex++		
	var elementId = 'url' + songIndex
	var videoIdParam = document.getElementById(elementId).value
	onYouTubeIframeAPIReady(videoIdParam)
}


</script>
</body>
</html>