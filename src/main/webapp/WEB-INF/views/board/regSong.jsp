<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>

h1{
  font-size: 30px;
  color: #fff;
  text-transform: uppercase;
  font-weight: 300;
  text-align: center;
  margin-bottom: 15px;
}
table{
  width:100%;
  table-layout: fixed;
}
.tbl-header{
  background-color: rgba(255,255,255,0.3);
 }
.tbl-content{
  height:300px;
  overflow-x:auto;
  margin-top: 0px;
  border: 1px solid rgba(255,255,255,0.3);
}
th{
  padding: 20px 15px;
  text-align: left;
  font-weight: 500;
  font-size: 12px;
  color: #fff;
  text-transform: uppercase;
}
td{
  padding: 15px;
  text-align: left;
  vertical-align:middle;
  font-weight: 300;
  font-size: 12px;
  color: #fff;
  border-bottom: solid 1px rgba(255,255,255,0.1);
}


/* demo styles */

@import url(https://fonts.googleapis.com/css?family=Roboto:400,500,300,700);
body{
  background: -webkit-linear-gradient(left, #25c481, #25b7c4);
  background: linear-gradient(to right, #25c481, #25b7c4);
  font-family: 'Roboto', sans-serif;
}
section{
  margin: 50px;
}


/* follow me template */
.made-with-love {
  margin-top: 40px;
  padding: 10px;
  clear: left;
  text-align: center;
  font-size: 10px;
  font-family: arial;
  color: #fff;
}
.made-with-love i {
  font-style: normal;
  color: #F50057;
  font-size: 14px;
  position: relative;
  top: 2px;
}
.made-with-love a {
  color: #fff;
  text-decoration: none;
}
.made-with-love a:hover {
  text-decoration: underline;
}


/* for custom scrollbar for webkit browser*/

::-webkit-scrollbar {
    width: 6px;
} 
::-webkit-scrollbar-track {
    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3); 
} 
::-webkit-scrollbar-thumb {
    -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,0.3); 
}

</style>
</head>
<body>


<section>
  <!--for demo wrap-->
  <h1>노래 리스트 만들기</h1>
  <form action="/proc/regSong" method="post" enctype="multipart/form-data" onsubmit="return submitChk()">
  <div class="tbl-header">
    <table cellpadding="0" cellspacing="0" border="0">
      <thead>
        <tr>
          <th>제목</th>
          <th>비밀번호</th>
          <th>대표 이미지</th>
        </tr>
      </thead>
    </table>
  </div>
  <div class="tbl-content">
    <table cellpadding="0" cellspacing="0" border="0">
      <tbody>
        <tr>
          <td><input type="text" placeholder="제목" name="title" id="title"></td>
          <td><input type="password" placeholder="비밀번호" name="password" id="password"> </td>
          <td>이미지 : <input type="file" name="songImg"></td>
        </tr>
      </tbody>
    </table>
  </div>
    <div class="tbl-header">
    <table cellpadding="0" cellspacing="0" border="0">
      <thead>
        <tr>
          <th>유튜브 주소</th>
          <th>정답 </th>
          <th>힌트</th>
          <th><button type="button" id="add_songList_btn">노래 목록 추가</button></th>
        </tr>
      </thead>
    </table>
  </div>
    <div class="tbl-content">
    <table cellpadding="0" cellspacing="0" border="0">
      <tbody id="songList_tbody">
        <tr id="songInfoTr1">
          <td><input type="text" placeholder="유튜브 주소" name="youtubeUrl" class="youtubeUrl"></td>
          <td><input type="text" placeholder="정답" name="answer" class="answer"> </td>
          <td><input type="text" placeholder="힌트" name="hint" class="hint"></td>
          <td><button type="button" onclick="removeTr(1)">X</button></td>
        </tr>
      </tbody>
    </table>
  </div>
  </form>  
</section>


	
	
</body>
<button onclick="submitChk()">테스트</button>
<script>
	let trNumber = 1;
	$(document).ready(function(){
		$('#add_songList_btn').click(function(){
			trNumber++
			$('#songList_tbody').append('<tr id="songInfoTr'+trNumber+'"></tr>');
			$('#songInfoTr'+trNumber).append('<td><input type="text" placeholder="유튜브 주소" name="youtubeUrl" class="youtubeUrl"></td> <td><input type="text" placeholder="정답" name="answer" class="answer"> </td> <td><input type="text" placeholder="힌트" name="hint" class="hint"></td><td><button type="button" onclick="removeTr('+trNumber+')">X</button></td>')
		})
	})
	
	function removeTr(trNumberParam){
		
		$('#songInfoTr'+trNumberParam).remove();
	}
	
	function submitChk(){
		let title = $('#title').val();
		let password = $('#password').val();
		if(title == null || title == ""){
			alert('제목을 입력해 주세요')
			return false;
		}else if(password == null || password == ""){
			alert('비밀번호를 입력해 주세요')
			return false;
		}
		return true;
	}
</script>
</html>