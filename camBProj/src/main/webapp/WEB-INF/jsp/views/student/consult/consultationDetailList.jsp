<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/core" prefix="c" %>
<script src="/resources/js/jquery.min.js"></script>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<div class="card shadow">
	<div class="card-header">
		<h6 class="card-title m-0 font-weight-bold text-primary">상담신청 상세</h6>
	</div>
	<div class="card-body">
		<form id="updateForm">
			<!-- 자동으로 들어가는 데이터, 안보이기 -->
			<div class="row" style="display:none">
				<div class="col-sm-2">
					<div class="form-group">
						<!-- 상담 번호 -->
						<input type="text" class="form-control" id="consultNum"
							name="consultNum" value="${vo.consultNum}">
					</div>
				</div>
				<div class="col-sm-2">
					<div class="form-group">
						<!-- 학생 아이디 -->
						<input type="text" class="form-control" id="stdId" name="stdId"
							value="${vo.stdId}">
					</div>
				</div>
				<div class="col-sm-2">
					<div class="form-group">
						<!-- 처리상태 -->
						<select class="form-control" id="procStatCode" name="procStatCode">
							<c:forEach var="code" items="${proSta}">
								<option value="${code.codeVal}"
									<c:if test="${vo.procStatCode == code.codeVal}">selected</c:if>>${code.codeName}</option>
							</c:forEach>
						</select>
					</div>
				</div>
			</div>
			<!-- 보이는 영역 -->
			<div class="row">
				<div class="col-sm-4">
					<div class="form-group">
						<label>상담방법</label><span style="color: red;">*</span> <select
							class="form-control studentArea" id="consultTypeCode" name="consultTypeCode">
							<c:forEach var="code" items="${conTyp}">
								<option value="${code.codeVal}"
									<c:if test="${vo.consultTypeCode == code.codeVal}">selected</c:if>>${code.codeName}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="col-sm-4">
					<div class="form-group">
						<label>상담목적</label><span style="color: red;">*</span> <select
							class="form-control studentArea" id="consultGoalCode" name="consultGoalCode">
							<c:forEach var="code" items="${conGoa}">
								<option value="${code.codeVal}"
									<c:if test="${vo.consultGoalCode == code.codeVal}">selected</c:if>>${code.codeName}</option>
							</c:forEach>
						</select>
					</div>
				</div>
				<div class="col-sm-4">
					<div class="form-group">
						<label>상담동기</label><span style="color: red;">*</span> <select
							class="form-control studentArea" id="consultMotiveCode"
							name="consultMotiveCode">
							<c:forEach var="code" items="${conMot}">
								<option value="${code.codeVal}"
									<c:if test="${vo.consultMotiveCode == code.codeVal}">selected</c:if>>${code.codeName}</option>
							</c:forEach>
						</select>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-6">
					<div class="form-group">
						<label>상담원</label><span style="color: red;">*</span> <input
							type="hidden" class="form-control" id="consultSchdlNum"
							name="consultSchdlNum" value="${vo.consultSchdlNum}"> <input
							type="hidden" class="form-control" id="consultSchdlNumBefore"
							value="${vo.consultSchdlNum}" /> <input type="text"
							class="form-control studentArea" id="profId"
							value="${vo.profInformation}">
					</div>
				</div>
				<div class="col-sm-2" style="padding-top: 30px;">
					<div class="form-group">
						<button type="button" class="btn btn-default studentArea"
							style="border-color: gray; width: 100%;" data-toggle="modal"
							data-target="#exampleModal">예약확인</button> <!-- modal창 -->
					</div>
				</div>
				<div class="col-sm-4">
					<div class="form-group">
						<label>상담일시</label><span style="color: red;">*</span> <input
							type="text" class="form-control studentArea" id="ConsultDate" value="${vo.consultTime}">
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label>상담내용</label><span style="color: red;">*</span>
						<textarea class="form-control studentArea" rows="3" id="consultContent"
							name="consultContent">${vo.consultContent}</textarea>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label>상담결과</label>
						<textarea class="form-control" rows="3" id="consultResult"
							name="consultResult" disabled>${vo.consultResult}</textarea>
					</div>
				</div>
			</div>
			<div class="row">
				<div class="col-sm-12">
					<div class="form-group">
						<label for="fileList">첨부파일</label><span style="color: red;">*</span>
						<div class="input-group">
							<div class="custom-file">
								<input type="file" class="custom-file-input studentArea"
									id="fileList" name="fileList" multiple> <label
									class="custom-file-label" for="fileList" id="fileName"></label>
							</div>
						</div>
						<div id="setFileName">
							<c:forEach items="${fileList}" var="getFile">
								<div style="margin-top: 5px;">
									<!-- 파일 다운로드 참고용 (수정 페이지에서는 원래 다운로드 기능 쓰지 않음) -->
									<a href="/fileDownload?filePath=${getFile.filePath}"
										style="margin-right: 5px;">${getFile.originFileName}</a> <input
										type="hidden" name="fileGrNum" value="${getFile.fileGrNum}" />
								</div>
							</c:forEach>
						</div>
						<!-- 파일이 들어왔는지 확인 -->
						<div style="display: none;">
							<input type="checkbox" name="fileCheck" id="fileCheck">
						</div>
					</div>
				</div>
			</div>
			<div class="card-footer" id="updateAndDeleteArea"
				style="background-color: white; border-top-color: white; float: right; padding-right: 0px;">
				<button type="button" class="btn btn-primary" id="btnUpdate"
					style="width: 120px;">수정</button>
				<button type="button" class="btn btn-default"
					style="background-color: white; border-color: gray; width: 120px;"
					id="btnDelete">삭제</button>
				<button type="button" class="btn btn-default"
					style="background-color: white; border-color: gray; width: 120px;"
					onclick="javasciprt:location.href='/student/consult/consultationList'">목록</button>
			</div>
			<div class="card-footer" id="updateArea"
				style="background-color: white; border-top-color: white; float: right; padding-right: 0px; display: none;">
				<button type="button" class="btn btn-primary" id="btnSubmit"
					style="width: 120px;">저장</button>
				<button type="button" class="btn btn-default"
					style="background-color: white; border-color: gray; width: 120px;"
					id="btnCancel">취소</button>
				<button type="button" class="btn btn-default"
					style="background-color: white; border-color: gray; width: 120px;"
					onclick="javasciprt:location.href='/student/consult/consultationList'">목록</button>
			</div>
		</form>
	</div>
</div>

<!-- Modal -->
<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog"
	aria-labelledby="exampleModalLabel" aria-hidden="true" data-backdrop="static">
	<div class="modal-dialog" role="document" style="max-width: 100%; width: auto; display: table;">
		<div class="modal-content">
			<div class="modal-header">
				<h5 class="modal-title" id="exampleModalLabel">상담일정</h5>
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">&times;</span>
				</button>
			</div>
			<div class="modal-body">
			
				<div class="row" style="margin-top: 20px;">
					<div class="col-12">
						<form id="frmSearch" name="frmSearch">
							<div style="float: right;">
								<div class="form-group" style="display: inline-block;">
									<input type="text" class="form-control"
										id="porfInformation" name="selSearch" placeholder="상담원을 입력해주세요."
										value="${param.selSearch}">
								</div>
								<div style="display: inline-block;">
									<button type="submit" class="btn btn-primary btn-icon-split"
										style="margin-bottom: 5px;">
										<span class="icon text-white-50"> <i
											class="fas fa-search"></i>
										</span>
									</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			
				<div class="row">
					<div class="col-12">
						<div class="card">
							<div class="card-header">
								<h6 class="card-title m-0 font-weight-bold text-primary">상담일정</h6>
							</div>
							<div class="card-body table-responsive p-0">
								<table class="table text-nowrap" id="sel">
									<thead>
										<tr>
											<td>순번</td>
											<td style="display: none;">상담번호</td>
											<td>상담원</td>
											<td>학과</td>
											<td>상담 일자</td>
											<td>시작 시간</td>
											<td>종료 시간</td>
											<td>잔여석</td>
											<td>정원</td>
										</tr>
									</thead>
									<tbody>
										<c:forEach var="row" items="${vo2}">
											<tr id="table_sel" onclick="setVal(this);" class="trClick">
												<td>${row.rnum}</td>
												<td id="consultScheduleNum" style="display: none;">${row.consultSchdlNum}</td>
												<td>${row.name}</td>
												<td>${row.department}</td>
												<td>${row.consultAvlDate}</td>
												<td>${row.startTime}</td>
												<td>${row.endTime}</td>
												<td>${row.capSeat}</td>
												<td>${row.cap}</td>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</div>
						</div>
						<div class="row">
							<div id="paging" class="col-sm-12 text-center">
								<ui:pagination paginationInfo="${paginationInfo}" type="image"
  									jsFunction="linkPage" />
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-secondary" data-dismiss="modal">닫기</button>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	
	$(function(){

		if($("#consultResult").val() != ""){ //왜 null이 안먹힐까?
			//수정삭제가 불가능 해도 목록으로는 가야함.
			$("#updateAndDeleteArea > button").not('#updateAndDeleteArea > button:eq(2)').attr('disabled', true);
		}else{
			$("#updateAndDeleteArea > button").attr('disabled', false);
		}
		
		$(".studentArea").attr("disabled", "disabled");	//수정 버튼 누르기 전에는 disabled속성 적용하고 수정을 클릭하면 풀기
		
// 		if($("#consultResult").text() != ""){ //textarea는 text()로 해야하고 input은 val()임
// 			$("#updateAndDeleteArea > button").attr('disabled', true);
// 		}else{
// 			$("#updateAndDeleteArea > button").attr('disabled', false);
// 		}
		
		//파일 수정
		$("#fileList").on("change", function(e) {
			$("#fileCheck").prop("checked", true);
			fileExtnsImgPdf(e); // 확장자 검사 & 파일 이름 출력
		});
		
		//수정버튼 클릭
		$("#btnUpdate").on("click",function(){
			$("#updateAndDeleteArea").css("display","none");
			$("#updateArea").css("display","block");
			$(".studentArea").removeAttr("disabled");
			$("select").removeAttr("onFocus").removeAttr("onChange");
		});
		
		//저장버튼 클릭
		$("#btnSubmit").on("click",function(){
			
			var consultSchdlNumBefore = $("#consultSchdlNumBefore").val();
			console.log(consultSchdlNumBefore);
			
			var json = {
					"consultSchdlNumBefore" : consultSchdlNumBefore
			};
			
			$.ajax({
				url : "/student/consult/scheduleNumBefore",
				data : JSON.stringify(json),
				contentType : "application/json; charset=UTF-8", //보낼타입
				dataType : "json", //받을타입
				type : "post",
				success : function(data) {
					console.log(data);
					if(data == 1){
						$("form").attr({
							action:"/student/consult/consultationUpdate",
							enctype:"multipart/form-data",
							method:"post"//attr속성 여러개 주는법
						}).submit();
						
					}
				},
				error : function(xhr) {
					alert("에러");
				}
			});
			
		}); 
		
		//취소버튼 클릭
		$("#btnCancel").on("click",function(){
			var input = confirm("취소된 내역은 저장되지 않습니다. 정말 취소하시겠습니까?");
			if(input){
// 				histroy.go(-1);
				$(location).attr('href','/student/consult/consultationDetailList?consultNum=${vo.consultNum}');
				$("#btnUpdate").trigger('click');	//안먹힘...
			}else{
				return;
			}
		});
		
		//삭제버튼 클릭
		$("#btnDelete").on("click",function(){
			
			var input = confirm("삭제된 내역은 복구되지 않습니다. 정말 삭제하시겠습니까?");
			if(input){
				$(location).attr('href','/student/consult/consultationDelete?consultNum=${vo.consultNum}');
			}else{
				return;
			}
		});
		
// 		$('#exampleModal').modal({
// 			backdrop:"static"
// 		});
		
		//모달 함수
		function closeModal(){
// 			$('#exampleModal').hide();
			$(".modal-dialog").attr("data-dismiss","modal");
		}
		
		modalFunc = closeModal;	//jquery 함수를 javascript함수로 넘기기.
	});
	
	//--------------모달 영역----------------
	//페이징
	function linkPage(pageNo) {
		location.href = "/student/consult/consultationDetailList?consultNum=${vo.consultNum}&pageNo=" + pageNo;
	}	
	
	//선택 해서 부모창으로 넘기기
	function setVal(tr) {
		var tdList = $(tr).children('td');		
 		var capSeat = tdList[7].innerHTML;
 		
 		if(capSeat > 0){
			var consultSchdlNum  = tdList[1].innerHTML;
			var profInformation = tdList[2].innerHTML + "(" + tdList[3].innerHTML + ")";
			var ConsultDate = tdList[4].innerHTML + ":::" +  tdList[5].innerHTML + "~" + tdList[6].innerHTML;
			
			document.getElementById("consultSchdlNum").value = consultSchdlNum;
			document.getElementById("profId").value = profInformation;  
			document.getElementById("ConsultDate").value = ConsultDate; 
			
			modalFunc();	//제이쿼리 hide함수
 			
 		}else{
 			alert("잔여석이 없으므로 다른 시간을 선택해주시기 바랍니다.");
 			return;
 		}
	}
</script>