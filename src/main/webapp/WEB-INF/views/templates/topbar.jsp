<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<!-- Navbar Header -->
<nav
	class="navbar navbar-header navbar-header-transparent navbar-expand-lg border-bottom">
	<div class="container-fluid">

		<ul class="navbar-nav topbar-nav ms-md-auto align-items-center">

			<sec:authorize access="isAnonymous()">
				<li class="nav-item topbar-user" style="margin-right: 50px;"><a
					class="profile-pic" href="/employee/login">
						<div class="avatar-lg" style="align-content: center;"
							align="right">
							<i class="fas fa-key fa-2x" style="color: #a7a7a7;"></i>
						</div> <span class="profile-username"> <span class="fw-bold">로그인</span>
					</span>
				</a></li>
			</sec:authorize>
			<sec:authorize access="isAuthenticated()">

				<!-- <!-- 메세지 -->
				<!-- <li class="nav-item topbar-icon dropdown hidden-caret"><a
					class="nav-link dropdown-toggle" href="#" id="messageDropdown"
					role="button" data-bs-toggle="dropdown" aria-haspopup="true"
					aria-expanded="false"> <i class="fa fa-envelope"></i>
				</a>
					<ul class="dropdown-menu messages-notif-box animated fadeIn"
						aria-labelledby="messageDropdown">
						<li>
							<div
								class="dropdown-title d-flex justify-content-between align-items-center">
								Messages <a href="#" class="small">Mark all as read</a>
							</div>
						</li>
						<li>
							<div class="message-notif-scroll scrollbar-outer">
								<div class="notif-center">
									<a href="#">
										<div class="notif-img">
											<img src="../../resources/img/jm_denis.jpg" alt="Img Profile" />
										</div>
										<div class="notif-content">
											<span class="subject">Jimmy Denis</span> <span class="block">
												How are you ? </span> <span class="time">5 minutes ago</span>
										</div>
									</a> <a href="#">
										<div class="notif-img">
											<img src="../../resources/img/chadengle.jpg"
												alt="Img Profile" />
										</div>
										<div class="notif-content">
											<span class="subject">Chad</span> <span class="block">
												Ok, Thanks ! </span> <span class="time">12 minutes ago</span>
										</div>
									</a> <a href="#">
										<div class="notif-img">
											<img src="../../resources/img/mlane.jpg" alt="Img Profile" />
										</div>
										<div class="notif-content">
											<span class="subject">Jhon Doe</span> <span class="block">
												Ready for the meeting today... </span> <span class="time">12
												minutes ago</span>
										</div>
									</a> <a href="#">
										<div class="notif-img">
											<img src="../../resources/img/talha.jpg" alt="Img Profile" />
										</div>
										<div class="notif-content">
											<span class="subject">Talha</span> <span class="block">
												Hi, Apa Kabar ? </span> <span class="time">17 minutes ago</span>
										</div>
									</a>
								</div>
							</div>
						</li>
						<li><a class="see-all" href="javascript:void(0);">See all
								messages<i class="fa fa-angle-right"></i>
						</a></li>
					</ul></li> -->
				<!-- 메세지 -->
				<!-- 알림 -->
				<!-- <li class="nav-item topbar-icon dropdown hidden-caret"><a
					class="nav-link dropdown-toggle" href="#" id="notifDropdown"
					role="button" data-bs-toggle="dropdown" aria-haspopup="true"
					aria-expanded="false"> <i class="fa fa-bell"></i> <span
						class="notification">4</span>
				</a>
					<ul class="dropdown-menu notif-box animated fadeIn"
						aria-labelledby="notifDropdown">
						<li>
							<div class="dropdown-title">You have 4 new notification</div>
						</li>
						<li>
							<div class="notif-scroll scrollbar-outer">
								<div class="notif-center">
									<a href="#">
										<div class="notif-icon notif-primary">
											<i class="fa fa-user-plus"></i>
										</div>
										<div class="notif-content">
											<span class="block"> New user registered </span> <span
												class="time">5 minutes ago</span>
										</div>
									</a> <a href="#">
										<div class="notif-icon notif-success">
											<i class="fa fa-comment"></i>
										</div>
										<div class="notif-content">
											<span class="block"> Rahmad commented on Admin </span> <span
												class="time">12 minutes ago</span>
										</div>
									</a> <a href="#">
										<div class="notif-img">
											<img src="../../resources/img/profile2.jpg" alt="Img Profile" />
										</div>
										<div class="notif-content">
											<span class="block"> Reza send messages to you </span> <span
												class="time">12 minutes ago</span>
										</div>
									</a> <a href="#">
										<div class="notif-icon notif-danger">
											<i class="fa fa-heart"></i>
										</div>
										<div class="notif-content">
											<span class="block"> Farrah liked Admin </span> <span
												class="time">17 minutes ago</span>
										</div>
									</a>
								</div>
							</div>
						</li>
						<li><a class="see-all" href="javascript:void(0);">See all
								notifications<i class="fa fa-angle-right"></i>
						</a></li>
					</ul></li> -->
				<!-- 알림 -->
				<!-- 빠른메뉴 -->
				<!-- <li class="nav-item topbar-icon dropdown hidden-caret"><a
					class="nav-link" data-bs-toggle="dropdown" href="#"
					aria-expanded="false"> <i class="fas fa-layer-group"></i>
				</a>
					<div class="dropdown-menu quick-actions animated fadeIn">
						<div class="quick-actions-header">
							<span class="title mb-1">Quick Actions</span> <span
								class="subtitle op-7">Shortcuts</span>
						</div>
						<div class="quick-actions-scroll scrollbar-outer">
							<div class="quick-actions-items">
								<div class="row m-0">
									<a class="col-6 col-md-4 p-0" href="#">
										<div class="quick-actions-item">
											<div class="avatar-item bg-danger rounded-circle">
												<i class="far fa-calendar-alt"></i>
											</div>
											<span class="text">Calendar</span>
										</div>
									</a> <a class="col-6 col-md-4 p-0" href="#">
										<div class="quick-actions-item">
											<div class="avatar-item bg-warning rounded-circle">
												<i class="fas fa-map"></i>
											</div>
											<span class="text">Maps</span>
										</div>
									</a> <a class="col-6 col-md-4 p-0" href="#">
										<div class="quick-actions-item">
											<div class="avatar-item bg-info rounded-circle">
												<i class="fas fa-file-excel"></i>
											</div>
											<span class="text">Reports</span>
										</div>
									</a> <a class="col-6 col-md-4 p-0" href="#">
										<div class="quick-actions-item">
											<div class="avatar-item bg-success rounded-circle">
												<i class="fas fa-envelope"></i>
											</div>
											<span class="text">Emails</span>
										</div>
									</a> <a class="col-6 col-md-4 p-0" href="#">
										<div class="quick-actions-item">
											<div class="avatar-item bg-primary rounded-circle">
												<i class="fas fa-file-invoice-dollar"></i>
											</div>
											<span class="text">Invoice</span>
										</div>
									</a> <a class="col-6 col-md-4 p-0" href="#">
										<div class="quick-actions-item">
											<div class="avatar-item bg-secondary rounded-circle">
												<i class="fas fa-credit-card"></i>
											</div>
											<span class="text">Payments</span>
										</div>
									</a>
								</div>
							</div>
						</div>
					</div></li> -->
				<!-- 빠른메뉴 -->
				<!-- 사용자메뉴 -->
				<sec:authentication property="principal" var="vo" />
				<li class="nav-item topbar-user dropdown hidden-caret"
					style="margin-right: 50px;"><a
					class="dropdown-toggle profile-pic" data-bs-toggle="dropdown"
					href="#" aria-expanded="false"><span class="profile-username">
							<span class="op-7">Hi,</span> <span class="fw-bold">${vo.empName}</span>
					</span> </a>
					<ul class="dropdown-menu dropdown-user animated fadeIn">
						<div class="dropdown-user-scroll scrollbar-outer">
							<li>
								<div class="user-box">
									<div class="avatar-lg">
										<img src="/file/employee/${vo.employeeFileVO.fileName}"
											alt="image profile" class="avatar-img rounded" />
									</div>
									<div class="u-text">
										<h4>${vo.empName}</h4>
										<a href="/employee/detail"
											class="btn btn-xs btn-secondary btn-sm">내 정보</a>
									</div>
								</div>
							</li>
							<li>
								<div class="dropdown-divider"></div><a class="dropdown-item" href="/vacation/myVacation">휴가</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" href="/employee/chpass">비밀번호 변경</a>
								<div class="dropdown-divider"></div> <a class="dropdown-item"
								href="/employee/logout">로그아웃</a>
							</li>
						</div>
					</ul></li>
			</sec:authorize>
			<!-- 사용자메뉴 -->
		</ul>
	</div>
</nav>
<!-- End Navbar -->