# kuring-ios-app
This is a private repository for 쿠링 application service

## 요구사항

- iOS 15.0 +
- Swift 5

## 시작하기

### 프레임워크 설치

1. 터미널에서 프로젝트 경로로 이동한 뒤 아래와 같이 코코아팟 설치 명령어를 실행합니다.
```bash
$ pod install
```
2. Swift package 도 잘 설치되는지 확인합니다. (Firebase)

### 쿠링SDK와 워크스페이스 생성

반드시 [KuringSDK](https://github.com/KU-Stacks/kuring-sdk-ios) 도 같이 다운로드 후 아래의 구성으로 workspace를 생성하여 작업해주세요
- Kuring.proj
- Kuring의 Pod.proj
- KuringSDK.proj

> **중요!**
> testflight로 올리는 경우 및 prod 테스트가 필요한 경우를 제외하고 반드시 scheme은 debug로 설정해주세요.
> entitlement도 scheme에 따라 development | production 수정해주세요.

### 프로비저닝 프로파일 (Provisioning Profile) 요청

재성에게 필요하신 프로파일을 요청하시면 됩니다.

