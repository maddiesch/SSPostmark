//
//  Message.swift
//  SSPostmark
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

import Foundation

@objc(SSMessage)
public final class Message : NSObject, JSONBuildable {

    /// The email address the message will be sent from.
    public var fromAddress: String?

    /// The email address the recipients should reply to.
    public var replyToAddress: String?

    /// Email addresses the message will be sent you.
    ///
    /// In the form of `user@example.com` | `"User Name" <user@example.com>`
    public var toAddresses: [String] = []

    /// Email addresses to cc on the message.
    ///
    /// In the form of `user@example.com` | `"User Name" <user@example.com>`
    public var ccAddresses: [String] = []

    /// Email addresses to bcc on the message.
    ///
    /// In the form of `user@example.com` | `"User Name" <user@example.com>`
    public var bccAddresses: [String] = []

    /// An array of `HeaderItem` objects to include in the request
    public var additionalHeaders: [HeaderItem] = []

    /// An array of `Attachment` objects to include in the request.
    public var attachments: [Attachment] = []

    /// The message subject
    public var subject: String?

    /// HTML body of the message
    public var htmlBody: String?

    /// Text body of the message
    public var textBody: String?

    /// Postmark Tag
    public var tag: String?

    /// Postmark should track opens
    public var tracksOpens: Bool = false


    /// A Message must have
    ///
    ///     - fromAddress
    ///     - subject
    ///     - htmlBody or textBody
    ///     - 1 or more toAddresses
    ///
    /// - Throws: f
    public func validate() throws {
        guard self.fromAddress != nil else {
            throw PostmarkError(.messageMissingFromAddress)
        }
        guard self.subject != nil else {
            throw PostmarkError(.messageMissingSubject)
        }
        let body = self.htmlBody ?? self.textBody
        guard body != nil else {
            throw PostmarkError(.messageMissingBody)
        }
        guard self.toAddresses.count > 0 else {
            throw PostmarkError(.messageMissingToAddresses)
        }
    }

    internal func buildJSON() throws -> [String: Any] {
        try self.validate()

        var json: [String: Any] = [:]

        json["From"] = self.fromAddress
        json["Subject"] = self.subject
        json["To"] = CreateEmailString(fromAddresses: self.toAddresses)
        json["Cc"] = CreateEmailString(fromAddresses: self.ccAddresses)
        json["Bcc"] = CreateEmailString(fromAddresses: self.bccAddresses)
        json["Headers"] = NSNull()
        json["TrackOpens"] = self.tracksOpens

        if let html = self.htmlBody {
            json["HtmlBody"] = html
        }

        if let text = self.textBody {
            json["TextBody"] = text
        }

        if let tag = self.tag {
            json["Tag"] = tag
        }

        if let replyTo = self.replyToAddress {
            json["ReplyTo"] = replyTo
        }

        if self.additionalHeaders.count > 0 {
            json["Headers"] = try self.additionalHeaders.buildJSON()
        }

        if self.attachments.count > 0 {
            json["Attachments"] = try self.attachments.buildJSON()
        }

        return json
    }
}

fileprivate func CreateEmailString(fromAddresses addresses: [String]?) -> String {
    return (addresses ?? []).sorted().joined(separator: ", ")
}
