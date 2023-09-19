//
//  LocalStorage.swift
//
//
//  Created by Jaesung Lee on 2023/09/19.
//

import Model
import Foundation

actor LocalStorage {
    
}

actor Repository<Element: Codable> {
    let basePath: String
    
    var store: [Element] = []
    
    // fetch local data
    // request remote data
    func onStart() {
        
    }
    
    init(path: String) {
        basePath = path
    }
    
    func read(elementID: String) throws -> Element? {
        var file: URL
        var data: Data?
        let filename = "\(self.basePath)/\(elementID)"
        //get file directory
        file = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent(filename)
        
        //get data
        data = try Data(contentsOf: file)
        
        guard let data = data else { return nil }
        
        //decode data (convert data to model)
        let decoder = JSONDecoder()
        print("파일 읽어들이는 중: \(file.description)")
        return try decoder.decode(Element.self, from: data)
    }
    
    func write(data: Element, id: String) throws {
        var file: URL
        let filename = "\(self.basePath)/\(id)"
        
        file = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent(filename)
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        print("파일을 업데이트합니다: \(file.description)")
        try encoder.encode(data).write(to: file)
    }
    
    func delete(elementID: String) throws {
        var file: URL
        let filename = "\(self.basePath)/\(elementID)"
        file = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        .deletingPathExtension()
        .appendingPathComponent(filename)
        if FileManager.default.fileExists(atPath: file.path) {
            // delete file
            try FileManager.default.removeItem(atPath: file.path)
        }
    }
}

extension Repository where Element: Identifiable {
    enum Error: Swift.Error {
        case idIsNotString
    }
    
    func write(data: Element) throws {
        guard let identifier = data.id as? String else {
            throw Repository.Error.idIsNotString
        }
        try self.write(data: data, id: identifier)
    }
}


/// ```swift
/// let newRepository = Repository(
///     rule: {
///         $0.count <= 20
///     }
/// )
/// ```
