/**
 * 
 */
 
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