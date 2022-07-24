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
	<div class="modSel_container">
		<input type="hidden" id="boardPk" value="${boardPk}" >
		<div>
			<div id="soloPlay_div">솔로</div>
			<div id="multiPlay_div">멀티 만들기</div>
		</div>
		<div>
			<span>닉네임 : <input type="text" placeholder="닉네임" id="userName" ></span>
		</div>
	</div>
</body>
<script>
	$(document).ready(function(){
		$('#soloPlay_div').click(function(){
			var boardPk = $('#boardPk').val()
			var userName = $('#userName').val()
			location.href = "/board/soloGameBoard?boardPk="+boardPk+"&userName="+userName;
		})		
		
		$('#multiPlay_div').click(function(){
			var boardPk = $('#boardPk').val();
			var userName = $('#userName').val();
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
			
			//location.href = "/board/multiGameBoard?boardPk="+boardPk+"&userName="+userName+"&createRoom=1";
		})
	})
</script>
</html>