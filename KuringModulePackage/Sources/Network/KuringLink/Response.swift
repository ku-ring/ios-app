//
//  Response.swift
//  
//
//  Created by Jaesung Lee on 2023/09/13.
//

import Foundation

struct Response<ResultData: Decodable>: Decodable {
    let code: Int
    let message: String
    let data: ResultData
}

struct EmptyResponse: Decodable {
    let code: Int
    let message: String
}
