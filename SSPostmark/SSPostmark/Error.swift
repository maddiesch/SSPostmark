//
//  Error.swift
//  SSPostmark
//
//  Created by Skylar Schipper on 12/29/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

import Foundation

public struct PostmarkError : CustomNSError {
    public static var errorDomain: String {
        return "SSPostmarkErrorDomain"
    }

    public enum Code : Int {
        case unknown                    = 0
        case messageMissingFromAddress  = 1
        case messageMissingSubject      = 2
        case messageMissingBody         = 3
        case messageMissingToAddresses  = 4
        case responseInvalidURLResponse = 5
        case responseMissingBody        = 6
        case attachmentMissingContent   = 7

        var localized: String {
            switch self {
            case .unknown:
                return LocalizedString("pm.error.unknown")
            case .messageMissingFromAddress:
                return LocalizedString("pm.message.error.missingFromAddress")
            case .messageMissingSubject:
                return LocalizedString("pm.message.error.missingSubject")
            case .messageMissingBody:
                return LocalizedString("pm.message.error.missingBody")
            case .messageMissingToAddresses:
                return LocalizedString("pm.message.error.missingToAddresses")
            case .responseInvalidURLResponse:
                return LocalizedString("pm.response.error.invalid-url-response")
            case .responseMissingBody:
                return LocalizedString("pm.response.error.missing-body")
            case .attachmentMissingContent:
                return LocalizedString("pm.attachment.error.missing-content")
            }
        }
    }

    public var errorCode: Int {
        return self.code.rawValue
    }

    public var errorUserInfo: [String : Any] {
        var info: [String: Any] = [:]
        info[NSLocalizedDescriptionKey] = self.message
        if let sub = self.subError {
            info[NSUnderlyingErrorKey] = sub as NSError
        }
        return info
    }

    public let code: Code

    public let message: String

    public let subError: Error?

    init(_ code: Code, _ message: String? = nil, subError: Error? = nil) {
        self.code = code
        self.message = message ?? code.localized
        self.subError = subError
    }
}
