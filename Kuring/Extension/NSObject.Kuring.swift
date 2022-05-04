//
//  NSObject.Kuring.swift
//  Kuring
//
//  Created by Jaesung Lee on 2022/03/25.
//

import Foundation
import KuringCommons

public extension NSObject {
    /// This gets the class name of object.
    static var className: String {
        guard let className = String(describing: self).components(separatedBy: ".").last else {
            Logger.error(String(describing: self))
            fatalError("Class name couldn't find.")
        }
        return className
    }
    
    /// This gets the class name of object.
    var className: String {
        guard let className = String(describing: self)
                .components(separatedBy: ":").first?
                .components(separatedBy: ".").last
        else {
            Logger.error(String(describing: self))
            fatalError("Class name couldn't find.")
        }
        return className
    }
}
