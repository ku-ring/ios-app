![커버이미지](https://github.com/ku-ring/ios-app/assets/53814741/73aae511-c6eb-4160-b666-2fafc7514c8b)

[![appstore](https://img.shields.io/badge/쿠링-다운로드-000000.svg?style=for-the-badge)](https://apps.apple.com/kr/app/id1609873520)

![test](https://github.com/ku-ring/ios-app/actions/workflows/BUILD_PACKAGE.yml/badge.svg)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https://github.com/ku-ring/ios-app&count_bg=%23000000&title_bg=%23555555&icon=swift.svg&icon_color=%23FFFFFF&title=%EC%A1%B0%ED%9A%8C%EC%88%98&edge_flat=true)](https://hits.seeyoufarm.com)

# ios-app

쿠링 iOS 앱 v2 레포입니다. SwiftUI + TCA

## 개요

> **💬 우리 학교에도 드디어 이런 앱이 나오다뇨 ㅠㅠ 매번 장학금 확인하려고 학교 홈페이지 드나드는데 알림으로 알려주어서 얼마나 고마운지 몰라요 개발자님들 복 🧧 받으세요 🙇‍♀️🙇‍♂️🙇**
> 
> 앱스토어 리뷰

쿠링은 건국대학교 공지사항을 푸시알림으로 제공하는 서비스입니다. 지속적으로 서비스가 제공하는 캠퍼스에 대한 정보의 범위를 확장해 나아가고 있습니다.

[![appstore](https://img.shields.io/badge/쿠링-다운로드-000000.svg?style=for-the-badge)](https://apps.apple.com/kr/app/id1609873520)

## 요구 사항

- Xcode 15.0+ (Swift 5.9+)
- iOS 17+

## 사용하는 스위프트 패키지

| name | URL | branch | description |
| ---- | ---- | ------ | ----- |
| The Satellite | https://github.com/ku-ring/the-satellite | main | iOS API 통신모듈  |
| Swift Collections | https://github.com/apple/swift-collections | main | OrderedSet |  
| Composable Architecture | https://github.com/pointfreeco/swift-composable-architecture | main | TCA 구조를 위한 스위프트 패키지 |
| SwiftFormat | https://github.com/nicklockwood/SwiftFormat | 0.50.4 | 코드 스타일 관리 |

## 기여

오픈소스 프로젝트이기 때문에 누구나 참여할 수 있습니다. 기여 방법은 [Discussions](https://github.com/ku-ring/app-ios-v2/discussions/2) 의 Contribution 가이드를 참고해주세요.

## 시작 가이드

### 커밋 방지 처리

> **Important**: 매우 중요한 단계입니다. 클론 후 즉시 실행하십시오.

루트 폴더 경로에서 `FIRST_ACTION.sh` 스크립트를 실행합니다.
```bash
./FIRST_ACTION.sh
```
만약 권한 에러가 발생할 경우 아래 명령어를 실행하고 다시 스크립트를 실행합니다.
```bash
chmod +x FIRST_ACTION.sh
```

### FCM 을 위한 GoogleService-Info.plist 추가하기

> **Note**: 푸시 알림 테스트를 위해서 필요합니다.

1. [GoogleService-Info.plist 다운로드하기](https://github.com/ku-ring/ios-certificates/blob/main/GoogleService-Info.plist)
2. KuringApp.xcproj 를 엽니다
3. KuringApp 폴더 하위에 Info.plist 와 같은 경로에 다운로드 받은 plist 를 드래그앤드랍 합니다.

### 패키지 기반 모듈화 (Package Based Modularization)

`KuringApp.xcodeproj` 열기

빌드 타겟: `KuringApp` 으로 설정

### TCA

> **🔗 링크** [swift-composable-architecture | pointfreeco](https://github.com/pointfreeco/swift-composable-architecture)

> **📄 개발 문서** [Documentation | ComposableArchitecture](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/)

**Xcode 코드 스니펫**

다음 경로에 자동으로 `Reducer` 와 `View`, `Preview` 까지 생성하는 코드 스니펫 파일이 있습니다.
> /XcodeSnippets/FeatureSnippet.codesnippet

터미널을 열고 다음 명령어를 실행하여 Xcode에 코드 스니펫 관리 폴더를 엽니다.
> $ open Library/Developer/Xcode/UserData/CodeSnippets/

폴더에 코드 스니펫 파일을 복사 붙여넣기 합니다.

이제 Xcode 로 돌아가 `.swift` 파일에서 `feature` 를 입력하면 자동완성 목록에 뜨는 걸 확인할 수 있습니다.

### 디자인

> **정보** 아래 링크는 쿠링 멤버만 볼 수 있는 노션 링크 입니다.

https://www.notion.so/kuring/v2-55977b79a8014c2883ad4c89085e1464?pvs=4

## 깃헙 액션 (GitHub Actions)

> **정보** 자세한 내용은 [Discussion](https://github.com/ku-ring/ios-app/discussions/56) 을 참고하세요.

반드시 `/쿠링` 으로 시작할 것.

### 빌드
- `ios17 앱 빌드`
- `패키지 빌드`

### 테스트
- `패키지 테스트`

### PR 머지
- `머지`

### 더 나아가기
```
/쿠링 ios17 앱 빌드하고 패키지 빌드하고 머지해줘
```

## 코드 관리자

| 프로필 | 깃헙 네임 | 학과 |
| --- | --- | --- |
| <img src="https://github.com/lgvv.png" alt="img" width="60"/> | [lgvv](https://github.com/lgvv) | 스마트ICT융합공학과 |
| <img src="https://github.com/sunshiningsoo.png" alt="img" width="60"/> | [sunshiningsoo](https://github.com/sunshiningsoo) | 컴퓨터공학부 |
| <img src="https://github.com/wonniiii.png" alt="img" width="60"/> | [wonniiii](https://github.com/wonniiii) | 컴퓨터공학부 |

## 문의

[![인스타그램](https://img.shields.io/badge/@kuring.konkuk-e4405f?style=for-the-badge&logo=instagram&logoColor=white)](https://bit.ly/3JyMWMi)
[![이메일](https://img.shields.io/badge/kuring.korea@gmail.com-168de2?style=for-the-badge&logo=gmail&logoColor=white)](mailto:kuring.korea@gmail.com)
