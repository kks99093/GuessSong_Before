<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<meta name="viewport" content="initial-scale=1.0; maximum-scale=1.0; width=device-width;">
<title>Insert title here</title>
<style>
@import url(https://fonts.googleapis.com/css?family=Roboto:400,500,700,300,100);

body {
  background-color: #3e94ec;
  font-family: "Roboto", helvetica, arial, sans-serif;
  font-size: 16px;
  font-weight: 400;
  text-rendering: optimizeLegibility;
}

div.table-title {
   display: block;
  margin: auto;
  max-width: 600px;
  padding:5px;
  width: 100%;
}

.table-title h3 {
   color: #fafafa;
   font-size: 30px;
   font-weight: 400;
   font-style:normal;
   font-family: "Roboto", helvetica, arial, sans-serif;
   text-shadow: -1px -1px 1px rgba(0, 0, 0, 0.1);
   text-transform:uppercase;
}


/*** Table Styles **/

.table-fill {
  background: white;
  border-radius:3px;
  border-collapse: collapse;
  height: 320px;
  margin: auto;
  max-width: 600px;
  padding:5px;
  width: 100%;
  box-shadow: 0 5px 10px rgba(0, 0, 0, 0.1);
  animation: float 5s infinite;
}
 
th {
  color:#D5DDE5;;
  background:#1b1e24;
  border-bottom:4px solid #9ea7af;
  border-right: 1px solid #343a45;
  font-size:23px;
  font-weight: 100;
  padding:24px;
  text-align:left;
  text-shadow: 0 1px 1px rgba(0, 0, 0, 0.1);
  vertical-align:middle;
}

th:first-child {
  border-top-left-radius:3px;
}
 
th:last-child {
  border-top-right-radius:3px;
  border-right:none;
}
  
tr {
  border-top: 1px solid #C1C3D1;
  border-bottom-: 1px solid #C1C3D1;
  color:#666B85;
  font-size:16px;
  font-weight:normal;
  text-shadow: 0 1px 1px rgba(256, 256, 256, 0.1);
}
 
tr:hover td {
  background:#4E5066;
  color:#FFFFFF;
  border-top: 1px solid #22262e;
}
 
tr:first-child {
  border-top:none;
}

tr:last-child {
  border-bottom:none;
}
 
tr:nth-child(odd) td {
  background:#EBEBEB;
}
 
tr:nth-child(odd):hover td {
  background:#4E5066;
}

tr:last-child td:first-child {
  border-bottom-left-radius:3px;
}
 
tr:last-child td:last-child {
  border-bottom-right-radius:3px;
}
 
td {
  background:#FFFFFF;
  padding:20px;
  text-align:left;
  vertical-align:middle;
  font-weight:300;
  font-size:18px;
  text-shadow: -1px -1px 1px rgba(0, 0, 0, 0.1);
  border-right: 1px solid #C1C3D1;
}

td:last-child {
  border-right: 0px;
}

th.text-left {
  text-align: left;
}

th.text-center {
  text-align: center;
}

th.text-right {
  text-align: right;
}

td.text-left {
  text-align: left;
}

td.text-center {
  text-align: center;
}

td.text-right {
  text-align: right;
}

<!-- 팝업-->

button {
  height: 2.5em;
  cursor: pointer;
}

#popup {
  display: flex;
  justify-content: center;
  align-items: center;
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, .7);
  z-index: 1;
}

#popup.hide {
  display: none;
}

#popup.has-filter {
  backdrop-filter: blur(4px);
  -webkit-backdrop-filter: blur(4px);
}

#popup .content {
  padding: 20px;
  background: #fff;
  border-radius: 5px;
  box-shadow: 1px 1px 3px rgba(0, 0, 0, .3);
}

</style>
</head>
<body>
<div>
	<div class="table-title">
		<h3>게임 목록</h3>
	</div>	
	<table class="table-fill">
		<thead>
			<tr>
		    <th class="text-left">제목</th>
		    <th class="text-left">방장</th>
		    <th class="text-left">노래 제목</th>
			</tr>
		</thead>
		<tbody class="table-hover">
			<c:forEach var="gameRoom" items="${gameRoomList.content}">
				<tr onclick="showPopup(${gameRoom.roomPk})">
					<td class="text-left">${gameRoom.title } 타이틀</td>
					<td class="text-left">${gameRoom.reader } 이름</td>
					<td class="text-left">${gameRoom.songBoard.title} 노래제목</td>
				</tr>
			</c:forEach>
		</tbody>
	</table>
	<div class="page">
		<ul>
			<li onclick="pageMove(${gameRoomList.pageable.pageNumber-1})">이전</li>	
			<c:forEach begin="${startIdx+1}" end="${gameRoomList.totalPages > startIdx+10 ? startIdx+10 : gameRoomList.totalPages}" varStatus="status">
				<li onclick="pageMove(${status.index-1})">${status.index }</li>
			</c:forEach>
			<li onclick="pageMove(${gameRoomList.pageable.pageNumber+1})">다음></li>
		</ul>
	</div>
</div>

<div id="popup" class="hide">
  <div class="content">
  	<span>닉네임 : </span><input type="text" id="userName" placeHolder="닉네임">
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
			roomNumber = 0;
		})
		
		$('#playGame').click(function(){
			var userName = $('#userName').val();
			var data = {
					roomPk : roomNumber,
					userName : userName				
			}
			
			$.ajax({
				type: "POST",
				url : "/rest/userNameChk",
				data : JSON.stringify(data),
				contentType : "application/json; charset=utf-8",
				dataType: "json"
			}).done(function(resp){
				if(resp == 1){
					alert('현재 방에 동일한 이름을 사용하는 사람이 있습니다')
					return
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

	
	function showPopup(roomPk) {
		const popup = document.querySelector('#popup');
		popup.classList.add('has-filter');
		popup.classList.remove('hide');
		roomNumber = roomPk;
	}
	
	function pageMove(pageNumber){
		location.href = "/board/gameList?page="+pageNumber;
	}
	


</script>
</body>
</html>