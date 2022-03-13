# 쿠링 iOS 공동 작업 가이드라인

## 요구사항
아래 둘 중 하나라도 없을 시 [쿠링팀](https://www.instagram.com/kuring.konkuk) 또는 [재성](https://www.instagram.com/kuring_ios)에게 연락해주세요.
1. 🗝 Certificate: `development.cer`
2. 🛢 Provisioning Profile: `kuring_service_provisioning_profile.mobileprovision`

## 순서
1. Certificate 를 다운로드 받아서 Keychain에 설치합니다.
2. Provision Profile를 다운로드 받아서 안전한 곳에 잘 보관합니다.
3. Xcode 에서 앱프로젝트를 엽니다
4. Signing & Capabilities 로 이동합니다
5. Automatically manage signing 체크박스를 해제합니다
6. Sigining Certificate 를 (1) 에서 다운받은 걸로 변경합니다
7. Provisioning Profile 를 (2) 에서 다운받은 걸로 변경합니다.
8.Bundle ID 를 `com.kuring.service` 로 변경합니다.

> **💬 IMPORTANT** 문제가 발생하면 [쿠링팀](https://www.instagram.com/kuring.konkuk) 또는 [재성](https://www.instagram.com/kuring_ios) 에게 DM을 보내주세요.
