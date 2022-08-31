<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<script src="/js/jquery-3.6.0.min.js"></script>
<link rel="stylesheet" href="/css/regSong.css">
<meta charset="UTF-8">
<title>노래 등록하기</title>
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
          <td><button class="remove_btn" type="button" onclick="removeTr(1)">X</button></td>
        </tr>
      </tbody>
    </table>
  </div>
  <button class="submit_btn">등록</button>
  </form>  
</section>
</body>
<script>
	let trNumber = 1;
	$(document).ready(function(){
		$('#add_songList_btn').click(function(){
			trNumber++
			$('#songList_tbody').append('<tr id="songInfoTr'+trNumber+'"></tr>');
			$('#songInfoTr'+trNumber).append('<td><input type="text" placeholder="유튜브 주소" name="youtubeUrl" class="youtubeUrl"></td> <td><input type="text" placeholder="정답" name="answer" class="answer"> </td> <td><input type="text" placeholder="힌트" name="hint" class="hint"></td><td><button class="remove_btn" type="button" onclick="removeTr('+trNumber+')">X</button></td>')
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