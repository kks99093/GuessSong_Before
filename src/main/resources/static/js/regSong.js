/**
 * 
 */
 let trNumber = $('#trNumber').val();
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
		}else if((password == null || password == "")){
			alert('비밀번호를 입력해 주세요')
			return false;
		}
		return true;
	}