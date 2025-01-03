package com.team2.app.notice;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.team2.app.util.FileManager;
import com.team2.app.util.Pager;

@Service
public class NoticeService {
	
	@Autowired
	private NoticeMapper noticeMapper;
	
	@Autowired
	private FileManager fileManager;
	
	@Value("${app.upload}")
	private String path;
	
	
	
	public List<NoticeVO> getList(Pager pager) throws Exception{
		
		// 페이지가 1보다 작아질 경우 강제로 페이지값을 1로 만드는 작업
		if(pager.getPage() == null || pager.getPage() <= 1) {
			pager.setPage(1L);
		}
		
		// 부서 번호가 null 이거나 0보다 작을 경우 부서 번호를 강제로 0으로 만드는 작업
		if(pager.getDeptNum() == null || pager.getDeptNum() < 0) {
			pager.setDeptNum(0L);
		}
		
		
		pager.makeRow();
		
		long totalCount = noticeMapper.getTotalCount(pager);
		
		pager.makeNum(totalCount);
		
		return noticeMapper.getList(pager);
	}
	
	public NoticeVO getPost(NoticeVO noticeVO) throws Exception{
		
		noticeMapper.increaseHit(noticeVO);
		
		return noticeMapper.getPost(noticeVO);
	}
	
	public int writePost(NoticeVO noticeVO, MultipartFile[] attaches) throws Exception{
		
		int result = noticeMapper.writePost(noticeVO);
		
		if(attaches != null) {
			
			for(MultipartFile attach : attaches) {
				
				if(attach == null || attach.isEmpty()) {
					continue;
				}
				
				String fileName = fileManager.fileSave(path + "notice/", attach);
				
				NoticeFileVO noticeFileVO = new NoticeFileVO();
				
				noticeFileVO.setNoticeNum(noticeVO.getNoticeNum());
				noticeFileVO.setFileName(fileName);
				noticeFileVO.setOriName(attach.getOriginalFilename());
				
				result = noticeMapper.saveFile(noticeFileVO);
			}		
		}
		
		return result;
	}
	
	public int modifyPost(NoticeVO noticeVO, MultipartFile[] attaches) throws Exception{
		
		if (attaches != null) {

			for (MultipartFile attach : attaches) {

				if (attach == null || attach.isEmpty()) {
					continue;
				}

				String fileName = fileManager.fileSave(path + "notice/", attach);

				NoticeFileVO noticeFileVO = new NoticeFileVO();

				noticeFileVO.setNoticeNum(noticeVO.getNoticeNum());
				noticeFileVO.setFileName(fileName);
				noticeFileVO.setOriName(attach.getOriginalFilename());

				int result = noticeMapper.saveFile(noticeFileVO);
			}
		}
		
		return noticeMapper.modifyPost(noticeVO);
	}
	
	public int deletePost(NoticeVO noticeVO) throws Exception{
		
		return noticeMapper.deletePost(noticeVO);
	}
	
	
	public List<NoticeVO> preview() throws Exception{
		
		return noticeMapper.preview();
	}
	
	public int getEmpNum(NoticeVO noticeVO) throws Exception{
		
		return noticeMapper.getEmpNum(noticeVO);
	}

}
