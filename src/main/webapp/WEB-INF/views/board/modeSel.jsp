<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
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
<script>
	$(document).ready(function(){
		$('#soloPlay_div').click(function(){
			var boardPk = $('#boardPk').val()
			var userName = $('#userName').val()
			if(userName == '' || userName == null || userName == undefined){
				alert('닉네임을 입력해 주세요')
				return
			}else{
				location.href = "/board/soloGameBoard?boardPk="+boardPk+"&userName="+userName;	
			}
			
		})		
		
		$('#multiPlay_div').click(function(){
			var boardPk = $('#boardPk').val();
			var userName = $('#userName').val();
			
			if(userName == '' || userName == null || userName == undefined){
				alert('닉네임을 입력해 주세요')
				return
			}else{
				var form = document.createElement('form');
				form.setAttribute('method', 'post');
			    form.setAttribute('action', '/board/multiGameBoard');
				document.charset = 'URF-8';
				var params = {
						boardPk : boardPk,
						userName : userName,
						createRoom : 1,
						userRole : 1
				}
				for(var key in params){
					var hiddenField = document.createElement('input');
				      hiddenField.setAttribute('type', 'hidden');
				      hiddenField.setAttribute('name', key);
				      hiddenField.setAttribute('value', params[key]);
				      form.appendChild(hiddenField);
				}
				
				document.body.appendChild(form);
				form.submit();	
			}
		})
	})
</script>
</html>