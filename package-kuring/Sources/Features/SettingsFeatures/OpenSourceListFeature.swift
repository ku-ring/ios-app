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
    public let github: String
    public let license: String
    public let purpose: String
}

extension Opensource {
    public static let items: [Opensource] = [
        Opensource(
            name: "Composable Architecture",
            github: "https://github.com/pointfreeco/swift-composable-architecture/tree/main",
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
            purpose: "TCA 구조를 위한 스위프트 패키지"
        ),
        Opensource(
            name: "KuringPackage",
            github: "https://github.com/ku-ring/ios-app",
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
            purpose: "패키지 기반 모듈화가 적용된 쿠링 오픈소스 패키지"
        ),
        Opensource(
            name: "The Satellite",
            github: "https://github.com/ku-ring/the-satellite",
            license: """
            MIT License

            Copyright (c) 2023 Kuring

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
            purpose: "iOS API 통신모듈"
        ),
    ]
}
