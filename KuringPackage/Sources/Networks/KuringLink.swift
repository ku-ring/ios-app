import Models
import Satellite
import Foundation

public typealias NoticeCount = Int
public typealias NoticeType = String
public typealias Department = String
public typealias Page = Int

public typealias FCMToken = String

public typealias NoticeTypeName = String
public typealias DepartmentHostPrefix = String

public struct KuringLink {
    static var satellite: Satellite {
        let plistURL = Bundle.module.url(forResource: "KuringLink-Info", withExtension: "plist")!
        let dict = try! NSDictionary(contentsOf: plistURL, error: ())
        let satellite = Satellite(
            host: (dict["API_HOST"] as? String) ?? "",
            scheme: (dict["USING_HTTPS"] as? Bool) ?? true ? .https : .http
        )
//        satellite._startGPS()
        return satellite
    }
    static let appVersion = "" // NEXT_VERSION
    static let iosVersion = {
        let osVersion = ProcessInfo.processInfo.operatingSystemVersion
        let iosVersion = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
        return iosVersion
    }()
    // TODO: kuring.set(\.fcmToken, "{FCM.TOKEN}")
    static var fcmToken: String = ""
    
    // MARK: - Notices
    public var fetchNotices: (NoticeCount, NoticeType, Department?, Page) async throws -> [Notice]
    
    public var sendFeedback: (String) async throws -> Bool
    
    // MARK: - Search
    public var searchNotices: (_ keyword: String) async throws -> [Notice]
    
    public var searchStaffs: (_ keyword: String) async throws -> [Staff]
    
    public var subscribeUnivNotices: ([NoticeTypeName], FCMToken) async throws -> Bool
    
    public var subscribeDepartments: ([DepartmentHostPrefix], FCMToken) async throws -> Bool
}
