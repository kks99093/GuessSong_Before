/**
 * 
 */
let modeSel = 0;
 $(document).ready(function(){
	/*
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
				document.charset = 'UTF-8';
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
		*/
		
		
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
				if(userName == null || userName == ''){
					alert('닉네임을 입력해 주세요')
					return;
				}else{
					$('#createRoomFrm').submit();
				}				
			}else if(modeSel == 2){
				$('#createRoomFrm').attr('action', '/board/multiGameBoard')
				if(userName == null || userName == ''){
					alert('닉네임을 입력해 주세요')
					return ;
				}else if(title == null || title == ''){
					alert('방제목을 입력해 주세요')
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
	