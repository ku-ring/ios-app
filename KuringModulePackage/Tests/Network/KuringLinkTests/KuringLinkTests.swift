//
//  KuringLinkTests.swift
//  
//
//  Created by Jaesung Lee on 2023/09/16.
//

import XCTest
import Network
import Satellite
@testable import KuringLink

final class KuringLinkTests: XCTestCase {
    func test_satellite() async throws {
        let satellite = KuringLink.satellite
        
        XCTAssertEqual(satellite.host, "kuring")
        XCTAssertEqual(satellite.scheme, .https)
    }
}
