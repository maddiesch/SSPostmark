//
//  Response.swift
//  SSPostmark
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

import Foundation

@objc(SSResponse)
public final class Response : NSObject {
    public let data: Data?

    public let urlResponse: HTTPURLResponse?

    init(_ data: Data?, _ urlResponse: HTTPURLResponse?) {
        self.data = data
        self.urlResponse = urlResponse
    }

    public var message: String?
    public var messageID: String?

    func prepare() throws {
        guard let response = self.urlResponse else {
            throw PostmarkError(.responseInvalidURLResponse)
        }
        if let error = HTTPError(response, self.data) {
            throw error
        }
        if (response.allHeaderFields["Content-Type"] as? String)?.contains("application/json") ?? false {
            guard let data = self.data else {
                throw PostmarkError(.responseMissingBody)
            }
            if let body = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                self.message = body["Message"] as? String
                self.messageID = body["MessageID"] as? String
            }
        }
    }
}

public struct HTTPError: CustomNSError {
    public static var errorDomain: String {
        return "SSPostmarkHTTPErrorDomain"
    }

    public var errorCode: Int {
        return self.status
    }

    public var errorUserInfo: [String : Any] {
        var info: [String: Any] = [:]
        info[NSLocalizedDescriptionKey] = self.message
        if let subError = self.subError {
            info[NSUnderlyingErrorKey] = subError as NSError
        }
        return info
    }

    public let status: Int
    public let message: String
    public let subError: PostmarkAPIError?

    init?(_ response: HTTPURLResponse, _ data: Data?) {
        guard !(200..<300).contains(response.statusCode) else {
            return nil
        }
        self.status = response.statusCode
        self.message = LocalizedString("pm.http-error.message")
        self.subError = PostmarkAPIError(response, data)
    }
}

public struct PostmarkAPIError: CustomNSError {
    public static var errorDomain: String {
        return "SSPostmarkAPIErrorDomain"
    }

    public var errorUserInfo: [String : Any] {
        return [
            NSLocalizedDescriptionKey: self.message
        ]
    }

    public let errorCode: Int
    public let message: String

    init?(_ response: HTTPURLResponse, _ data: Data?) {
        guard response.statusCode == 422 else {
            return nil
        }

        guard let rawData = data else {
            return nil
        }

        do {
            guard let json = try JSONSerialization.jsonObject(with: rawData, options: []) as? [String: Any] else {
                return nil
            }
            guard let code = json["ErrorCode"] as? Int else {
                return nil
            }
            guard let message = json["Message"] as? String else {
                return nil
            }
            self.errorCode = code
            self.message = message
        } catch let e {
            print("Got a sub error from Postmark, but failed to create sub-error \(e)")
            return nil
        }
    }
}
