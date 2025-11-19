//
// Copyright (c) 2024 쿠링
// See the 'License.txt' file for licensing information.
//

import Models
import SwiftUI
import Combine
import OSLog

public class SSEClient: NSObject, ObservableObject, URLSessionDataDelegate {
    @Published public var error: Error?
    public var sendMessage: ((String) -> Void)?
    public static let shared = SSEClient()
    public var task: URLSessionDataTask?
    private var url: URL
    private var session: URLSession?
    @AppStorage("com.kuring.sdk.v2.token.fcm")
    private var fcmToken: String = ""
    private let logger = Logger(subsystem: "Network", category: "SSEClient")

    public override init() {
        let plistURL = Bundle.module.url(forResource: "KuringLink-Info", withExtension: "plist")!
        let dict = try! NSDictionary(contentsOf: plistURL, error: ())
        
        let apiHost: String
        #if DEBUG
        apiHost = dict["DEBUG_API_HOST"] as? String ?? ""
        #else
        apiHost = dict["API_HOST"] as? String ?? ""
        #endif
        let usingHttps = (dict["USING_HTTPS"] as? Bool) ?? true
        let scheme = usingHttps ? "https" : "http"
        
        let urlString = "\(scheme)://\(apiHost)/api/v2/ai/messages"
        
        let url = URL(string: urlString)!
        
        self.url = url
        super.init()
    }
    
    public func sessionStart(question: String) {
        let encodedQuestion = question.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let queryURL = URL(string: "\(url.absoluteString)?question=\(encodedQuestion)")!
        
        let sessionConfiguration = URLSessionConfiguration.default
        session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: queryURL)
        
        request.httpMethod = "GET"
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue(fcmToken, forHTTPHeaderField: "User-Token")
        request.setValue("no-cache", forHTTPHeaderField: "Cache-Control")
        
        task = session?.dataTask(with: request)
        task?.resume()
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let message = String(data: data, encoding: .utf8) {
            let processedMessage = message
                .components(separatedBy: .newlines)
                .map { $0.replacingOccurrences(of: "data:", with: "") }
                .joined()
            self.sendMessage?(processedMessage)
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            Task { @MainActor in
                self.error = error
                logger.error("SSEClient: SSE connection error: \(error.localizedDescription)")
            }
        }
    }
}
