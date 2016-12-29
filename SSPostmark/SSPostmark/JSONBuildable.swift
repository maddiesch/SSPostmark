//
//  JSONBuildable.swift
//  SSPostmark
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

import Foundation

protocol JSONBuildable {
    func buildJSON() throws -> [String: Any]
}

extension Array where Element : JSONBuildable {
    func buildJSON() throws -> [[String: Any]] {
        return try self.map() { try $0.buildJSON() }
    }
}
