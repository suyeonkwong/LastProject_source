<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>

<style type="text/css">
	#titleTr > td{
			padding-left: 100px;
			padding-top: 25px;
	}
</style>

<div class="row">
	<div class="col-12">
		<div class="card shadow">
			<div class="card-header">
				<div style="display: inline-block;">
					<h6 class="card-title m-0 font-weight-bold text-primary">열람실별 실시간 좌석 정보</h6>
				</div>
				<div style="display: inline-block; float: right;">
					<button class="btn btn-primary" style="border: 1px; width: 150px;"
						onclick="javascript:history.go(-1)">이전</button>
				</div>
			</div>
			<div class="card-body table-responsive p-0">
				<table class="table text-nowrap" id="tableArea">
					<tr>
						<td width="100%;">
							<table width="100%" cellspacing="0" cellpadding="0">
								<tbody>
									<tr id="titleTr">
										<td>${roomVo.roomName}</td>
										<td>총 좌석 수 : ${roomVo.seatCnt}</td>
										<td>사용 좌석 수 : <sapn id="useCnt"></sapn></td>
										<td>잔여 좌석 수 : <sapn id="remainCnt"></sapn> </td>
										<td>시간 : <span id="nowTime"></span></td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
					<tr style="height: 400px;">
						<td style="width: 100%;">
								<div style="float: right; margin-right: 200px; margin-top: 26px;">
									<button style="border : 1px; ">미사용</button>
									<button style="border : 1px; background-color: red; color: yellow;">사용중</button>
								</div>
								<div id="seatArea"
								style="border: 2px solid black; width: 90%; margin-top: 50px; display: inline-block; margin-left: 70px;">
									<div id="a_line"></div>
									<br />
									<div id="b_line"></div>
									<div id="c_line"></div>
									<br />
									<div id="d_line"></div>
									<div id="e_line"></div>
									<br />
									<div id="f_line"></div>
									<div id="g_line"></div>
									<br />
									<div id="h_line"></div>
									<div id="i_line"></div>
									<br />
									<div id="j_line"></div>
									<div id="k_line"></div>
								</div>
								<div style="display: inline-block; margin-left: -18px; height: 100px;">
									<img alt="door" src="/resources/img/door_R.png"
										style="margin-bottom: 690px;" width="30px;">
								</div>
						</td>
					</tr>
				</table>
				<div style="display:none;">
					<form id="frmReservation">
						<input type="text" id="stdId" name="stdId"
							<c:if test="${sessionScope.student == '01'}">value="${memberVo.memId}"</c:if>>
						<input type="text" id="seatIdnNum" name="seatIdnNum"> 
						<input type="text" id="startTime" name="startTime">
						<input type="text" id="endTime" name="endTime">
					</form>
				</div>
				<br />
			</div>
		</div>
	</div>
</div>

<script type="text/javascript">
	
	$(function(){
		
		//자바스크립트 객체형태로 넣어줘야 하는데 이렇게 하면 값 못가져옴
// 		var seatVoList = new Array();
// 		<c:forEach var="seat" items="${seatVo}">
// 			seatVoList.push("${seat}");
// 		</c:forEach>
		
		var seatVoList = new Array();
		<c:forEach var="seat" items="${seatVo}">
		
			var seatVo = {
					 roomIdnNum : "${seat.roomIdnNum}"
					,seatIdnNum : "${seat.seatIdnNum}"
					,avlYn : "${seat.avlYn}"
					,seatNum : "${seat.seatNum}"
			}
			
			seatVoList.push(seatVo);
		</c:forEach>
		
		var seatNumArray = new Array();
		var seatIdnNumArray = new Array();
		var avlYnArray = new Array();
		
		//좌석 데이터
		for(var i = 0; i < seatVoList.length; i++) {
			var seatNumber = seatVoList[i].seatNum;
			seatNumArray.push(seatNumber);	//좌석이름 넣기
			
			var seatIdnNumber = seatVoList[i].seatIdnNum;
			seatIdnNumArray.push(seatIdnNumber);	//좌석번호 넣기
			
			var avlYnNumber = seatVoList[i].avlYn;
			avlYnArray.push(avlYnNumber);
		}
		
		console.log(seatNumArray);
		console.log(seatIdnNumArray);
		console.log(avlYnArray);
		
		var optsA = '';
		var optsB = '';
		var optsC = '';
		var optsD = '';
		var optsE = '';
		var optsF = '';
		var optsG = '';
		var optsH = '';
		var optsI = '';
		var optsJ = '';
		var optsK = '';
		
		for(var i=0; i<seatNumArray.length; i++){
			if(seatNumArray[i].indexOf("A") != -1){	//문자열 a가 담긴 배열값 갯수만큼 버튼 만들기
				
				optsA += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#a_line").html(optsA);
			
			if(seatNumArray[i].indexOf("B") != -1){	
				
				optsB += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
					
// 					for(var j=0; j<seatNumArray[i].length; j+=2){	//자리 띄우기
// 						console.log("gd");
// 					}
			}
			$("#b_line").html(optsB);
			
			if(seatNumArray[i].indexOf("C") != -1){	
				
				optsC += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#c_line").html(optsC);
			
			if(seatNumArray[i].indexOf("D") != -1){	
				
				optsD += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#d_line").html(optsD);
			
			if(seatNumArray[i].indexOf("E") != -1){	
				
				optsE += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#e_line").html(optsE);
			
			if(seatNumArray[i].indexOf("F") != -1){	
				
				optsF += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#f_line").html(optsF);
			
			if(seatNumArray[i].indexOf("G") != -1){	
				
				optsG += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#g_line").html(optsG);
			
			if(seatNumArray[i].indexOf("H") != -1){	
				
				optsH += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#h_line").html(optsH);
			
			if(seatNumArray[i].indexOf("I") != -1){	
				
				optsI += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#i_line").html(optsI);
			
			if(seatNumArray[i].indexOf("J") != -1){	
				
				optsJ += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#j_line").html(optsJ);
			
			if(seatNumArray[i].indexOf("K") != -1){	
				
				optsK += "<button value=" + seatIdnNumArray[i] + ">" + seatNumArray[i] + "</button>"
					+	"<input type='hidden' value=" + avlYnArray[i] + ">&nbsp;&nbsp;&nbsp;"
			}
			$("#k_line").html(optsK);
		}
		
		//테이블 부트스트랩 속성 없애기
		$("#tableArea").removeAttr("hover"); //안먹힘
		
		//버튼 디자인, 사용여부에 맞춰서 다르게 하기
		
		$("#seatArea > div > button").css({
				"width" : "60px",
				"height" : "40px",
				"border" : "1px"
// 				"border-radius" : "7px"
			});
			$("#seatArea > div").css("margin", "10px");

		// 		if($("#seatArea > div > input").val() == 'N'){ 안먹힘
			
		if ($("input[value='N']").children('#seatArea > div')) {
			$("input[value='N']").prev("button").css("background-color", "red");
			$("input[value='N']").prev("button").css("color", "yellow");
			$("input[value='N']").prev("button").prop("disabled",true);
			
			//잔여석 구하기 위해 갯수 세기
			var useCnt = $("input[value='N']").length;
			$("#useCnt").text(useCnt);
			var remainCnt = $("input[value='Y']").length;
			$("#remainCnt").text(remainCnt);
		}
		
		//현재 시간 구하기
		var now = new Date();
		var hours = now.getHours();
		var minutes = now.getMinutes();
		var seconds = now.getSeconds();
		
		if(seconds < 10) {
			if(hours < 10) {
				hours = "0" + String(hours);
			}else if (minutes < 10) {
				minutes = "0" + String(minutes);
			}else if (seconds < 10) {
				seconds = "0" + String(seconds);
			}
		}
		var nowTime = hours + ":" + minutes + ":" + seconds;	
		
		$("#nowTime").text(nowTime);

// 		function fillZero(width, seconds){
//  		    return seconds.length >= width ? str:new Array(width-seconds.length+1).join('0')+seconds;//남는 길이만큼 0으로 채움
// 		}
		
		//버튼 클릭하고 예약 
		$("#seatArea > div > button").on("click", function() {

			var seatNum = $(this).text(); //좌석명
			var seatIdnNum = $(this).val(); //식별번호

			$("#seatIdnNum").val(seatIdnNum); //예약 폼에 좌석식별번호 넣기

			var now = new Date();
			var hours = now.getHours();
			var minutes = now.getMinutes();
			var seconds = now.getSeconds();

			if (hours < 10) {
				hours = "0" + hours;
			} else if (minutes < 10) {
				minutes = "0" + minutes;
			} else if (seconds < 10) {
				seconds = "0" + seconds;
			}

			var startTime = hours + ":" + minutes + ":" + seconds;

			$("#startTime").val(startTime);

			var input = confirm(seatNum + "석을 예약 하시겠습니까?");

			var stdId = $("#stdId").val();
			console.log(stdId);

			var year = now.getFullYear();
			var month = now.getMonth() + 1;
			var day = now.getDate();

			if (month < 10) {
				month = "0" + month;
			} else if (day < 10) {
				day = "0" + day;
			}

			var date = year + "/" + month + "/" + day;
			console.log(date);

			var reservDate = date

			var json = {
				"stdId" : stdId,
				"reservDate" : reservDate
			}

			if (input) {

				$.ajax({
					url : "/student/readingRoom/ReservationSelect",
					data : JSON.stringify(json),
					contentType : "application/json; charset=UTF-8", //보낼타입
					dataType : "json", //받을타입
					type : "POST",
					success : function(data) {
						// 						console.log(data);
						//조회된 데이터가 있으면 alert로 예약 막기
						alert("현재 예약중인 좌석이 있습니다. 좌석을 변경하려면 예약석을 취소해주시기 바랍니다.");
					},
					error : function(xhr) {
						//조회된 데이터가 없으면 예약하기
						console.log(xhr);
						$("#frmReservation").attr({
							method : "post",
							action : "/student/readingRoom/seatReservation"
						}).submit();
					}
				});

			} else {
				return;
			}

		});

	});
</script>