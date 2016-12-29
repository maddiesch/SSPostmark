//
//  Localize.swift
//  SSPostmark
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

import Foundation

private let FrameworkBundle = Bundle(for: Postmark.self)

internal func LocalizedString(_ key: String) -> String {
    return NSLocalizedString(key, tableName: nil, bundle: FrameworkBundle, value: key, comment: "")
}
