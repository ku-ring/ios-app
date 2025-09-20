//
//  Satelite+Extension.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/20/25.
//

import Satellite
import Foundation

extension Satellite {
    static let patch = "PATCH"
    
    public func response<ResponseType: Decodable>(
        for path: String,
        httpMethod: String,
        queryItems: [URLQueryItem]? = nil,
        httpHeaders: [String: String]? = ["Content-Type": "application/json"],
        httpBody: (any Encodable)? = nil
    ) async throws -> ResponseType {
        let urlRequest = try createRequest(
            for: path,
            httpMethod: httpMethod,
            queryItems: queryItems,
            httpHeaders: httpHeaders,
            httpBody: httpBody
        )
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        showGPT(String(data: data, encoding: .utf8) ?? "Unknown data")
        guard let httpResponse = response as? HTTPURLResponse else {
            let error = Satellite.Error.responseHasNoData
            showGPT(error.description)
            throw error
        }
        guard (200..<300) ~= httpResponse.statusCode else {
            let error = Satellite.Error.statusCode(httpResponse.statusCode)
            showGPT(error.description)
            throw error
        }
        guard let output = try? JSONDecoder().decode(ResponseType.self, from: data) else {
            let error = Satellite.Error.responseIsFailedDecoding
            showGPT(error.description)
            throw error
        }
        return output
    }
    
    func createRequest(
        for path: String,
        httpMethod: String,
        queryItems: [URLQueryItem]?,
        httpHeaders: [String: String]?,
        httpBody: (any Encodable)?
    ) throws -> URLRequest {
        showGPT("\(baseURL)/\(path)")
        guard var components = URLComponents(string: "\(baseURL)/\(path)") else {
            let error = Satellite.Error.urlIsInvalid
            showGPT(error.description)
            throw error
        }
        if let queryItems {
            components.queryItems = queryItems
        }
        guard let url = components.url else {
            let error = Satellite.Error.urlIsInvalid
            showGPT(error.description)
            throw error
        }
        var urlRequest = URLRequest(url: url, timeoutInterval: 5.0)
        urlRequest.httpMethod = httpMethod
        if let httpHeaders {
            httpHeaders.forEach { (key, value) in
                urlRequest.addValue(value, forHTTPHeaderField: key)
            }
        }
        if let httpBody {
            urlRequest.httpBody = try JSONEncoder().encode(httpBody)
        }
        showGPT(urlRequest.description)
        return urlRequest
    }
}
