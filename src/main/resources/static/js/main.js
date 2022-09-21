/**
 * 
 */
 
 $(document).ready(function(){
		
		$('.drop_menu').click(function(){
			let boardPk = $(this).attr("param1")
			let displayStatus = $('#drop_menu_board'+boardPk).css('display')
			if(displayStatus === 'none'){
				$('#drop_menu_board'+boardPk).css('display', 'block')
			}else{
				$('#drop_menu_board'+boardPk).css('display', 'none')
			}
		})
		
		$('#joinMultiGame').click(function(){
			
				location.href = "/board/gameList";	
			
			
		})
		
		$('#regSong_btn').click(function(){
				location.href = "/board/regSong";
		})
		
		// 게시판 수정
		$('.update_board_div').click(function(){
			let boardPk = $(this).attr("param1");
			let password = prompt('비밀번호');
			
			let data = {
					boardPk : boardPk,
					password : password
			}
			
			$.ajax({
				type : "POST",
				url : "/rest/boardPassChk",
				data : JSON.stringify(data),
				contentType : "application/json; charset=utf-8",
				dataType : "json"
			}).done(function(resp){
				if(resp == 1){
					location.href = '/board/regSong?boardPk='+boardPk;
				}else{
					alert('비밀번호가 틀렸습니다.')
				}
			})
		})
		
		$('.delete_board_div').click(function(){
			let boardPk = $(this).attr("param1");
			let password = prompt('비밀번호');
			let data = {
					boardPk : boardPk,
					password : password
			}
			
			
			$.ajax({
				type : "POST",
				url : "/rest/boardPassChk",
				data : JSON.stringify(data),
				contentType : "application/json; charset=utf-8",
				dataType : "json"
			}).done(function(resp){
				if(resp == 1){
					if(confirm('정말 삭제 하시겠습니까?')){
						let boardPk = $(this).attr("param1")
						$.ajax({
							type: "POST",
							url : "/rest/boardDel",
							data : JSON.stringify(data),
							contentType : "application/json; charset=utf-8",
							dataType: "json"
						}).done(function(delResp){
							if(delResp == 1){
								location.reload();	
							}else{
								alert('삭제 할 수 없습니다. 관리자에게 문의 하세요');
							}
							
						})
					}
				}else{
					alert('비밀번호가 틀렸습니다.')
				}
			})
			
			

			
		})
		
		
		
		
		
	})
	
	
	function moveBoard(boardPk){
		location.href = "/board/modeSel?boardPk="+boardPk;
	}
	
	function pageMove(pageNumber){
		location.href = "/board/main?page="+pageNumber;
	}
	
	function searchBoard(){
		let searchText = $('#searchText').val()
		location.href = "/board/main?searchText="+searchText;
	}
	