<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<c:import url="../templates/header.jsp"></c:import>

    <title>Document</title>
</head>
<body>
	<div class="wrapper">
		<div class="main-panel">
			<div class="main-header">
				<c:import url="../templates/sidebar.jsp"></c:import>
				<c:import url="../templates/topbar.jsp"></c:import>
			</div>

			<div class="container custom-list1">
				<div class="page-inner">
					<div class="card">
						<div class="card-header">
							<div class="card-title custom-list2">
								<ul>
									<li class="no_dot">공지사항</li>
								</ul>
							</div>
							<div>
								<ul class="no_dot">
									<li class="custom-post1">${noticeVO.noticeTitle}</li>
									<li class="custom-list4">${noticeVO.departmentVO.deptName}팀 ${noticeVO.employeeVO.empName}&nbsp; ${noticeVO.noticeDate}</li>
									<li class="custom-list4">조회수 ${noticeVO.noticeHit}</li>
								</ul>
								<c:forEach items="${noticeVO.list }" var="list">
									<span class="custom-write2">
										<a href="/file/notice/${list.fileName}" download>${list.oriName }</a>
									</span>
								</c:forEach>
								<br>
							</div>
						</div>
						<div class="card-body">
							<article class="custom-post2">${noticeVO.noticeContents }</article>
							<a href="/notice/list">목록으로 돌아가기</a>
							<br>
							<a href="/notice/modify?noticeNum=${noticeVO.noticeNum }">수정하기</a>
						</div>
					</div>
					<div class="card">
						<div class="card-header">
							<form method="post">
								<div class="card-title">
									<ul>
										<li class="no_dot"><i class="far fa-comment-dots"></i> 댓글</li>
									</ul>
								</div>
								<div>
									<textarea class="form-control" name="commentContents"
										id="commentContents"></textarea>
								</div>
								<br>
								<div class="container text-end">
									<button type="button" class="btn btn-black" id="commentBtn">등록</button>
								</div>
							</form>
						</div>

						<div class="card-body" id="commentDiv" data-notice-num="${noticeVO.noticeNum }">
						</div>
					</div>
					
					

				</div>
			</div>

			<c:import url="../templates/footer.jsp"></c:import>
		</div>
	</div>

	<c:import url="../templates/bootfooter.jsp"></c:import>
	<script src="/resources/js/notice/comment.js"></script>
	<script src="/resources/js/notice/reply.js"></script>
</body>
</html>