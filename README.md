# MO HAJI
2023 Winter MadCamp Third Project

## Outline
<img src="https://github.com/MO-HAJI/MO-HAJI/assets/113894257/40c0463e-b724-41eb-93cd-968b66fc70aa" width="200"></img>

<br/>

**MO HAJI**는 음식 사진 하나면 레시피, 알러지 정보, 주변 맛집까지 알려주는 애플리케이션입니다.

<br/>

## Team
**김주영** <a href="https://github.com/jooyoung9939" target="_blank"><img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white"></a>

**나지연**  <a href="https://github.com/najiyeon" target="_blank"><img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=github&logoColor=white"></a>

<br/>

## Tech Stack
**Front-end** : Flutter(Dart)

**Back-end** : Node.js, MySQL, AWS ec2, s3

**API** : google vision api, openai api, naver search api

<br/>

## About
**유저 목록**
- 회원가입되어있는 유저 목록을 확인 가능합니다.
- 유저의 프로필을 클릭해 해당 유저가 등록한 음식 사진과 정보들을 확인할 수 있습니다.
- 마음에 드는 유저를 팔로우 할 수 있습니다.

**음식 등록**
- 음식 사진을 등록, 삭제할 수 있습니다.
- 등록한 음식 사진이 어떤 음식인지 google vision api와 gpt를 활용하여 단어를 추출해냅니다.
- 해당 음식의 레시피, 알러지 정보를 gpt로 제공해줍니다.
- 사용자의 위치를 기반으로 해당 음식의 주변 맛집 정보를 naver search api를 통해 제공해줍니다.

**마이 페이지**
- 기본 정보를 확인하고, 수정할 수 있습니다.
- 팔로우, 팔로워 목록을 확인할 수 있습니다.


