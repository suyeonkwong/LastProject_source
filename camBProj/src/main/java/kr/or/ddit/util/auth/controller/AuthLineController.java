package kr.or.ddit.util.auth.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.or.ddit.util.auth.service.AuthService;
import kr.or.ddit.util.auth.vo.AuthLineStepVO;
import kr.or.ddit.util.auth.vo.AuthLineVO;
import kr.or.ddit.util.auth.vo.AuthStepVO;
import kr.or.ddit.util.code.service.CodeService;
import kr.or.ddit.util.code.vo.CodeVO;
import kr.or.ddit.util.format.service.FormatUtil;

/**
 * 09/17
 * - 생성/수정/삭제의 담당 관리자를 어떻게 설정할까? - 권한을 주는 기능 만들어야 할까?
 * @author PC-08
 */
@Controller
public class AuthLineController {
	
	@Autowired
	AuthService authService;
	@Autowired
	CodeService codeService; // 공통 코드 처리 용
	@Autowired
	FormatUtil formatUtil;
	
	/**
	 * 기본 결재 선 리스트
	 * 학생 별로 생성되는 학사 처리 용 결재선은 가져오지 않음 
	 * @return 리스트 목록
	 */
	@RequestMapping(value = "/auth/authLineList")
	public String authLineList(@ModelAttribute AuthLineStepVO authLineStepVo
							 , Model model) {
		// 페이징 처리
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(authLineStepVo.getPageNo());
		paginationInfo.setRecordCountPerPage(5);
		paginationInfo.setPageSize(5);
		paginationInfo.setTotalRecordCount(authService.authLineTotalCount(authLineStepVo));
		model.addAttribute("paginationInfo", paginationInfo);
		
		model.addAttribute("TotalCount", authService.authLineTotalCount(authLineStepVo));

		// 리스트 가져오기
		authLineStepVo.setFirstIndex(paginationInfo.getFirstRecordIndex()+1);  // 쿼리 쪽 페이징 처리
		authLineStepVo.setLastIndex(paginationInfo.getLastRecordIndex());	// 쿼리 쪽 페이징 처리
		List<AuthLineStepVO> authLineList = authService.authLineList(authLineStepVo);
		model.addAttribute("authLineList", authLineList);
		
		// 코드 종류
		List<CodeVO> codeList = codeService.codeList("AUT_LIN");
		model.addAttribute("codeList", codeList);
		
		// 검색한 정보 다시 보내기
		model.addAttribute("authLineStepVo", authLineStepVo);
		
		return "auth/authLine/authLineList";
	}
	
	/**
	 * 결재 선 생성
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/auth/authLineStepInsertView")
	public String authLineInsert(Model model) {
		List<CodeVO> codeList = codeService.codeList("AUT_LIN");
		model.addAttribute("codeList", codeList);
		
		return "auth/authLine/authLineStepInsert";
	}
	
	/**
	 * 결재 스텝 생성 위한 교직원 검색 팝업
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/auth/authStepSearchPopup")
	public String authStepSearchPopup(@ModelAttribute AuthStepVO authStepVo, Model model) {
		
		// 페이징 처리
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(authStepVo.getPageNo());
		paginationInfo.setRecordCountPerPage(5);
		paginationInfo.setPageSize(5);
		paginationInfo.setTotalRecordCount(authService.authStepCount(authStepVo));
		model.addAttribute("paginationInfo", paginationInfo);
		
		// 리스트 가져오기
		authStepVo.setFirstIndex(paginationInfo.getFirstRecordIndex()+1);  // 쿼리 쪽 페이징 처리
		authStepVo.setLastIndex(paginationInfo.getLastRecordIndex());	// 쿼리 쪽 페이징 처리
		List<AuthStepVO> authStep = authService.authStepSearch(authStepVo);
		
		model.addAttribute("authStep", authStep);
		return "auth/authLine/popup/authStepSearchPopup";
	}
	
	/**
	 * ajax 교직원 검색 팝업에서 검색 키워드 코드 보내기
	 * @param authLineStepVo
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/auth/authStepSearchKeyword", produces = "application/json; charset=utf8")
	public List<CodeVO> authLineSearchKeyword(@RequestBody Map<String, Object> map) {
		
		List<CodeVO> codeList = new ArrayList<>();
		String codeType = String.valueOf(map.get("codeType"));
		
		// 소속 학과는 따로 코드 메서드를 사용해야 함
		if("UNI_DEP".equals(codeType)) {
			codeList = codeService.univDeqtCodeList();
			return codeList;
		}
		
		codeList = codeService.codeList(codeType);
		// 회원 유형의 경우 학생 코드는 보내지 않음
		if("MEM_TYP".equals(codeType)) {
			for(int i=0; i<codeList.size(); i++) {
				if("01".equals(codeList.get(i).getCodeVal())) codeList.remove(i); 
			}
		}
		
		return codeList;
	}
	
	/**
	 * ajax 교직원 검색 팝업에서 교직원 검색 리스트 보내기
	 * @param authLineStepVo
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/auth/authStepSearch", produces = "application/json; charset=utf8")
	public Map<String, Object>authLineSearch(@RequestBody AuthStepVO authStepVo) {
		
		// 페이징 처리
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(authStepVo.getPageNo());
		paginationInfo.setRecordCountPerPage(5);
		paginationInfo.setPageSize(5);
		paginationInfo.setTotalRecordCount(authService.authStepCount(authStepVo));
		
		// 리스트 가져오기
		authStepVo.setFirstIndex(paginationInfo.getFirstRecordIndex()+1);  // 쿼리 쪽 페이징 처리
		authStepVo.setLastIndex(paginationInfo.getLastRecordIndex());	// 쿼리 쪽 페이징 처리
		List<AuthStepVO> authStepVoList = authService.authStepSearch(authStepVo);
		
		Map<String, Object> map = new HashMap<>();
		map.put("authStepVoList", authStepVoList);
		map.put("paginationInfo", paginationInfo);
		
		return map;
	}
	
	
	/**
	 * 결재 라인 생성
	 */
	@RequestMapping(value = "/auth/authLineStepInsert")
	public String authLineInsertPost(@ModelAttribute AuthLineStepVO authLineStepVo) {
		authService.authLineStepInsert(authLineStepVo);
		return "redirect:/auth/authLineList";
	}
	
	/**
	 * 결재 라인 상세 페이지
	 */
	@RequestMapping(value = "/auth/authLineDetailView")
	public String authLineDetailView(@ModelAttribute AuthLineStepVO authLineStepVo
									, Model model) {
		// 결재 선과 결재 스텝 정보 뿌리기 
		String authLineNum = authLineStepVo.getAuthLineNum();
		AuthLineStepVO authLine = authService.authLineDetail(authLineNum);
		authLine.setPageNo(authLineStepVo.getPageNo());
		List<AuthStepVO> authStepList = authService.authStepList(authLineNum);
		model.addAttribute("authLine", authLine);
		model.addAttribute("authStepList", authStepList);
		
		// 코드 종류
		List<CodeVO> codeList = codeService.codeList("AUT_LIN");
		model.addAttribute("codeList", codeList);
		
		return "auth/authLine/authLineDetail";
	}
	
	
	/**
	 * ajax : 결재 스텝 상세 정보 
	 */
	@ResponseBody
	@RequestMapping(value = "/auth/getAuthStepInfo", produces = "application/json; charset=utf8")
	public List<AuthStepVO> getAuthStepInfo(@RequestBody AuthStepVO authStepVo) {
		
		// 리스트 가져오기
		List<AuthStepVO> authStepVoList = authService.authStepList(authStepVo.getAuthLineNum());
		
		for(AuthStepVO vo : authStepVoList) {
			vo.setPhNum(formatUtil.phone(vo.getPhNum()));
		}
		return authStepVoList;
	}
	
	
	/**
	 * 결재 라인 수정 처리
	 * @return
	 */
	@RequestMapping(value = "/auth/authLineUpdate")
	public String authLineUpdate(@ModelAttribute AuthLineStepVO authLineStepVo) {
		authService.authLineUpdate(authLineStepVo);
		return "forward:/auth/authLineList";
	}
	
	/**
	 * 결재 라인 삭제
	 * @return
	 */
	@RequestMapping(value = "/auth/authLineDelete")
	public String authLineDelete(@ModelAttribute AuthLineVO authLineVo) {
		authService.authLineDelete(authLineVo.getAuthLineNum());
		return "forward:/auth/authLineList";
	}
}
