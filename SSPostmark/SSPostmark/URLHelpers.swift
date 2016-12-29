//
//  URLHelpers.swift
//  SSPostmark
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

import Foundation

internal func PostmarkURLComponents() -> URLComponents {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.postmarkapp.com"
    return components
}
