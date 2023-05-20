# app-ios-v2
쿠링 iOS 앱 v2 레포입니다. SwiftUI + TCA

## 요구사항

- Xcode 14.1 (Swift 5.7.1+)
- iOS 16+

## 구조

### TCA

> **🔗 링크** [swift-composable-architecture | pointfreeco](https://github.com/pointfreeco/swift-composable-architecture)

> **📄 개발 문서** [Documentation | ComposableArchitecture](https://pointfreeco.github.io/swift-composable-architecture/main/documentation/composablearchitecture/)

## 환경세팅

> **중요** 쿠링의 Private Swift Package 인 Enigma 에 대한 의존성 추가를 필요로 합니다.
> 관련 내용은 [Enigma | ku-ring](https://github.com/ku-ring/Enigma) 를 참고해주세요.

> **정보** Satellite를 통한 API 통신 및 응답 파싱에 대한 로직은 KuringLink 라는 이름의 모듈로 추후 이동될 예정입니다.

### Swift Package
| name | URL | branch | description |
| ---- | ---- | ------ | ----- |
| Enigma | https://github.com/ku-ring/Enigma | main | 쿠링 내부 리소스 |
| The Satellite | https://github.com/ku-ring/the-satellite | main | API 통신모듈  |
| KuringLink | https://github.com/ku-ring/KuringLink | 추후 업데이트 | 쿠링 API 파싱 및 스토리지 관리 모듈 |
| Cache | https://github.com/cozzin/Cache | main | 캐싱 모듈 |
| Swift Collections | https://github.com/apple/swift-collections | main | OrderedSet |  
| The Composable Architecture | https://github.com/pointfreeco/swift-composable-architecture | main | TCA 구조를 위한 스위프트 패키지 |
