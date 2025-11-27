//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import UIKit
import ComposableArchitecture

@Reducer
public struct OpenSourceListFeature {
    @ObservableState
    public struct State: Equatable {
        public let opensources: [Opensource] = Opensource.items

        public init() { }
    }

    public enum Action: Equatable, BindableAction {
        case binding(BindingAction<State>)
        case linkTapped(_ link: String)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { _, action in
            switch action {
            case .binding:
                return .none

            case let .linkTapped(githubLink):
                guard let url = URL(string: githubLink) else { return .none }
                UIApplication.shared.open(url)
                return .none
            }
        }
    }

    public init() { }
}

public struct Opensource: Equatable, Identifiable {
    public var id: String { name }
    public let name: String
    public let link: String
    public let linkName: String
    public let description: String?
    public let license: String
    public let purpose: String
}

extension Opensource {
    public static let items: [Opensource] = [
        Opensource(
            name: "Composable Architecture",
            link: "https://github.com/pointfreeco/swift-composable-architecture/tree/main",
            linkName: "Point-Free, Inc. 라이센스 안내",
            description: "Point-Free 에서 제공한 swift-composable-architecture가 적용되어 있어요.",
            license: """
            MIT License

            Copyright (c) 2020 Point-Free, Inc.

            Permission is hereby granted, free of charge, to any person obtaining a copy
            of this software and associated documentation files (the "Software"), to deal
            in the Software without restriction, including without limitation the rights
            to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
            copies of the Software, and to permit persons to whom the Software is
            furnished to do so, subject to the following conditions:

            The above copyright notice and this permission notice shall be included in all
            copies or substantial portions of the Software.

            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
            IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
            FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
            AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
            LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
            OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
            SOFTWARE.
            """,
            purpose: "아키텍쳐"
        ),
        Opensource(
            name: "KuringPackage",
            link: "https://github.com/ku-ring/ios-app",
            linkName: "쿠링 라이센스 안내",
            description: "쿠링에서 개발한 모듈화된 패키지가 적용되어 있어요.",
            license: """
            MIT License

            Copyright (c) 2021-2024 쿠링

            Permission is hereby granted, free of charge, to any person obtaining a copy
            of this software and associated documentation files (the "Software"), to deal
            in the Software without restriction, including without limitation the rights
            to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
            copies of the Software, and to permit persons to whom the Software is
            furnished to do so, subject to the following conditions:

            The above copyright notice and this permission notice shall be included in all
            copies or substantial portions of the Software.

            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
            IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
            FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
            AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
            LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
            OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
            SOFTWARE.
            """,
            purpose: "소스코드"
        ),
        Opensource(
            name: "The Satellite",
            link: "https://github.com/ku-ring/the-satellite",
            linkName: "쿠링 라이센스 안내",
            description: "쿠링에서 개발한 API 통신 모듈이 적용되어 있어요.",
            license: """
            MIT License

            Copyright (c) 2023 쿠링

            Permission is hereby granted, free of charge, to any person obtaining a copy
            of this software and associated documentation files (the "Software"), to deal
            in the Software without restriction, including without limitation the rights
            to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
            copies of the Software, and to permit persons to whom the Software is
            furnished to do so, subject to the following conditions:

            The above copyright notice and this permission notice shall be included in all
            copies or substantial portions of the Software.

            THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
            IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
            FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
            AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
            LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
            OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
            SOFTWARE.
            """,
            purpose: "네트워크 통신모듈"
        ),
        Opensource(
            name: "Emoji",
            link: "https://toss.im/tossface/copyright",
            linkName: "토스페이스 저작권 안내",
            description: "아래 화면에는 토스팀에서 제공한\n토스페이스가 적용되어 있어요.",
            license: """
            · 카테고리별 푸시알림 선택 화면
            · 피드백 보내기 화면
            """,
            purpose: "이모지"
        )
    ]
}
