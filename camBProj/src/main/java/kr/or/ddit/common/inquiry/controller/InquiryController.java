package kr.or.ddit.common.inquiry.controller;

import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;


import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;

import kr.or.ddit.common.inquiry.service.InquiryService;
import kr.or.ddit.common.inquiry.vo.InquiryVO;
import kr.or.ddit.common.inquiry.vo.ReplyVO;
import kr.or.ddit.common.login.vo.MemberVO;

import kr.or.ddit.util.file.controller.FileController;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class InquiryController {

	@Autowired
	FileController fileController; // 파일 처리 용

	private Logger logger = LoggerFactory.getLogger(this.getClass());

	@Autowired
	InquiryService inquiryService;

	@RequestMapping(value = "/common/inquiry/inquiryList", method = RequestMethod.GET)
	public String inquiryList(Model model, @ModelAttribute InquiryVO iqVo) throws Exception {

//		멤버 목록
		List<InquiryVO> list = this.inquiryService.inquiryList(iqVo);
		logger.info("list : " + list);
		model.addAttribute("list", list);
		
		String replyAnswer = iqVo.getReplyAnswer();
		
			model.addAttribute("adAns", replyAnswer );
		
			logger.info("adAns" +replyAnswer);
		
		
//		페이징 처리
		PaginationInfo pagination = new PaginationInfo();
		pagination.setCurrentPageNo(iqVo.getPageNo());
		pagination.setRecordCountPerPage(iqVo.getRecordCountPerPage());
		pagination.setPageSize(iqVo.getPageSize());
		pagination.setTotalRecordCount(this.inquiryService.totalMember(iqVo));

		int lastRecordIndex = pagination.getLastRecordIndex();

		if (lastRecordIndex > pagination.getTotalRecordCount()) {
			lastRecordIndex = pagination.getTotalRecordCount();
		}

		model.addAttribute("pagination", pagination);
		model.addAttribute("lastRecordIndex", lastRecordIndex);
		return "common/inquiry/inquiryList";
	}

	@RequestMapping(value = "/common/inquiry/inquiryInsert", method = RequestMethod.GET)
	public String inquiryInsert(Model model,@RequestParam(defaultValue = "1") String pageNo, HttpSession session) {
		model.addAttribute("pageNo", pageNo);
		
		MemberVO memberVo = (MemberVO) session.getAttribute("memberVo");
		logger.info("memberVo"  + memberVo);
		
		model.addAttribute("memberVo", memberVo);
		return "common/inquiry/inquiryInsert";
	}

	@RequestMapping(value = "/common/inquiry/inquiryInsert", method = RequestMethod.POST)
	public String inquiryInsertPost(@ModelAttribute InquiryVO iqVo
								  , @RequestParam(defaultValue = "1") String pageNo
								  , @RequestParam(value="fileCheck", required=false) String fileCheck
								  ,HttpSession session) {

		// 파일이 들어 있을 때만 실행
		String fileGrNum = "";
		if(fileCheck!=null) {
			fileGrNum = fileController.fileUpload(iqVo.getFileList());
			iqVo.setFileGrNum(fileGrNum);
		}
		
		logger.info("iqVo>>>>>>>>>" + iqVo);
		
		 int result = this.inquiryService.inquiryInsert(iqVo);
		 
		return "redirect:/common/inquiry/inquiryList";

	}
	
	  //상세내역
	   @RequestMapping(value="/common/inquiry/inquiryDetail",method=RequestMethod.GET)
	   public String inquDetail(@RequestParam String artcNum, Model model) {
	         
	      InquiryVO iv = this.inquiryService.inquDetail(artcNum);
	      
	      System.out.println("iv >>> " + iv);
	      
	      model.addAttribute("iv", iv);
	      
	      return "common/inquiry/inquiryDetail";
	   }
	   
	   //삭제
	   @RequestMapping(value="/common/inquiry/inquiryDelete",method = RequestMethod.GET)
	   public String inquDelete(@RequestParam String artcNum) {
	      
	      int del = this.inquiryService.inquiryDelete(artcNum);
	      
		return "redirect:/common/inquiry/inquiryList";

	   }
	   
	 //수정
		@RequestMapping(value="/common/inquiry/inquiryUpdate",method=RequestMethod.POST)
		public String inquiryUpdate(@ModelAttribute InquiryVO inquiryVo) {
			
			System.out.println("inquiryVO >>> " + inquiryVo);
					
			int result = this.inquiryService.inquiryUpdate(inquiryVo);
			
			return "redirect:/common/inquiry/inquiryDetail?artcNum="+inquiryVo.getArtcNum();
		}
		
		//댓글 리스트
	    @RequestMapping("/common/reply/replyList")
	    @ResponseBody
	    public List<ReplyVO> repalyList(@RequestBody Map<String, Object> map, Model model,ReplyVO rvVo) throws Exception{
	    	
	    	logger.info("map : "+ map);
	    	List<ReplyVO> list2 = this.inquiryService.replyList(map);
	    	logger.info("list2 : " + list2);
	    	model.addAttribute("list2", list2);
 	
	    	return list2;
	    	
	    }
	    
	    
		//댓글 입력
	    @ResponseBody
	    @RequestMapping("/common/reply/replyInsert")
	    public int replyInsert(@RequestBody Map<String, Object> map) throws Exception {
	    	
	    	logger.info("map >>> " + map);
	    	
	    	int result = this.inquiryService.replyInsert(map);
	    	
	    	return result;
	    }
	    
		//댓글 삭제	
	    @ResponseBody
	    @RequestMapping("/common/reply/replyDelete")
	    public int replyDelete(@RequestBody Map<String, Object> map)throws Exception {
	    	
	    	int result = this.inquiryService.replyDelete(map);
	    	
	    	return  result;
	    }

}
