//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import ComposableArchitecture

extension KuringLink: DependencyKey {
    public static let liveValue = KuringLink(
        fetchNotices: { count, type, department, page in
            let response: Response<[Notice]> = try await satellite
                .response(
                    for: Path.getNotices.path,
                    httpMethod: .get,
                    queryItems: [
                        .init(name: "type", value: type),
                        .init(name: "department", value: department),
                        .init(name: "page", value: String(page)),
                        .init(name: "size", value: String(count)),
                    ]
                )
            return response.data
        },
        sendFeedback: { text in
            let response: EmptyResponse = try await satellite
                .response(
                    for: Path.sendFeedback.path,
                    httpMethod: .post,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken,
                        "User-Agent": "Kuring/\(appVersion) iOS/\(iosVersion)",
                    ],
                    httpBody: Feedback(content: text)
                )
            let isSucceed = (200 ..< 300) ~= response.code
            return isSucceed
        },
        searchNotices: { keyword in
            // TODO: 서버 수정되면 제거하기
            struct SearchedNoticeList: Decodable {
                let noticeList: [SearchedNotice]
            }
            let response: Response<SearchedNoticeList> = try await satellite
                .response(
                    for: Path.searchNotices.path,
                    httpMethod: .get,
                    queryItems: [
                        .init(name: "content", value: keyword),
                    ]
                )
            return response.data.noticeList.compactMap { $0.asNotice }
        },
        searchStaffs: { keyword in
            // TODO: 서버 수정되면 제거하기
            struct StaffList: Decodable {
                let staffList: [Staff]
            }
            let response: Response<StaffList> = try await satellite
                .response(
                    for: Path.searchStaffs.path,
                    httpMethod: .get,
                    queryItems: [
                        .init(name: "content", value: keyword),
                    ]
                )
            return response.data.staffList
        },
        subscribeUnivNotices: { typeNames in
            let response: EmptyResponse = try await satellite
                .response(
                    for: Path.subscribeUnivNotices.path,
                    httpMethod: .post,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken,
                    ],
                    httpBody: UnivNoticeSubscription(categories: typeNames)
                )
            let isSucceed = (200 ..< 300) ~= response.code
            return isSucceed
        },
        subscribeDepartments: { hostPrefixes in
            let response: EmptyResponse = try await satellite
                .response(
                    for: Path.subscribeDepartments.path,
                    httpMethod: .post,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken,
                    ],
                    httpBody: DepartmentSubscription(departments: hostPrefixes)
                )
            let isSucceed = (200 ..< 300) ~= response.code
            return isSucceed
        }
    )
}

extension DependencyValues {
    public var kuringLink: KuringLink {
        get { self[KuringLink.self] }
        set { self[KuringLink.self] = newValue }
    }
}

extension KuringLink {
    public static let testValue: KuringLink = .init(
        fetchNotices: { _, _, _, _ in
            [Notice.random]
        },
        sendFeedback: { _ in
            true
        },
        searchNotices: { _ in
            [Notice.random]
        },
        searchStaffs: { _ in
            [Staff.random()]
        },
        subscribeUnivNotices: { _ in
            true
        },
        subscribeDepartments: { _ in
            true
        }
    )
}
