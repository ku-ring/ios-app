![커버이미지](https://github.com/ku-ring/ios-app/assets/53814741/73aae511-c6eb-4160-b666-2fafc7514c8b)

[![appstore](https://img.shields.io/badge/쿠링-다운로드-000000.svg?style=for-the-badge)](https://apps.apple.com/kr/app/id1609873520)

[![Swift Version](https://img.shields.io/badge/swift-5.9-orange.svg?style=for-the-badge)](https://swift.org)
[![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue.svg?style=for-the-badge)](https://developer.apple.com/ios)

<a href="https://tuist.dev/kuring/kuringapp/previews/latest">  <img src="https://tuist.dev/kuring/kuringapp/previews/latest/badge.svg" alt="Tuist Preview">
</a>


# ios-app

쿠링 iOS 앱 v2 레포입니다. SwiftUI + TCA, Tuist

## 개요

> **💬 우리 학교에도 드디어 이런 앱이 나오다뇨 ㅠㅠ 매번 장학금 확인하려고 학교 홈페이지 드나드는데 알림으로 알려주어서 얼마나 고마운지 몰라요 개발자님들 복 🧧 받으세요 🙇‍♀️🙇‍♂️🙇**
> 
> 앱스토어 리뷰

쿠링은 건국대학교 공지사항을 푸시알림으로 제공하는 서비스입니다. 지속적으로 서비스가 제공하는 캠퍼스에 대한 정보의 범위를 확장해 나아가고 있습니다.

[![appstore](https://img.shields.io/badge/쿠링-다운로드-000000.svg?style=for-the-badge)](https://apps.apple.com/kr/app/id1609873520)

## 요구 사항

- Xcode 26.0+ (Swift 5.9+)
- iOS 17+
- Tuist 4.109.1 (mise)
 
## 의존성

| name | URL | branch | description |
| ---- | ---- | ------ | ----- |
| The Satellite | https://github.com/ku-ring/the-satellite | main | iOS API 통신모듈  |
| Swift Collections | https://github.com/apple/swift-collections | 1.1.0 | OrderedSet |  
| Composable Architecture | https://github.com/pointfreeco/swift-composable-architecture | 1.12.1 | TCA 구조를 위한 스위프트 패키지 |
| Tuist | https://github.com/tuist/tuist | 4.109.1 | iOS 프로젝트 관리 도구  |
| swift-dependencies | https://github.com/pointfreeco/swift-dependencies | 1.9.3 | 디펜던시 관리 라이브러리 |
| Lottie | https://github.com/airbnb/lottie-spm | 4.44.1 | 코드 스타일 관리 |
| ios-maps | https://github.com/ku-ring/ios-maps | main | 쿠링 지도 |

## 기여

오픈소스 프로젝트이기 때문에 누구나 참여할 수 있습니다. 기여 방법은 [Discussions](https://github.com/ku-ring/app-ios-v2/discussions/2) 의 Contribution 가이드를 참고해주세요.

# 시작 가이드

## Tuist 설정

mise가 설치 되어있지 않다면 mise를 먼저 설치해주세요([mise](https://github.com/jdx/mise)). 
```sh
$ curl https://mise.run | sh
$ ~/.local/bin/mise --version
2025.11.9 macos-arm64 (a1b2d3e 2025-11-27)
```

mise로 Tuist를 설치 해주세요([설치 가이드](https://docs.tuist.dev/en/guides/quick-start/install-tuist)).

```sh
mise install tuist            # Install the current version specified in .tool-versions/.mise.toml
mise install tuist@x.y.z      # Install a specific version number
mise install tuist@3          # Install a fuzzy version number
```

쿠링은 4.109.1 버전을 사용합니다.
```sh
# 특정 버전 사용
mise use tuist@4.109.1
# 현재 활성화된 Tuist 버전 확인
tuist --version
```


### 커밋 방지 처리

> **Important**: 매우 중요한 단계입니다. 꼭 실행하십시오.

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
2. App -> Configurations 폴더 안에 다운로드 받은 plist 를 드래그앤드랍 합니다.

### Tuist 모듈화

프로젝트 루트 디렉토리에서 아래 명령어를 입력하면 프로젝트가 생성 됩니다.
```sh
make generate
```

의존성이 추가되었거나 프로젝트 상태가 꼬이는 등 프로젝트 재생성이 필요한 경우 아래 명령어를 사용 해주세요.
```sh
## 둘다 똑같음
make clean; make generate
make reset 
```

새로운 모듈을 생성하고 싶을때는 tuist scaffolding을 활용 해주세요. 모듈은 Feature/UI/Shared로 구분 됩니다.
```sh
tuist scaffold Feature --name Foo
## example 플래그가 true면 실행 가능한 example앱을 생성 해줍니다. 기본값은 false입니다.
tuist scaffold UI --name Bar --example true
tuist scaffold Shared --name Baz
```
이후 원하는 타겟에 디펜던시 추가, 그 다음 `tuist generate`를 해주시면 됩니다.


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
| <img src="https://github.com/hwan-cs.png" alt="img" width="60"/> | [hwan-cs](https://github.com/hwan-cs) | 컴퓨터공학부 |

## Contributors
쿠링에 기여 해주신 개발자분들께 큰 감사를 보냅니다

| 프로필 | 깃헙 네임 | 학과 |
| --- | --- | --- |
| <img src="https://github.com/x-0o0.png" alt="img" width="60"/> | [x-0o0](https://github.com/x-0o0) | 전기전자공학부 |
| <img src="https://github.com/lgvv.png" alt="img" width="60"/> | [lgvv](https://github.com/lgvv) | 스마트ICT융합공학과 |
| <img src="https://github.com/sunshiningsoo.png" alt="img" width="60"/> | [sunshiningsoo](https://github.com/sunshiningsoo) | 컴퓨터공학부 |
| <img src="https://github.com/wonniiii.png" alt="img" width="60"/> | [wonniiii](https://github.com/wonniiii) | 컴퓨터공학부 |

## 문의

[![인스타그램](https://img.shields.io/badge/@kuring.konkuk-e4405f?style=for-the-badge&logo=instagram&logoColor=white)](https://bit.ly/3JyMWMi)
[![이메일](https://img.shields.io/badge/kuring.korea@gmail.com-168de2?style=for-the-badge&logo=gmail&logoColor=white)](mailto:kuring.korea@gmail.com)
