//
//  Opensource.swift
//  kuring-uikit-ios
//
//  Created by Hamlit Jason on 2022/02/10.
//

import Foundation

struct Opensource {
    var link: String
    var name: String { link.components(separatedBy: "/").last ?? "" }
    
    init(link: String) {
        self.link = link
    }
}

extension Opensource {
    static let currentList: [Opensource] = [
        Opensource(link: "https://github.com/Alamofire/Alamofire"),
        Opensource(link: "https://github.com/ReactiveX/RxSwift"),
        Opensource(link: "https://github.com/RxSwiftCommunity/RxAlamofire"),
        Opensource(link: "https://github.com/RxSwiftCommunity/RxDataSources"),
        Opensource(link: "https://github.com/RxSwiftCommunity/RxGesture"),
        Opensource(link: "https://github.com/airbnb/lottie-ios"),
        Opensource(link: "https://github.com/SnapKit/SnapKit"),
        Opensource(link: "https://github.com/daltoniam/Starscream"),
        Opensource(link: "https://github.com/devxoul/Then"),
    ].sorted {
        $0.link.components(separatedBy: "/").last ?? "" < $1.link.components(separatedBy: "/").last ?? ""
    }
}
