# Tour_App_Project
<ul><li>스마트폰 게임 프로그래밍 2017년 1학기 텀 프로젝트</li></ul>

# First Commit - 2017.05.18
<ul><li>한개의 네비게이션버튼을 통한 세 가지화면으로의 전환과 CheckBox 구현 완료</li></ul>

# Second Commit - 2017.05.18
<ul><li>README.md 파일 추가</li></ul>

# Third Commit - 2017.05.19
<p><ul><li>Thema Default Data 입력 완료</li>
<li>TourSearch Storyboard Thema CheckBox 구현 완료</p></li>
<li><p>하위분류 PickerView에서 Data 선택 후 상위분류 PickerView에서 다른 데이터를 선택해도 하위분류에 있는 PickerView의 내부 row값은 변경되지 않고 그대로인 것을 확인함.</li><li>상위분류를 바꾸면 하위분류 PickerView들을 초기화되게 만들어서 overflow는 안나지만 사용자의 입장에서 하위분류를 다시 클릭했을 때 눈에 보이는 row값이 0이 아니라 전의 row값이라  헷갈릴 여지가 있고 가끔씩 데이터 혼란이 일어나므로 수정 필요.</li></ul></p>
<p>방법 1. 대분류,중분류,소분류마다 PickerView들을 각각 다르게 만들어 준다.
결과 1. 대분류,중분류,소분류마다 PickerView가 달라도 대분류끼리, 중분류끼리, 소분류끼리는 같으므로 실패</p>
<p>방법 2. 대분류를 바꿀때마다 하위분류들의 PickerView들을 삭제하고 새로만든다.<br>
결과 2. 상위분류의 Data들을 교체할때마다 하위분류들의 row값이 0으로 모조리 초기화됨 성공적. 메모리, cpu 사용 이슈는 경과를 두고봐야 할 것 같음</p>

# Forth Commit - 2017.05.19
<p><ul><li>README.md 양식 수정</li></ul></p>

# Fiveth Commit - 2017.05.22
<p><ul><li>서비스 코드 입력완료.</li>
<li>서비스 코드 맵핑완료</li></ul></p>

# Sixth Commit - 2017.05.24
<p><ul><li>Data Parsing 후 Table Cell에 입력 완료</li>
<li>Search Option 추가</li></ul></p>

# Seventh Commit - 2017.05.29
<p><ul><li>UI 수정 완료</li>
<li>more button add</li>
<li>thumnail image add</li>
<li>thumnail image가 없는 data는 no image로 추가</li>
<li>화면 클릭하면 keybord 내려가게 수정</li>
<li>검색 두번 하면 데이터가 새로 올라오지 않고 이전 데이터에 이어서 출력되던 현상 수정</li></ul></p>

# Eight Commit - 2017.05.29
<p><ul><li>즐겨찾기 추가 완료</li>
<li>storyboard에선 cell을 swipe하면 delete기능밖에 못쓰므로 Custom Cell Conroller를 만듬</li>
<li>swipe하면 별표시가 나타나고 클릭하면 노란색으로 바뀌면서 즐겨찾기 탭에 item 추가 됨</li>
<li>즐겨찾기란에 추가하거나 삭제할 때 data가 갱신 안되던 문제를 생명주기와 barbtn을 사용해 해결</li>
<li>picker view의 문제 발견. picker view의 회전이 멈추기전에 다음페이지로 이동을 누르면 row값 적용이 안됨</li>
<li>약간의 로딩을 줄 예정</li>

