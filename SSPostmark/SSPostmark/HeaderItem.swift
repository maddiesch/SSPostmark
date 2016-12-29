//
//  HeaderItem.swift
//  SSPostmark
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

import Foundation

/// A custom email header to send with messages
@objc(SSHeaderItem)
public final class HeaderItem : NSObject, JSONBuildable {
    /// The name of the header
    public let name: String

    /// The value of the header
    ///
    /// **Must** be a valid JSON object
    public let headerValue: Any

    public init(name: String, headerValue: Any) {
        self.name = name
        self.headerValue = headerValue
    }

    func buildJSON() throws -> [String : Any] {
        return [
            "Name": self.name,
            "Value": self.headerValue
        ]
    }
}
