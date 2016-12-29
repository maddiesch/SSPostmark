//
//  Postmark.swift
//  SSPostmark
//
//  Created by Skylar Schipper on 12/28/16.
//  Copyright © 2016 Skylar Schipper. All rights reserved.
//

import Foundation

public typealias CompletionHandler = (Response?, Error?) -> (Void)

/// Postmark API client
@objc(SSPostmark)
public final class Postmark : NSObject {

    /// The API key used to authenticate against the Postmark API
    /// Value can be found on the Credentials tab under your Postmark server.
    let apiKey: String

    /// Create a new Postmark instance
    ///
    /// - Parameter apiKey: The Postmark API Key
    public init(apiKey: String) {
        self.apiKey = apiKey
    }

    deinit {
        self.session.finishTasksAndInvalidate()
    }

    private let queue = DispatchQueue(label: "com.skylarsch.PostmarkDelivery", qos: .unspecified, attributes: [.concurrent])

    private let session: URLSession = {
        let config = URLSessionConfiguration.ephemeral
        config.httpAdditionalHeaders = [
            "Accept": "application/json",
            "Content-Type": "application/json"
        ]
        return URLSession(configuration: config)
    }()

    /// Deliver a Message to the Postmark API
    ///
    /// - Parameters:
    ///   - message: The message to be delivered
    ///   - completion: The block to handle the completion.  Called on a random queue
    @objc(deliverMessage:completion:)
    public final func deliver(message: Message, completion: CompletionHandler?) {
        self.queue.async {
            self.asyncDeliver(message, completion)
        }
    }

    // MARK: - Private Helper Methods
    private func asyncDeliver(_ message: Message, _ completion: CompletionHandler?) {
        do {
            let json = try message.buildJSON()
            let data = try JSONSerialization.data(withJSONObject: json, options: [])
            let request = try self.createMessageRequest(data)
            let task = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
                self.handleMessageResponse(data, response as? HTTPURLResponse, error, completion)
            })
            task.resume()
        } catch let e {
            completion?(nil, e)
        }
    }

    private func createMessageRequest(_ data: Data) throws -> URLRequest {
        var components = PostmarkURLComponents()
        components.path = "/email"

        guard let url = components.url else {
            fatalError("Framework Error: Failed to create a valid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(data.count)", forHTTPHeaderField: "Content-Length")
        request.setValue(self.apiKey, forHTTPHeaderField: "X-Postmark-Server-Token")
        return request
    }

    private func handleMessageResponse(_ data: Data?, _ urlResponse: HTTPURLResponse?, _ error: Error?, _ completion: CompletionHandler?) {
        guard error == nil else {
            completion?(nil, error)
            return
        }
        let response = Response(data, urlResponse)
        do {
            try response.prepare()
            completion?(response, nil)
        } catch let e {
            completion?(nil, e)
        }
    }
}
