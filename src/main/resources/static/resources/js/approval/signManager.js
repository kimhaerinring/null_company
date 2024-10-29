const undoData = [];
const canvas = document.getElementById("signature-pad");
const signaturePad = new SignaturePad(canvas, {
	dotSize: 2,
	minWidth: 2,
	maxWidth: 4,
	penColor: "rgb(43, 43, 43)",
	backgroundColor: 'rgb(248,248,248)'
});

// 지우기, 되돌리기 이벤트 리스너
$("button[data-action]").on("click", function() {
	const action = $(this).data("action");
	if (action === "clear") {
		signaturePad.clear();
	} else if (action === "undo") {
		const data = signaturePad.toData();
		if (data && data.length > 0) {
			const removed = data.pop();
			undoData.push(removed);
			signaturePad.fromData(data);
		}
	}
});

// 서명 목록 비동기로 가져오기
function updateSignList() {
	fetch('/approval/signaturePad/list')
		.then(response => response.json())
		.then(signList => {
			const tableBody = document.querySelector('.signListTable tbody');
			tableBody.innerHTML = ''; // 기존 내용 초기화

			if (signList.length === 0) {
				tableBody.innerHTML = '<tr><td colspan="3" style="color:#666; font-size: 18px; text-align:center;">저장한 서명이 없습니다.</td></tr>';
			} else {
				signList.forEach(sign => {
					const row = document.createElement('tr');
					row.innerHTML = `
						<td style="width: 5%;" class="selectSignTd">
							${sign.signDefault === 'y'
							? `<input type="radio" name="selectSignRadioButton" data-sign-num="${sign.signNum}" class="selectSignRadio" checked>`
							: `<input type="radio" name="selectSignRadioButton" data-sign-num="${sign.signNum}" class="selectSignRadio">`}
						</td>
                        <td style="width: 30%;">
                            <div style="padding: 15px; border: 1px solid #ccc; display: inline-block;">
                                <img src="/file/signature/${sign.signImage}" class="signImage">
                            </div>
                        </td>
                        <td style="text-align: left; width: 25%;">
                            <div style="font-size: 18px; font-weight: 600;" class="signTitleValue">${sign.signTitle}</div>
                            <div>${sign.signDate}</div>
                        </td>
                        <td style="text-align: right !important; width: 40%;">
                            ${sign.signDefault === 'y'
							? `<button class="btn btn-border btn-success ms-2" style="background-color: #fff !important;" disabled>
                                    <i class="fas fa-check" style="color:#31ce36;"></i>　대표 서명
                                  </button>`
							: `<button class="btn btn-border btn-primary ms-2" id="setDefaultSign_${sign.signNum}">대표 서명 설정</button>`}
                            <button class="btn btn-danger ms-2" id="deleteSign_${sign.signNum}">서명 삭제</button>
                        </td>
					`;
					tableBody.appendChild(row);
					
				});
			}

			// 서명 추가 버튼 표시 여부 업데이트
			const addSignatureButton = document.getElementById('alert_signature_pad');
			addSignatureButton.style.display = signList.length < 3 ? 'block' : 'none';

			// 이벤트 리스너 추가
			addSignatureEventListeners();
		})
		.catch(error => console.error('서명 목록 업데이트 실패:', error));
}

// 이벤트 리스너 추가 함수
function addSignatureEventListeners() {
	
	// 대표 서명 설정
	document.querySelectorAll("[id^=setDefaultSign_]").forEach(button => {
		button.addEventListener("click", function() {
			const signNum = this.id.split('_')[1];
			fetch(`/approval/signaturePad/setDefaultSign?signNum=${signNum}`, { method: 'POST' })
				.then(response => response.json())
				.then(data => {
					console.log('성공:', data);
					updateSignList(); // 서명 목록 업데이트
				})
				.catch(error => console.error('실패:', error));
		});
	});

	// 서명 삭제
	document.querySelectorAll("[id^=deleteSign_]").forEach(button => {
		button.addEventListener("click", function() {
			const signNum = this.id.split('_')[1];
			fetch(`/approval/signaturePad/deleteSign?signNum=${signNum}`, { method: 'POST' })
			.then(response => response.json())
			.then(data => {
				console.log('성공:', data);
				updateSignList(); // 서명 목록 업데이트
			})
			.catch(error => console.error('실패:', error));
		});
	});
}

// 모달창이 닫힐 때 서명 패드 초기화
$('#signModal').on('hidden.bs.modal', function() {
	signaturePad.clear();
	$('#signTitle').val('');
});

// 기안서 작성 페이지) 서명 리스트 모달에서 서명 작성 모달을 띄울 때 서명 리스트 모달을 닫지 않게
function openSignModal() {
    // 서명 작성 모달 열기
    const signModal = new bootstrap.Modal(document.getElementById('signModal'));
    signModal.show();
}

// 서명 저장 버튼 클릭 이벤트
document.getElementById('saveSignBtn').addEventListener('click', function() {
	if (signaturePad.isEmpty()) {
		alert("서명을 입력해 주세요.");
		return;
	}

	const imgURL = signaturePad.toDataURL('image/png');
	const formData = new FormData();
	formData.append('signImage', imgURL);
	const signTitle = document.getElementById('signTitle').value;
	formData.append('signTitle', signTitle);

	fetch('/approval/signaturePad/canvas', {
		method: 'POST',
		body: formData
	})
	.then(response => response.json())
	.then(data => {
		console.log('성공:', data);
		$('#signModal').modal('hide');
		signaturePad.clear(); // 서명 패드 초기화
		updateSignList(); // 서명 목록 업데이트
	})
	.catch(error => console.error('실패:', error));
});

// 서명 선택 버튼 클릭 이벤트 추가
document.getElementById('submitSign').addEventListener('click', function() {
    // 선택된 서명을 찾기
    const selectedSign = document.querySelector('input.selectSignRadio:checked');
    
    if (selectedSign) {
        // 선택된 서명의 정보를 가져오기
		const signRow = selectedSign.closest('tr');
		const signTitle = signRow.querySelector('.signTitleValue').innerText; // 서명 제목 가져오기
		const signNum = selectedSign.getAttribute('data-sign-num'); // signNum 가져오기
		
		document.getElementById('hiddenSignNum').value = signNum;
		
        // 서명 선택 버튼의 텍스트 및 name 속성 업데이트
        const signSelectButton = document.getElementById('signListModalBtn');
		signSelectButton.innerText = signTitle; // 버튼 텍스트 변경
		
		// 모달 닫기
		const signListModal = document.getElementById('signListModal');
		const modal = bootstrap.Modal.getInstance(signListModal); // 기존 인스턴스 가져오기
		modal.hide(); // 모달 닫기
		
		// 이거 안됨
		// const signListModal = new bootstrap.Modal(document.getElementById('signListModal'));
		// signListModal.hide();
		// 이미 열려있는 기존 인스턴스를 가져와야하기 때문		
    }
	else {
		alert("서명을 선택해 주세요."); // 선택 안 된 경우 메시지 표시
	}
});
