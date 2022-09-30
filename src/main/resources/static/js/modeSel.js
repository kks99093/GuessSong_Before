/**
 * 
 */
let modeSel = 0;
const regTypeUserName = /^[가-힣a-zA-z\s]{1,6}$/;
const regTypeTitle = /^.{3,30}$/;
 $(document).ready(function(){
		
		$('#soloPlay_div').click(function(){
			modeSel = 1
			$('#soloPlay_div').css('background-color', '#000000');
			$('#soloPlay_div').css('color', '#FFFFFF');
			$('#multiPlay_div').css('background-color', '#FFFFFF');
			$('#multiPlay_div').css('color', '#000000');
			$('.multi_div').css('display', 'none');
			$('.multi_input').val('');
			
		})
		
		
		$('#multiPlay_div').click(function(){
			modeSel = 2
			$('#soloPlay_div').css('background-color', '#FFFFFF');
			$('#soloPlay_div').css('color', '#000000');
			$('#multiPlay_div').css('background-color', '#000000');
			$('#multiPlay_div').css('color', '#FFFFFF');
			$('.multi_div').css('display', 'block');
						
			
		})		
		
		$('#create_btn').click(function(){
			let userName = $('#userName').val();
			userName = userName.trim();
			let title = $('#title').val();
			title = title.trim();
			let password = $('#password').val();
			password = password.trim();
			if(modeSel == 1){
				$('#createRoomFrm').attr('action', '/board/soloGameBoard')
				if(userName == null || userName == '' || !regTypeUserName.test(userName)){
					alert('닉네임을 1~6글자로 입력해 주세요')
					return;
				}else{
					$('#createRoomFrm').submit();
				}				
			}else if(modeSel == 2){
				$('#createRoomFrm').attr('action', '/board/multiGameBoard')
				if(userName == null || userName == '' || !regTypeUserName.test(userName)){
					alert('닉네임을 1~6글자로 입력해 주세요')
					return ;
				}else if(title == null || title == '' || !regTypeTitle.test(title)){
					alert('방제목을 3~30글자로 입력해 주세요')
					return ;
				}else{
					$('#createRoomFrm').submit();
				}
			}else{
				alert('모드를 선택해 주세요')
				return;
			}
			
		})
		
		
		
		
		
		
		
		
		
		
		
	})
	