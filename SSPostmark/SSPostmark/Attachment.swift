//
//  Attachment.swift
//  SSPostmark
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

import Foundation

#if os(iOS)
    import MobileCoreServices
#elseif os(OSX)
    import CoreServices
#endif

/// An attachment that will be sent along with the email
@objc(SSAttachment)
public final class Attachment : NSObject, JSONBuildable {

    /// The name of the file.  This will be displayed to the user in their email client.
    public let fileName: String

    /// The content type of the file.  This will try and be inferred from the fileName extension
    /// If the value can't be inferred then application/octect-stream will be used
    public let contentType: String

    /// Can be used to inline images into the email HTML
    public var contentID: String?

    /// The location of the file to attach.
    public let fileURL: URL?

    /// The data to be encoded.
    public let fileData: Data?


    /// Creates a new attachment
    ///
    /// - Parameters:
    ///   - fileName:    The name of the file
    ///   - contentType: Explicitly set the content type.  Passing nil will try and infer the value from the fileName extension
    ///   - fileURL:     The location of the file to attach to the email
    ///   - fileData:    The data to attach to the email
    ///
    /// - Note: If both fileURL and fileData are specified, only the fileData will be sent to Postmark
    public init(fileName: String, contentType: String?, fileURL: URL?, fileData: Data?) {
        self.fileName = fileName
        self.contentType = contentType ?? Attachment.inferContentType(forFileName: fileName)
        self.fileURL = fileURL
        self.fileData = fileData
    }

    /// Infer the MIME type from the passed file name, using it's extension
    ///
    /// - Parameter fileName: The name of the file
    /// - Returns: The MIME type for the file.  If this value can't be inferred `application/octet-stream` will be used.
    public class func inferContentType(forFileName fileName: String) -> String {
        guard let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (fileName as NSString).pathExtension as CFString, nil)?.takeRetainedValue() else {
            return "application/octet-stream"
        }
        guard let mimeType = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() else {
            return "application/octet-stream"
        }
        return mimeType as String
    }

    /// Retruns a set of file extensions that are forbidden by Postmark
    public class func forbiddenFileTypes() -> Set<String> {
        return [
            "vbs", "exe", "bin", "bat", "chm", "com", "cpl", "crt", "hlp", "hta", "inf", "ins", "isp", "jse", "lnk", "mdb", "pcd", "pif", "reg", "scr", "sct", "shs", "vbe", "vba", "wsf", "wsh", "wsl", "msc", "msi", "msp", "mst"
        ]
    }

    // MARK: - Helper Methods
    func buildJSON() throws -> [String : Any] {
        var json: [String: Any] = [:]
        json["Name"] = self.fileName
        json["ContentType"] = self.contentType
        if let cID = self.contentID {
            json["ContentID"] = cID
        }
        json["Content"] = try self.buildContent()
        return json
    }

    private func buildContent() throws -> String {
        if let data = self.fileData {
            return try self.buildContent(forData: data)
        }
        guard let url = self.fileURL else {
            throw PostmarkError(.attachmentMissingContent)
        }
        let data = try Data(contentsOf: url)
        return try self.buildContent(forData: data)
    }

    private func buildContent(forData data: Data) throws -> String {
        return data.base64EncodedString()
    }
}
