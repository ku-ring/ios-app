//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Combine

/// 새 공지 알림을 탭했을 때 퍼블리싱 하는 퍼블리셔.
/// ```swift
/// .onReceive(newMessagePublisher) { message in
///     switch message {
///     case let .notice(notice):
///         self.newNotice = notice
///     case let .custom(title, body, link):
///         // handle custom notification
///     }
/// }
/// ```
public let newMessagePublisher = PassthroughSubject<Message, Never>()
