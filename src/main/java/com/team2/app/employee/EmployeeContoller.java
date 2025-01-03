package com.team2.app.employee;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.eclipse.tags.shaded.org.apache.regexp.recompile;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.context.SecurityContextImpl;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.team2.app.department.DepartmentVO;
import com.team2.app.haerin.orders.OrdersVO;
import com.team2.app.notification.NotificationService;
import com.team2.app.notification.NotificationType;
import com.team2.app.notification.NotificationVO;
import com.team2.app.positions.PositionsVO;
import com.team2.app.role.RoleVO;
import com.team2.app.util.Pager;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@RequestMapping("/employee/*")
@Controller
@Slf4j
public class EmployeeContoller {
	
	@Autowired
	EmployeeService employeeService;
	
	@Autowired
	PasswordEncoder passwordEncoder;
	
	@Autowired
	NotificationService notificationService;
	
	// ============================== 인사
	
	@GetMapping("list")
	public void getList(Model model, Pager pager, EmployeeVO employeeVO, Integer enabledFlag) throws Exception {
		
		log.info("pager : {}", pager);
		log.info("vo : {}", employeeVO);
		
		if(enabledFlag==null) {
			employeeVO.setHiredate(new Date(1L));
		} else if(enabledFlag==1) {
			employeeVO.setEnabled(true);
		} else if(enabledFlag==2) {
			employeeVO.setEnabled(false);
		}
		
		List<EmployeeVO> list = employeeService.getList(pager, employeeVO);
		
		model.addAttribute("list", list);
		model.addAttribute("pager", pager);
		
		List<DepartmentVO> deptList = employeeService.getDept(null);
		List<PositionsVO> posList = employeeService.getPos(null);
		List<RoleVO> roleList = employeeService.getRole(null);
		
		model.addAttribute("deptList", deptList);
		model.addAttribute("posList", posList);
		model.addAttribute("roleList", roleList);
		
	} 
	
	@PostMapping("list")
	public void getList(Model model, Pager pager, EmployeeVO employeeVO, Integer enabledFlag, String good) throws Exception {
		
		log.info("pager : {}", pager);
		log.info("vo : {}", employeeVO);
		
		pager.setPage(1L);
		
		if(enabledFlag==null) {
			employeeVO.setHiredate(new Date(1L));
		} else if(enabledFlag==1) {
			employeeVO.setEnabled(true);
		} else if(enabledFlag==2) {
			employeeVO.setEnabled(false);
		}
		
		if(employeeVO.getDeptNum()!=null) {
			model.addAttribute("dept",employeeVO.getDeptNum());
		}
		
		List<EmployeeVO> list = employeeService.getList(pager, employeeVO);
		
		model.addAttribute("list", list);
		model.addAttribute("pager", pager);
		
		List<DepartmentVO> deptList = employeeService.getDept(null);
		List<PositionsVO> posList = employeeService.getPos(null);
		List<RoleVO> roleList = employeeService.getRole(null);
		
		model.addAttribute("deptList", deptList);
		model.addAttribute("posList", posList);
		model.addAttribute("roleList", roleList);
		model.addAttribute("flag",enabledFlag);
		
	} 
	
	@GetMapping("delete")
	public void delete(EmployeeVO employeeVO) throws Exception {
		int result = employeeService.delete(employeeVO);
	}
	
	
	// ============================== 직원
	
	@ResponseBody
	@PostMapping("update")
	public int update(MultipartFile attach, String empAddress, HttpSession session) throws Exception {
		log.info("update: {}", empAddress);
		int result = 0;
		EmployeeVO employeeVO = getEmployeeVO(session);
		employeeVO.setEmpAddress(empAddress);
		result = employeeService.update(employeeVO, attach);
		
		log.info("update: {}",result);
		
		return result;
	}
	
	//비밀번호 변경
	@GetMapping("chpass")
	public void chpass() throws Exception {
		
	}
	
	@PostMapping("chpass")
	public String chpass(EmployeeVO employeeVO, String befpass, HttpSession session, Model model) throws Exception {
				
		EmployeeVO vo = getEmployeeVO(session);
		
		if(!passwordEncoder.matches(befpass, vo.getEmpPwd())) {
			model.addAttribute("result","새 비밀번호가 맞지 않습니다.");
			model.addAttribute("url","/employee/chpass");
			return "commons/message";
		} else if (!employeeVO.getEmpPwd().equals(employeeVO.getEmpPwdCheck())) {
			model.addAttribute("result","기존 비밀번호가 맞지 않습니다.");
			model.addAttribute("url","/employee/chpass");
			log.warn("pwdcheck");
			return "commons/message";
		}
		
		employeeVO.setEmpId(vo.getEmpId());
		
		employeeService.chpass(employeeVO);
		session.invalidate();
		
		return "redirect:/employee/login";
	}
	

	@GetMapping("join")
	public void join(Model model) throws Exception {
		
		//사번 자동생성
		
		EmployeeVO employeeVO = new EmployeeVO();
		
		LocalDateTime localDateTime = LocalDateTime.now();
		
		log.info("date : {}", localDateTime);
		
		String empId = "";
		
		empId = Integer.toString(localDateTime.getYear());
		
		empId = empId.substring(2)+localDateTime.getMinute()+localDateTime.getSecond();
		
		log.info("empId : {}", empId);
		
		Map<String, Object> map =new HashMap<>();
		
		List<DepartmentVO> deptList = employeeService.getDept(null);
		List<PositionsVO> posList = employeeService.getPos(null);
		List<RoleVO> roleList = employeeService.getRole(null);
		
		map.put("empId", empId);
		map.put("deptList", deptList);
		map.put("posList", posList);
		map.put("roleList", roleList);
		
		model.addAttribute("map", map);
		
	}
	
	@PostMapping("join")
	public String join(EmployeeVO employeeVO, MultipartFile attach, Model model) throws Exception {
			
		log.info("=========================================");
		log.info("join employee: {}", employeeVO);
		
		employeeService.join(employeeVO, attach);
			
		log.info("=========================================");
		log.info("등록 성공");
		
		model.addAttribute("url","/");
		model.addAttribute("result","사원 등록 완료");
		
		return "commons/message";
		
	}

	@GetMapping("fileDown")
	public String fileDown(HttpSession session, Model model) throws Exception {
		
		EmployeeVO employeeVO = getEmployeeVO(session);
		
		model.addAttribute("file",employeeVO.getEmployeeFileVO());
		
		return "fileDown";
	}

	@GetMapping("login")
	public void login() throws Exception {
	}

	@GetMapping("detail")
	public void detail(EmployeeVO employeeVO ,HttpSession session, Model model) throws Exception {
		log.info("detail vo: {}", employeeVO);
		if(employeeVO.getEmpId() == null) {
			employeeVO = getEmployeeVO(session);
		} else {
			employeeVO = employeeService.detail(employeeVO);			
		}
		model.addAttribute("vo", employeeVO);
	}
	
	@GetMapping("empList")
	public void empList(Model model ) throws Exception{

		List<EmployeeVO> list = employeeService.empList();
		log.info("=========================empList:{}",list);

		model.addAttribute("list", list);
	}
	
	//session에서 로그인한 유저 정보 꺼내오는 메소드
	private EmployeeVO getEmployeeVO(HttpSession session) throws Exception {
		SecurityContextImpl securityContextImpl = (SecurityContextImpl) session.getAttribute("SPRING_SECURITY_CONTEXT");

		SecurityContext sc = SecurityContextHolder.getContext();
		log.info("========= sc =========");
		log.info("sc: {}", sc);

		Authentication ac = sc.getAuthentication();
		log.info("========= ac =========");
		log.info("ac: {}", ac);

		EmployeeVO employeeVO = (EmployeeVO) ac.getPrincipal();
		log.info("========= memberVO =========");
		log.info("MemberVO: {}", employeeVO);
		log.info("Name: {}", ac.getName()); // username
		log.info("Detail: {}", ac.getDetails()); // sessionID\
		
		return employeeVO;
	}
	
	@PostMapping("empListUpdate")
	public String empListUpdate(OrdersVO ordersVO)throws Exception{
		employeeService.empListUpdate(ordersVO);
		employeeService.empListInsert(ordersVO);
		return "redirect:/employee/empList";
	}
}
