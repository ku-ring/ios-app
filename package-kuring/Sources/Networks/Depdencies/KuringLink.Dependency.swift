//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import Foundation
import OrderedCollections
import ComposableArchitecture

extension DependencyValues {
    public var kuringLink: KuringLink {
        get { self[KuringLink.self] }
        set { self[KuringLink.self] = newValue }
    }
}

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
        },
        getSubscribedUnivNotices: {
            let response: Response<[NoticeProvider]> = try await satellite
                .response(
                    for: Path.getSubscribedUnivNotices.path,
                    httpMethod: .get,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken
                    ]
                )
            // 로컬 값 갱신
            NoticeProvider.subscribedUnivNoticeTypes = response.data
                .compactMap {
                    NoticeProvider(
                        name: $0.name,
                        hostPrefix: $0.hostPrefix,
                        korName: $0.korName,
                        category: .대학
                    )
                }
            return NoticeProvider.subscribedUnivNoticeTypes
        },
        getSubscribedDepartments: {
            let response: Response<[NoticeProvider]> = try await satellite
                .response(
                    for: Path.getSubscribedDepartments.path,
                    httpMethod: .get,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken
                    ]
                )
            
            // 로컬 값 갱신
            NoticeProvider.subscribedDepartments = response.data
                .compactMap {
                    NoticeProvider(
                        name: $0.name, 
                        hostPrefix: $0.hostPrefix,
                        korName: $0.korName,
                        category: .학과
                    )
                }
            return NoticeProvider.subscribedDepartments
        },
        getAllUnivNoticeType: {
            let response: Response<[NoticeProvider]> = try await satellite
                .response(
                    for: Path.getAllUnivNoticeType.path,
                    httpMethod: .get,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken
                    ]
                )
            
            // 로컬 값 갱신
            NoticeProvider.univNoticeTypes = response.data
                .compactMap {
                    NoticeProvider(
                        name: $0.name,
                        hostPrefix: $0.hostPrefix,
                        korName: $0.korName,
                        category: .대학
                    )
                }
            var namesForPicker: OrderedDictionary<String, NoticeProvider> = [:]
            namesForPicker.updateValue(
                NoticeProvider.addedDepartments.first ?? .emptyDepartment,
                forKey: "학과"
            )
            NoticeProvider.univNoticeTypes.forEach {
                namesForPicker.updateValue($0, forKey: $0.korName)
            }
            NoticeProvider.allNamesForPicker = namesForPicker
            return NoticeProvider.univNoticeTypes
        },
        getAllDepartments: {
            let response: Response<[NoticeProvider]> = try await satellite
                .response(
                    for: Path.getAllDepartments.path,
                    httpMethod: .get,
                    httpHeaders: [
                        "Content-Type": "application/json",
                        "User-Token": fcmToken
                    ]
                )
            
            // 로컬 값 갱신
            NoticeProvider.departments = response.data
                .compactMap {
                    NoticeProvider(
                        name: $0.name,
                        hostPrefix: $0.hostPrefix,
                        korName: $0.korName,
                        category: .학과
                    )
                }
            return NoticeProvider.departments
        }
    )
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
        },
        getSubscribedUnivNotices: {
            [
                NoticeProvider.학사,
                NoticeProvider.도서관
            ]
        },
        getSubscribedDepartments: {
            [
                NoticeProvider(
                    name: "education",
                    hostPrefix: "edu",
                    korName: "교직과",
                    category: .학과
                ),
                NoticeProvider(
                    name: "physical_education",
                    hostPrefix: "kupe",
                    korName: "체육교육과",
                    category: .학과
                ),
                NoticeProvider(
                    name: "computer_science",
                    hostPrefix: "cse",
                    korName: "컴퓨터공학부",
                    category: .학과
                )
            ]
        },
        getAllUnivNoticeType: {
            [
                NoticeProvider.학사,
                NoticeProvider.취창업,
                NoticeProvider.도서관,
                NoticeProvider.학생,
                NoticeProvider.국제,
                NoticeProvider.장학,
                NoticeProvider.산학,
                NoticeProvider.일반,
            ]
        },
        getAllDepartments: {
            [
                NoticeProvider(
                    name: "education",
                    hostPrefix: "edu",
                    korName: "교직과",
                    category: .학과
                ),
                NoticeProvider(
                    name: "physical_education",
                    hostPrefix: "kupe",
                    korName: "체육교육과",
                    category: .학과
                ),
                NoticeProvider(
                    name: "computer_science",
                    hostPrefix: "cse",
                    korName: "컴퓨터공학부",
                    category: .학과
                )
            ]
        }
    )
}
