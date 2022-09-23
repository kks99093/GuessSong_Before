<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="/css/gameList.css">
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; width=device-width;">
<title>게임 목록</title>
<style>

</style>
</head>
<body>
<div>
	<div class="table_title_div">
		<h3>게임 목록</h3>
	</div>	
	<table class="table_div">
		<thead>
			<tr>
			    <th class="text-left th_title">제목</th>
			    <th class="text-left th_reader">방장</th>
			    <th class="text-left th_amount">인원</th>
			    <th class="text-left th_pass">&#128274;</th>
			</tr>
		</thead>
		<tbody class="table-hover">
			<c:forEach var="gameRoom" items="${gameRoomList.content}">
				<tr class="gameList_tr" param1="${gameRoom.roomPk }" param2="${gameRoom.password != null ? '1' : ''}">
					<td class="text-left">${gameRoom.title } </td>
					<td class="text-left">${gameRoom.reader } </td>
					<td class="text-left">${gameRoom.headCount } / ${gameRoom.amount}</td>
					<td>
						<c:if test="${gameRoom.password != null }">
							&#128274;							
						</c:if>
					</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="page_div">
		<ul>
			<li class="${gameRoomList.pageable.pageNumber == 0 ? 'disable_evt disable_cursor' : '' }" onclick="pageMove(${gameRoomList.pageable.pageNumber-1})">이전</li>	
			<c:forEach begin="${startIdx+1}" end="${gameRoomList.totalPages > startIdx+10 ? startIdx+10 : gameRoomList.totalPages}" varStatus="status">
				<li class="${gameRoomList.pageable.pageNumber == status.index-1 ? 'disable_evt disable_cursor' : '' }" onclick="pageMove(${status.index-1})">${status.index }</li>
			</c:forEach>
			<li class="${gameRoomList.pageable.pageNumber == gameRoomList.totalPages-1 ? 'disable_evt disable_cursor' : '' }" onclick="pageMove(${gameRoomList.pageable.pageNumber+1})">다음></li>
		</ul>
	</div>
</div>

<div id="popup" class="hide">
  <div class="content">
  	<div class="pop_input_div">
  		<div id="pop_userName_div"><span>닉네임 : </span><input type="text" id="userName"></div>
  	</div>
  	<button id="playGame"> 들어가기</button>
    <button id="closePopup">닫기</button>
  </div>
</div>
<script>
	var roomNumber = 0;

	$(document).ready(function(){
		
		$('#closePopup').click(function(){
			const popup = document.querySelector('#popup');
			popup.classList.add('hide');
			$('#pop_password_div').remove();
			roomNumber = 0;
		})
		
		//팝업
		$('.gameList_tr').click(function(){
			const popup = document.querySelector('#popup');
			popup.classList.add('has-filter');
			popup.classList.remove('hide');
			roomNumber = $(this).attr("param1");
			let passwordChkInput = $(this).attr("param2");
			if(passwordChkInput == 1){
				$('.pop_input_div').append('<div id="pop_password_div"><span>비밀번호 : </span><input type="password" id="password"><div>')
			}
		})
		
		
		$('#playGame').click(function(){
			let userName = $('#userName').val();
			let password = $('#password').val();
			
			let data = {
					roomPk : roomNumber,
					userName : userName,
					password : password
			}
			
			$.ajax({
				type: "POST",
				url : "/rest/userNameChk",
				data : JSON.stringify(data),
				contentType : "application/json; charset=utf-8",
				dataType: "json"
			}).done(function(resp){
				if(resp == 0){
					alert('현재 방에 동일한 이름을 사용하는 사람이 있습니다')
					return
				}else if(resp == -1){
					alert('비밀번호가 틀렸습니다').
					return;
				}else if(resp == -2){
					alert('인원이 가득 찼습니다.')
					return;
				}else{
					var form = document.createElement('form');
					form.setAttribute('method', 'post');
				    form.setAttribute('action', '/board/multiGameBoard');
					document.charset = 'URF-8';
					var params = {
							roomPk : roomNumber,
							userName : userName,
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

	})

	
	function pageMove(pageNumber){
		location.href = "/board/gameList?page="+pageNumber;
	}
	


</script>
</body>
</html>