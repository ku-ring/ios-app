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
                        .init(name: "size", value: String(count))
                    ]
                )
            return response.data
        },
        sendFeedback: { text, fcmToken in
            let response: EmptyResponse = try await satellite
                .response(
                    for: Path.sendFeedback.path,
                    httpMethod: .post,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken,
                        "User-Agent": "Kuring/\(appVersion) iOS/\(iosVersion)"
                    ],
                    httpBody: Feedback(content: text)
                )
            let isSucceed = (200..<300) ~= response.code
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
                        .init(name: "content", value: keyword)
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
                        .init(name: "content", value: keyword)
                    ]
                )
            return response.data.staffList
        },
        subscribeUnivNotices: { typeNames, fcmToken in
            let response: EmptyResponse = try await satellite
                .response(
                    for: Path.subscribeUnivNotices.path,
                    httpMethod: .post,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken
                    ],
                    httpBody: UnivNoticeSubscription(categories: typeNames)
                )
            let isSucceed = (200..<300) ~= response.code
            return isSucceed
        },
        subscribeDepartments: { hostPrefixes, fcmToken in
            let response: EmptyResponse = try await satellite
                .response(
                    for: Path.subscribeDepartments.path,
                    httpMethod: .post,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken
                    ],
                    httpBody: DepartmentSubscription(departments: hostPrefixes)
                )
            let isSucceed = (200..<300) ~= response.code
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
    public static let testValue: KuringLink = KuringLink(
        fetchNotices: { count, type, department, page in
            return [Notice.random]
        },
        sendFeedback: { text, fcmToken in
            return true
        },
        searchNotices: { keyword in
            return [Notice.random]
        },
        searchStaffs: { keyword in
            return [Staff.random()]
        },
        subscribeUnivNotices: { typeNames, fcmToken in
            return true
        },
        subscribeDepartments: { hostPrefixes, fcmToken in
            return true
        }
    )
}
