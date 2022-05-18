//
//  KuringCampus.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/05/05.
//

import Foundation
import KuringCommons
import SendbirdChatSDK

struct KuringCampus {
    static var appID: String = "" {
        didSet {
            let params = InitParams(applicationID: KuringCampus.appID)
            SendbirdChat.initialize(params: params)
        }
    }
    
    static func getUser(named username: String, resultHandler: @escaping (Result<[User], Error>) -> Void) {
        let urlString = "https://api-\(KuringCampus.appID).sendbird.com/v3/users?nickname=\(username)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        guard let encodedString = encodedString, let url = URL(string: encodedString) else {
            print("Error: cannot create URL")
            resultHandler(.failure(NSError(domain: StringSet.Campus.baseString, code: 400)))
            return
        }
        Logger.debug("🔎 Get user named \(username)...")
        
        // Create the request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json; charset=utf8", forHTTPHeaderField: "Content-Type")
        request.addValue("d6a83837a29d25f4961668d3d7f4be82bccb628a", forHTTPHeaderField: "Api-Token")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                Logger.error(error.localizedDescription)
                resultHandler(.failure(error))
                return
            }
            guard let data = data else {
                Logger.error("Error: Did not receive data")
                resultHandler(.failure(NSError(domain: StringSet.Campus.baseString, code: 400)))
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                Logger.error("Error: HTTP request failed: \((response as! HTTPURLResponse).statusCode)")
                resultHandler(.failure(NSError(domain: StringSet.Campus.baseString, code: 400)))
                return
            }
            let users = try? JSONDecoder().decode([User].self, from: data)
            resultHandler(.success(users ?? []))
        }
        .resume()
    }
}
