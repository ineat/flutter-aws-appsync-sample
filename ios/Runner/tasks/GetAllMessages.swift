//
//  GetAllMessages.swift
//  Runner
//
//  Created by Mehdi SLIMANI on 05/07/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AWSCore
import AWSAppSync

/*
 * Task for execute the query GetAllMessages in GraphQL file
 * query GetMessages {
 *  getMessages {
 *      id
 *      content
 *      sender
 *  }
 * }
 */
class  GetAllMessages {
    
    private let client: AWSAppSyncClient
    
    init(client: AWSAppSyncClient) {
        self.client = client
    }
    
    public func exec(flutterMethodCall: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
        let query = GetMessagesQuery()
        self.client.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                flutterResult(FlutterError(code: "1", message: error.localizedDescription, details: nil))
            } else {
                if let errors = result!.errors {
                    let error = errors.map({ (error) -> String in
                        error.message
                    }).joined(separator: ", ")
                    flutterResult(FlutterError(code: "1", message: error, details: nil))
                } else {
                    let messages = result!.data!.getMessages!
                    let values = messages.map({ (message) -> Dictionary<String, Any> in
                        if let msg = message {
                            return [
                                "id": msg.id,
                                "content": msg.content,
                                "sender": msg.sender
                            ]
                        } else {
                            return [:]
                        }
                    })
                    
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: values, options: .prettyPrinted)
                        let convertedString = String(data: jsonData, encoding: String.Encoding.utf8)
                        flutterResult(convertedString)
                    } catch {
                        flutterResult(FlutterError(code: "1", message: error.localizedDescription, details: nil))
                    }
                }
            }
        }
    }
}
