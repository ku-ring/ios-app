import Foundation
import SwiftUI
import Combine

public class SSEClient: NSObject, ObservableObject, URLSessionDataDelegate {
    @Published public var messages: [String] = []
    @Published public var error: Error?
    
    private var content: String
    private var temp: Double
    
    public var url: URL
    public var session: URLSession?
    public var task: URLSessionDataTask?
    private var testableFCMToken: String = "cZSHjO4_bUjirvsrxWzig5:APA91bHPojABL5oEXi5AcjJ8v4Vcp3KpJfFUD_3b--xiMTWbrk-QKuc4Nrxd_BhEArO7Svo"

    public init(content: String, temp: Double) {
        self.content = content
        self.temp = temp
        
        let encodedContent = content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        self.url = URL(string: "https://kuring.herokuapp.com/api/v2/ai/messages?question=\(encodedContent)")!
        
        super.init()
    }
    
    public func start() {
        print("SSEClient: Starting SSE connection with URL: \(url)")
        
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForRequest = 60
        
        session = URLSession(configuration: sessionConfiguration, delegate: self, delegateQueue: nil)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
        request.setValue(testableFCMToken, forHTTPHeaderField: "User-Token")
        
        print("SSEClient: URLRequest - Headers: \(request.allHTTPHeaderFields ?? [:]), Method: \(request.httpMethod ?? "")")
        
        task = session?.dataTask(with: request)
        task?.resume()
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if let message = String(data: data, encoding: .utf8) {
            DispatchQueue.main.async {
                self.messages.append(message)
            }
            print("SSEClient: Received SSE message:\n\(message)")
        } else {
            print("SSEClient: Received data could not be converted to String.")
        }
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("SSEClient: SSE connection error: \(error.localizedDescription)")
            DispatchQueue.main.async {
                self.error = error
            }
        } else {
            print("SSEClient: SSE connection completed without error.")
        }
    }
}

