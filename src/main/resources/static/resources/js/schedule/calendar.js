
document.addEventListener('DOMContentLoaded', function() {

    var calendarEl = document.getElementById('calendar');
    var calendar = new FullCalendar.Calendar(calendarEl, {

        
    headerToolbar: {
        left: 'today,addButton',
        center: 'prev title next',
        right: 'dayGridMonth,timeGridWeek,timeGridDay',
    },

    // 일정 등록을 위한 커스텀 버튼 설정과 클릭시 발생하는 이벤트 설정
    customButtons:{
        addButton:{
            text: "일정 추가",
            click: function(){
                // 모달 표시
                const modal = document.getElementById('addEventModal');
                modal.style.display = 'block'; // 모달 열기
    
                // 모달 닫기 로직 (예: 모달 배경 클릭 시 닫기)
                window.onclick = function(event) {
                    if (event.target === modal) {
                        modal.style.display = 'none'; // 모달 닫기
                    }
                }
            }
        }
    },

    titleFormat: function (date) {
        // 컨트롤러에서 데이터를 보내주지도 않았는데 date 변수가 어디서 튀어나오나 했더니,
        // Fullcalendar에서 자동적으로 제공하는 변수라고 한다.
        // date.date는 날짜 정보를 담고있는 객체이다
        return `${date.date.year}년 ${date.date.month + 1}월`;
    },
    initialView: 'dayGridMonth',
    selectable: true,   // true : 날짜를 클릭할 수 있다
    dayMaxEvents: true,  // true : 이벤트가 많아지면 + 로 이벤트를 표시
    locale: 'Ko',   // 달력에서 한글 출력
    editable: true, // 일정 드래그 및 리사이즈 가능 설정
    

    // 캘린더 이벤트 클릭시 해당 일정의 상세 내용을 modal로 표시
    // 데이터를 백엔드에서 받아오는게 아니라, JS 함수로 받아와서 프론트 단으로 넣어주는 구조
    eventClick: function(info) { // 클릭된 이벤트의 정보를 모달에 표시
                
        // 각 필드에 이벤트 정보 설정
        document.getElementById('scheduleNum').value = info.event.id;
        document.getElementById('scheduleTitle').value = info.event.title;
        // contents처럼 임의로 만든 변수명을 사용하기 위해서는 앞에 extendedProps를 붙여줘야 한다
        document.getElementById('scheduleContents').value = info.event.extendedProps.contents,
        document.getElementById('scheduleCategory').value = info.event.extendedProps.category,
        document.getElementById('scheduleStart').value = info.event.startStr.substring(0, 10);
        document.getElementById('scheduleEnd').value = info.event.endStr.substring(0, 10);

        // calendar.jsp의 '삭제' 버튼의 href에다가 주소와 파라미터를 넣어줌
        document.getElementById('deleteBtn').href = "/schedule/delete?scheduleNum=" + info.event.id;
    
        // 모달 표시
        const modal = document.getElementById('detailEventModal');
        modal.style.display = 'block'; // 모달 열기
    
        // 모달 닫기 로직 (예: 모달 배경 클릭 시 닫기)
        window.onclick = function(event) {
            if (event.target === modal) {
                modal.style.display = 'none'; // 모달 닫기
            }
        }
    },


    // *** 캘린더에 list를 보여주는 함수 ***
    /* successCallback은 서버에서 받은 데이터를 가공한 후 여기로 전달하면
       FullCalendar가 이 데이터를 캘린더 화면에 랜더링한다. */
    /* fetchInfo는 FullCalendar가 자동으로 제공하는 인자값으로,
        없으면 작동되지 않을 뿐더러 반드시 첫 번째 인자로 받아야 한다 */
    events: function(fetchInfo, successCallback){

        fetch("/schedule/calendarList")
        .then((response)=>{return response.json()})
        .then(data=>{
            let events = data.map(eventData => {
                let eventColor;
                
                // 조건에 따라 색상 설정
                if (eventData.scheduleCategory.includes("연차")) {
                    eventColor = "rgb(229 85 99)"; // '연차'는 빨간색
                } else if (eventData.scheduleCategory.includes("마감")) {
                    eventColor = "black"; // '마감'은 검정색
                } else if (eventData.scheduleCategory.includes("회의")) {
                    eventColor = "#3788d8e"; // '회의'은 검정색
                }  else {
                    eventColor = "green"; // 기본값은 초록색
                }
    
                return {
                    id: eventData.scheduleNum,
                    title: eventData.scheduleTitle,
                    start: eventData.scheduleStart,
                    end: eventData.scheduleEnd,
                    extendedProps: {
                        contents: eventData.scheduleContents,
                        category: eventData.scheduleCategory,
                        authorName: eventData.employeeVO.empName // 작성자 이름 추가
                    },
                    backgroundColor: eventColor, // 조건에 따라 색상 지정
                    classNames: ['custom-event'], // 이벤트에 css를 적용하기 위해 class를 부여
                    display: "block"
                };
            });
            successCallback(events);  // FullCalendar에 이벤트 전달
        })
    },

    // fullcalendar는 기본적으로 일정에 start,end,title만 보여줌
    // 이름을 보여주기 위해 렌더링 되는 내용을 커스터마이즈하는 코드
    eventContent: function(arg) {
        let { event } = arg;
        let authorName = event.extendedProps.authorName;
    
        // 커스터마이즈된 HTML 반환
        return {
            html: `
                <div>
                    <strong>${authorName}</strong><br>
                    <span>${event.title}</span><br>
                </div>
            `
        };
    },

    // 이벤트가 드래그로 이동되었을 때 호출
    eventDrop: function(info) {
        let event = {
            id: info.event.id,
            start: info.event.startStr,
            end: info.event.endStr
        };
    
        // 서버에 업데이트 요청
        fetch("/schedule/dragUpdate", {
            method: "PUT",
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(event)
        }).then(response => response.text())
          .then(data => {
              if (data === 'success') {
              } else {
                  alert("업데이트 중 오류가 발생했습니다.");
                  info.revert(); // 오류 발생 시 원래 위치로 되돌리기
              }
          });
    },
    });
    calendar.render();
});