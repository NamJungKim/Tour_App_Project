# Tour_App_Project
스마트폰 게임 프로그래밍 2017년 1학기 텀 프로젝트

# First Commit - 2017.05.18
한개의 네비게이션버튼을 통한 세 가지화면으로의 전환과 CheckBox 구현 완료

# Second Commit - 2017.05.18
README.md 파일 추가

# Third Commit - 2017.05.19
<p>Thema Default Data 입력 완료<br>
TourSearch Storyboard Thema CheckBox 구현 완료</p>
<p>하위분류 PickerView에서 Data 선택 후 상위분류 PickerView에서 다른 데이터를 선택해도 하위분류에 있는 PickerView의 내부 row값은 변경되지 않고 그대로인 것을 확인함.<br>상위분류를 바꾸면 하위분류 PickerView들을 초기화되게 만들어서 overflow는 안나지만 사용자의 입장에서 하위분류를 다시 클릭했을 때 눈에 보이는 row값이 0이 아니라 전의 row값이라  헷갈릴 여지가 있고 가끔씩 데이터 혼란이 일어나므로 수정 필요.</p>
<p>방법 1. 대분류,중분류,소분류마다 PickerView들을 각각 다르게 만들어 준다.<br>
결과 1. 대분류,중분류,소분류마다 PickerView가 달라도 대분류끼리, 중분류끼리, 소분류끼리는 같으므로 실패</p>
<p>방법 2. 대분류를 바꿀때마다 하위분류들의 PickerView들을 삭제하고 새로만든다.<br>
결과 2. 상위분류의 Data들을 교체할때마다 하위분류들의 row값이 0으로 모조리 초기화됨 성공적. 메모리, cpu 사용 이슈는 경과를 두고봐야 할 것 같음</p>
