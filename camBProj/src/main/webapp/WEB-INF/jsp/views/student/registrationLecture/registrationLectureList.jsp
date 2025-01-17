<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<style>
.table th {
	padding: 0.50rem;
	vertical-align: middle;
}

.table td {
	padding: 0.40rem;
	vertical-align: middle;
}

label, input {
	margin: 0px;
}

label {
	font-size: 0.8em;
	font-weight: bold;
}

.upper-card {
	height: 90px;
}

.down-card {
	height: 300px;
	overflow: auto;
}

#btnDiv {
	display: flex;
	align-items: center;
	padding-top: 8px;
}

.checkbox-inline {
	margin-right: 30px;
}

.grayTr {
	background-color: #F0F0F0;
	color: #505050;
}

.btnSns {
	width: 46px;
}

</style>

<div id="body">

	<p class="mb-4">
		<span id="info"></span>
	</p>


	<div class="row">
		<!-- 신청 목록 테이블 시작 -->
		<div class="col-sm-8">
		
			<div class="card shadow mb-4">
				<div class="card-header py-3">
					<h6 class="m-0 font-weight-bold text-primary">수강신청 완료 확인</h6>
				</div>
				
				<div class="card-body">

					<!-- 검색, 상태요약 시작 -->
					<div class="row">
						<!-- 검색 시작 -->
						<!--  form -->
						<form:form commandName="lectureOpenFormVO" action="/student/registrationLectureR/registrationLectureList" id="frm" name="frm" class="form-horizontal">
							<form:input path="searchLectureOpenVO.searchCondition" type="hidden" value="REGI"/> <!-- LECT-수강신청 / CART-장바구니 / REGI-신청완료  -->
							<form:hidden path="lectureOpenVO.lectOpenNum" id="lectOpenNum" />
							<form:hidden path="lectureOpenVO.univDeptNum" id="univDeptNum" />
							<form:hidden path="lectureOpenVO.grdtnRequYn" id="grdtnRequYn" />
							<form:hidden path="searchLectureOpenVO.pageNo" id="pageNo" />
							<form:hidden path="lectureOpenVO.saveToken" id="saveToken" />
						</form:form><!-- // 검색 끝 -->
						<!-- 상태 요약 시작 -->
						<div class="col-sm-12">
							<div class="card mb-4 py-3 border-left-primary">
								<div class="card-body upper-card">
									<div class="row no-gutters align-items-center">
										<div class="col mr-2">
											<label for="stdId" class="text-info">
												<c:out value="${lectureOpenFormVO.lectureOpenVO.year}"/>년도 
												<c:out value=" ${lectureOpenFormVO.lectureOpenVO.semCode}"/>학기 신청 학점
											</label>
											<div class="row no-gutters align-items-center">
												<div class="col-auto">
													<div class="h5 mb-0 mr-3 font-weight-bold text-gray-800">
														<span class="text-info">${registrationLectureCount}</span> 과목
													</div>
												</div>
												<div class="col-auto">
													<div class="h5 mb-0 mr-3 font-weight-bold text-gray-800">
														<span class="text-info">${credSum}</span> / <span>${credAvail}</span> 학점   
													</div>
												</div>
												<div class="col">
													<div class="progress progress-sm mr-2">
														<fmt:parseNumber var="credPercent" value="${credSum/credAvail*100}" integerOnly="true"/> 
														<div class="progress-bar bg-info" role="progressbar" style="width: ${credPercent}%" aria-valuenow="${credPercent}" aria-valuemin="0" aria-valuemax="100"></div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div><!-- // 상태 요약 끝 -->
					</div><!-- // 검색, 상태요약 끝 -->

					<div class="row">
						<c:if test="${registrationLectureList == '[]'}">
							<div class="col-lg-12 text-center">
								<img alt="빈 페이지" src="/resources/img/page/empty.png" style="height: 490px;">
								<p>신청 내역이 없습니다</p>
							</div>
						</c:if>
						<c:if test="${registrationLectureList != '[]'}">
							<c:forEach var="row" items="${registrationLectureList}">
		                        <div class="col-lg-4 mb-4">
		                             <div class="card text-black shadow">
		                                 <div class="card-body" title="${row.lectName}">
		                                 	 <h4>${row.lectName}</h4>
		                                 	 <div class="row mb-4">
			                                     <div class="col-lg-6 text-left">
			                                     	${row.name}
			                                     </div>
			                                     <div class="col-lg-6 text-right">
			                                     	${row.roomIdnName}
			                                     </div>
		                                     </div>
		                                     <div class="row">
			                                     <div class="col-lg-6 text-left">
			                                     	<button type="button" class="btn btn-sm btn-info" data-toggle="modal" data-target="#myModal" onclick="fn_showSyllabus('${row.lectOpenNum}');">강의 계획서</button>
			                                     </div>
			                                     <div class="col-lg-6 text-right">
			                                     	<button type="button" class="btn btn-sm btn-danger" onclick="fn_regLectDelete('${row.lectOpenNum}','${row.lectName}');">수강 취소</button>
			                                     </div>
		                                     </div>
		                                 </div>
		                             </div>
		                         </div>
							</c:forEach>
                         </c:if>
					</div>
				</div>
			</div>
		</div>
		<!-- // 신청 목록 테이블 끝 -->
	
		<!-- 신청 목록 시간표 시작 -->
		<div class="col-sm-4">
			<div class="card mb-4 py-3 border-left-primary">
				<div class="card-body">
					<div class="h5 mb-0 mr-3 font-weight-bold text-gray-800 text-center" style="padding-bottom: 10px;">시간표</div>
					<table class="table table-bordered dataTable text-center">
						<colgroup>
                   			<col width="16%;">
                   			<col width="16%;">
                   			<col width="16%;">
                   			<col width="16%;">
                   			<col width="16%;">
                   			<col width="16%;">
                   		</colgroup>
						<thead>
							<tr class="grayTr">
								<th style="width: 70px;">/</th>
								<th>월</th>
								<th>화</th>
								<th>수</th>
								<th>목</th>
								<th>금</th>
							</tr>
						</thead>
						<tbody id="tb">
							<c:forEach var="i" begin="1" end="15">
								<tr>
									<td>${i}교시 <br/> ${i + 8} : 00</td>
									<td class="mon" id="01${i}"></td>
									<td class="tue" id="02${i}"></td>
									<td class="wed" id="03${i}"></td>
									<td class="thu" id="04${i}"></td>
									<td class="fri" id="05${i}"></td>
								</tr>
							</c:forEach>
						</tbody>
					</table>

				</div>
			</div>
		</div>
		<!-- // 신청 목록 시간표 끝 -->
	</div>

	<jsp:include page="syllabus.jsp"></jsp:include>

</div>

<script>

	var jsonRegistrationLectureList = ${jsonRegistrationLectureList};
	var jsonLectTimeTableList = ${jsonLectTimeTableList};
	
	$(function() {
		
		fn_makeTimeTable();
		
	});
	
	// 시간표 데이터 가져와 뿌리기
	function fn_makeTimeTable() {
		var colorIdx = 1; // 시간표 색상 지정용
		for(i in jsonLectTimeTableList){
			if(i > 0 && jsonLectTimeTableList[i].lectOpenNum != jsonLectTimeTableList[i-1].lectOpenNum){ // i가 1 이상일 때 이전과 다른 과목이면  colorIdx + 1
				colorIdx++;
			}
			
			var txt = "<label>" + jsonLectTimeTableList[i].lectName + "</label><br /><label style='font-weight:lighter'>" + jsonLectTimeTableList[i].roomIdnName + "</label>";
			
			$("#" + jsonLectTimeTableList[i].dayCode + jsonLectTimeTableList[i].period).html(txt).addClass('C' + colorIdx);
		}
		genRowspan(); // 셀 병합
	}
	
	
</script>
