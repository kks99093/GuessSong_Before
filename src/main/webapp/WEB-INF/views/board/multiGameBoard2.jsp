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
	.startGame_div{
		width: 100px;
	    height: 40px;
	    text-align: center;
	    margin: 10px auto;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	}
	
	.nextGame_div{
		width: 100px;
	    height: 40px;
	    text-align: center;
	    margin: 10px auto;
	    display: flex;
	    align-items: center;
	    justify-content: center;
	}
	
	#nextSong_div{
		display: none;
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
				<div class="border nextGame_div" id="nextSong_div"><span id="nextSong_span">넘기기</span></div>
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
		<input type="hidden" value="${gameRoom.songBoard.boardPk }" id="songBoardPk">		
		
		
<script>



var ws;
var userName = $('#userName').val()
var roomNumber = document.getElementById('roomNumber').value
var songBoardPk = document.getElementById('songBoardPk').value
var youtubeUrl = "";


$(document).ready(function(){
	//게임시작
	$('#startGame_span').click(()=>{ 
		$('#startGame_div').remove();
		var payload = {
				type : 'gameStart',
				roomNumber : $('#roomNumber').val() 
		}
		ws.send(JSON.stringify(payload));
	})
	
	
	//넘기기
	$('#nextSong_span').click(()=>{
		nextSongMsg()
	})
})



function wsOpen(){
	ws = new WebSocket("ws://" + location.host + "/chating/"+roomNumber+"/"+songBoardPk+"/"+userName);
	wsEvt();
}
	
function wsEvt() {
	ws.onopen = function(data){
		//소켓이 열리면 초기화 세팅하기
	}
	
	ws.onmessage = function(data) {
		var msg = data.data;
		if(msg != null && msg.trim() != ''){
			var jsonObject = JSON.parse(msg);
			//ㅡㅡㅡㅡㅡㅡㅡ처음 접속시 id저장
			if(jsonObject.type == 'sessionId'){
				
				$('#sessionId').val(jsonObject.sessionId)
				$('.gameBoard_userInfo').append('<div class="userInfo_div"> <div class="userName border"><span>'+ userName +'</span></div> <div class="userPoint border"><span id="'+jsonObject.sessionId+'">0</span></div> </div>')
				
			//ㅡㅡㅡㅡㅡㅡㅡ유저정보 담기
			}else if(jsonObject.type == 'join'){
				if(jsonObject.user != null){
					//입장한 사람의 정보를 추가
					$('.gameBoard_userInfo').append('<div class="userInfo_div" id="'+jsonObject.user.sessionId+'_div"> <div class="userName border"><span>'+ jsonObject.user.userName +'</span></div> <div class="userPoint border"><span id="'+jsonObject.user.sessionId+'">0</span></div> </div>')
				}else{
					//다른사람정보를 추가
					for(i = 0; i < jsonObject.userList.length; i++){
						$('.gameBoard_userInfo').append('<div class="userInfo_div" id="'+jsonObject.userList[i].sessionId+'_div"> <div class="userName border"><span>'+ jsonObject.userList[i].userName +'</span></div> <div class="userPoint border"><span id="'+jsonObject.userList[i].sessionId+'_span">0</span></div> </div>')
					}
					
				}
			//ㅡㅡㅡㅡㅡㅡ유저가 나갔을 시 목록에서 지움
			}else if(jsonObject.type == 'left'){
				$('#'+jsonObject.sessionId+'_div').remove();
				
			//ㅡㅡㅡㅡㅡㅡ채팅 메시지 전송 받을시		
			}else if(jsonObject.type == 'message'){  
				if(jsonObject.answerChk == 1){ //정답일 경우
					$("#chatData").append("<p> 정답 : " + jsonObject.msg + "</p>");
					//10초후 다음노래
					nextSongInterval = setInterval(nextSongCount,1000)
					
				}else{ //정답이 아닐 경우
					$("#chatData").append("<p>" + jsonObject.msg + "</p>");	
				}	
			//ㅡㅡㅡㅡㅡㅡ게임 시작 받을시
			}else if(jsonObject.type =='gameStart'){ 
				//3초 카운트
				countDown(3);
				
				
				// 4초후 게임 시작
				setTimeout(()=>{
					youtubeUrl = jsonObject.songInfo;
					var tag = document.createElement('script');
					tag.src = "https://www.youtube.com/iframe_api";
					var firstScriptTag = document.getElementsByTagName('script')[0];
					firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
				},3000)	
			
			
			

				
			}else if(jsonObject.type =='nextSong'){//다음 노래 재생
				youtubeUrl = jsonObject.songInfo;
				nextSong()
			}
			
		}
	}

	document.addEventListener("keypress", function(e){
		if(e.keyCode == 13){ //enter press
			send();
		}
	});
}



function send() {
	var msg = $("#chatInput").val();
	var payload = {
			type : 'message',
			msg : $('#chatInput').val(),
			sessionId: $('#sessionId').val(),
			roomNumber : $('#roomNumber').val()
	}	
	ws.send(JSON.stringify(payload));
	$('#chatInput').val("");
}

wsOpen()

//카운트다운
function countDown(i){
	var interval = setInterval(()=>{
		$('#startGame_div').remove();
		$('.gaomeBoard_songInfo').append('<div class="border startGame_div" id="startGame_div"><span>'+ i +'</span></div>');
		if(i == 0){
			$('#startGame_div').remove();
			$('#nextSong_div').css('display', 'flex');
			clearInterval(interval)
		}
		i--
	},1000,i)	
}


//10초후 다음 노래
var nextSongCountI = 10
function nextSongCount(){
	console.log(nextSongCountI)
	if(nextSongCountI == 0){
		clearInterval(nextSongCount)
		nextSongCountI = 10
		nextSongMsg()
	}
	nextSongCountI--
}
var nextSongInterval = setInterval(nextSongCount,1000)
clearInterval(nextSongInterval);


//다음노래 메세지 소켓 전송
function nextSongMsg(){
	clearInterval(nextSongInterval)
	nextSongCountI = 10
	var payload = {
			type : 'nextSong',
			roomNumber : $('#roomNumber').val() 
	}
	ws.send(JSON.stringify(payload));
}



//ㅡㅡㅡ 유튜브 iframe apiㅡㅡㅡㅡ
function youtubePlay(){
	var tag = document.createElement('script');
	tag.src = "https://www.youtube.com/iframe_api";
	var firstScriptTag = document.getElementsByTagName('script')[0];
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
}

	
function onYouTubeIframeAPIReady() {
  	player = new YT.Player('player', {
    height: '300',
    width: '300',
    videoId: youtubeUrl, //여기에 비디오 ID를 삽입한다. 
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
	onYouTubeIframeAPIReady()
}



</script>		
</body>
</html>