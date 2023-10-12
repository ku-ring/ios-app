# app-ios

쿠링 iOS 앱 v2 레포입니다. SwiftUI + TCA

## 개요

> **💬 우리 학교에도 드디어 이런 앱이 나오다뇨 ㅠㅠ 매번 장학금 확인하려고 학교 홈페이지 드나드는데 알림으로 알려주어서 얼마나 고마운지 몰라요 개발자님들 복 🧧 받으세요 🙇‍♀️🙇‍♂️🙇**
> 
> 앱스토어 리뷰

쿠링은 건국대학교 공지사항을 푸시알림으로 제공하는 서비스입니다. 지속적으로 서비스가 제공하는 캠퍼스에 대한 정보의 범위를 확장해 나아가고 있습니다.

[쿠링 |  앱스토어](https://apps.apple.com/kr/app/id1609873520)

## 요구 사항

- Xcode 15.0 (Swift 5.9+)
- iOS 16+

## 사용하는 스위프트 패키지

| name | URL | branch | description |
| ---- | ---- | ------ | ----- |
| Cache | https://github.com/cozzin/Cache | main | 캐싱 모듈 |
| The Satellite | https://github.com/ku-ring/the-satellite | main | iOS API 통신모듈  |
| Swift Collections | https://github.com/apple/swift-collections | main | OrderedSet |  
| The Composable Architecture | https://github.com/pointfreeco/swift-composable-architecture | main | TCA 구조를 위한 스위프트 패키지 |

## 기여

오픈소스 프로젝트이기 때문에 누구나 참여할 수 있습니다. 기여 방법은 [Discussions](https://github.com/ku-ring/app-ios-v2/discussions/2) 의 Contribution 가이드를 참고해주세요.

## 시작 가이드

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

반드시 `/쿠링` 으로 시작할 것.

### 빌드
- `ios17 앱 빌드`
- `패키지 빌드`

### PR 머지
- `머지`

### 더 나아가기
```
/쿠링 ios17 앱 빌드하고 패키지 빌드하고 머지해줘
```

## 코드 관리자

| 건우 | 성수 | 재성 |
| --- | --- | --- |
| [lgvv](https://github.com/lgvv) (스마트ICT융합공학과) | [sunshiningsoo](https://github.com/sunshiningsoo) (컴퓨터공학부) | [jaesung-0o0](https://github.com/jaesung-0o0) (전기전자공학부) |
| ![img](https://github.com/lgvv.png) | ![img](https://github.com/sunshiningsoo.png) | ![img](https://github.com/jaesung-0o0.png) |

## 문의

[![인스타그램](https://img.shields.io/badge/@kuring.konkuk-e4405f?style=for-the-badge&logo=instagram&logoColor=white)](https://bit.ly/3JyMWMi)
[![이메일](https://img.shields.io/badge/kuring.korea@gmail.com-168de2?style=for-the-badge&logo=gmail&logoColor=white)](mailto:kuring.korea@gmail.com)
