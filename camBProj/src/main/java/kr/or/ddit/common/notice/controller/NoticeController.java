package kr.or.ddit.common.notice.controller;

import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import kr.or.ddit.common.notice.service.NoticeService;
import kr.or.ddit.common.notice.vo.NoticeVO;
import kr.or.ddit.util.file.controller.FileController;
import kr.or.ddit.util.file.vo.AttachFileVO;


@Controller
@RequestMapping("/common/notice/")
public class NoticeController {
	
	@Autowired
	private NoticeService noticeService;
	@Autowired
	FileController fileController;	
	
	Logger logger = LoggerFactory.getLogger(NoticeController.class);
	
	//리스트
	@RequestMapping(value="/noticeList", method=RequestMethod.GET)
	public String noticeList(Model model, @RequestParam(defaultValue = "1") String pageNo, @RequestParam Map<String, Object>map){
		
		if(map.get("pageNo")==null) {
			logger.info("pageNo null");
			map.put("pageNo", 1);
		}
		if(map.get("search")==null) {
			logger.info("search null");
			map.put("search", "");
		}
		if(map.get("keyword")==null) {
			logger.info("keyword null");
			map.put("keyword", "");
		}
		
		logger.info("map : "+ map);
		List<NoticeVO> list = this.noticeService.noticeList(map);
		
		model.addAttribute("list", list);
		
		
		PaginationInfo paginationInfo = new PaginationInfo();
		int totalCnt = this.noticeService.selectCnt(map);
		model.addAttribute("totalCnt", totalCnt);
		paginationInfo.setTotalRecordCount(totalCnt);
		paginationInfo.setCurrentPageNo(Integer.parseInt(pageNo));
		paginationInfo.setRecordCountPerPage(5); 
		paginationInfo.setPageSize(5);
		
		model.addAttribute("paginationInfo", paginationInfo);	
			
		return "common/notice/noticeList";		
	}
	
	//등록창
	@RequestMapping(value="/noticeInsert",method=RequestMethod.GET)
	public String noticeInsert() {
		
		return "common/notice/noticeInsert";
	}
	
	//등록
	@RequestMapping(value="/noticeInsert",method=RequestMethod.POST)
	public String noticeInsertPost(@ModelAttribute NoticeVO noticeVo, Model model
								  ,@RequestParam(value="fileCheck", required=false) String fileCheck) {
		
		// --file 시작--
		String fileGrNum = "";
		if(fileCheck!=null) {
			fileGrNum = fileController.fileUpload(noticeVo.getFileList());
			noticeVo.setFileGrNum(fileGrNum);
		}
			// --file 끝--
	
		
		int result = this.noticeService.noticeInsert(noticeVo);

		return "redirect:/common/notice/noticeList";
	}
	//상세
	@RequestMapping(value="/noticeDetail",method=RequestMethod.GET)
	public String noticeDetail(@RequestParam String artcNum, Model model) {
		
		NoticeVO nv = this.noticeService.noticeDetail(artcNum);
			
		model.addAttribute("nv", nv);
		
		if(nv.getFileGrNum() != null) { // 파일이 들어 있을 경우
			List<AttachFileVO> fileList = fileController.fileList(nv.getFileGrNum());
			model.addAttribute("fileList", fileList);
		}
		return "common/notice/noticeDetail";
	}
	
	//삭제
	@RequestMapping(value="/noticeDelete",method = RequestMethod.POST)
	public String noticeDelete(@RequestParam String artcNum) {
		
		int del = this.noticeService.noticeDelete(artcNum);
		
	return "redirect:/common/notice/noticeList";
	}
	
	//수정
	@RequestMapping(value="/noticeUpdate", method = {RequestMethod.GET})
	public String noticeUpdate(@RequestParam String artcNum, Model model) {
		
		NoticeVO nv = this.noticeService.noticeDetail(artcNum);
		model.addAttribute("nv", nv);
		
		if(nv.getFileGrNum() != null) { // 파일이 들어 있을 경우
			List<AttachFileVO> fileList = fileController.fileList(nv.getFileGrNum());
			model.addAttribute("fileList", fileList);
		}
		
		return "common/notice/noticeUpdate";
	}
	
	@RequestMapping(value="/noticeUpdate", method = {RequestMethod.POST})
	public String noticeUpdatePost(@ModelAttribute NoticeVO noticeVo, Model model
			, @RequestParam(value="fileCheck",required = false) String fileCheck) {
		
		

		if(fileCheck!=null) {
			String fileGrNum = fileController.fileUpload(noticeVo.getFileList());
			noticeVo.setFileGrNum(fileGrNum);
			
		}
		
		
		int result = this.noticeService.noticeUpdate(noticeVo);
		
		return "redirect:/common/notice/noticeDetail?artcNum="+ noticeVo.getArtcNum();
	}
	
	
}
