<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html lang="UTF-8">
<head>
	<meta charset="UTF-8">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	
	<c:import url="../templates/header.jsp"></c:import>
	<script src="../../resources/js/core/jquery-3.7.1.min.js"></script>

	<title>기안함</title>
</head>
<body>
	<div class="wrapper">
		<div class="main-panel">
			<div class="main-header">
				<c:import url="../templates/sidebar.jsp"></c:import>
				<c:import url="../templates/topbar.jsp"></c:import>
			</div>

			<div class="container">
				<div class="page-inner">

					<div class="page-header">
						<h3 class="fw-bold mb-3">휴가</h3>
						<ul class="breadcrumbs mb-3">
							<li class="nav-home">
								<a href="#">
									<i class="icon-home"></i>
								</a>
							</li>
							<li class="separator">
								<i class="icon-arrow-right"></i>
							</li>
							<li class="nav-item">
								<a href="#">휴가</a>
							</li>							
							<li class="separator">
								<i class="icon-arrow-right"></i>
							</li>
							<li class="nav-item">
								<a href="#">휴가 신청 내역</a>
							</li>
							<li class="separator">
								<i class="icon-arrow-right"></i>
							</li>
							
						</ul>
					</div>



					<div class="row">


						<div class="col-md-12">
							<div class="card">
										<div class="card-header">
											<div class="card-title">예정 휴가</div>
										</div>
										<div class="card-body">
											<table class="table table-hover">
												<thead>
													<tr>
														<th scope="col">휴가종류</th>
														<th scope="col">휴가 시작일</th>
														<th scope="col">휴가 마감일</th>
														<th scope="col">상태</th>
													</tr>
												</thead>
												<tbody>
													<tr>
														<td>반차</td>
														<td>2024.02.13</td>
														<td>2024.02.16</td>
														<td>승인</td>
													</tr>

												</tbody>
											</table>
										</div>
									</div>
						</div>
					</div>
					
			
				</div> <!-- page-inner -->
			</div> <!-- container -->
			

			<c:import url="../templates/footer.jsp"></c:import>
		</div>
	</div>

	<c:import url="../templates/bootfooter.jsp"></c:import>
	
	
    <script>
      $(document).ready(function () {

        // Add Row
        $("#appr-doc-table").DataTable({
          pageLength: 10,
        });

        var action =
          '<td> <div class="form-button-action"> <button type="button" data-bs-toggle="tooltip" title="" class="btn btn-link btn-primary btn-lg" data-original-title="Edit Task"> <i class="fa fa-edit"></i> </button> <button type="button" data-bs-toggle="tooltip" title="" class="btn btn-link btn-danger" data-original-title="Remove"> <i class="fa fa-times"></i> </button> </div> </td>';

      });
    </script>
</body>
</html>