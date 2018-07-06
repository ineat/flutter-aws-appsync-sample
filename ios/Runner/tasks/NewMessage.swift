//
//  NewMessage.swift
//  Runner
//
//  Created by Mehdi SLIMANI on 05/07/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AWSCore
import AWSAppSync

/*
 * Task for execute the mutation NewMessage in GraphQL file
 * mutation NewMessage($content: String!, $sender: String!) {
 *  newMessage(content: $content, sender: $sender) {
 *      id
 *      content
 *      sender
 *  }
 * }
 */
class NewMessage {
    
    private let client: AWSAppSyncClient
    
    init(client: AWSAppSyncClient) {
        self.client = client
    }
    
    public func exec(flutterMethodCall: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
        let args = flutterMethodCall.arguments as! Dictionary<String,Any?>
        let content = args["content"] as! String
        let sender = args["sender"] as! String
        
        let mutation = NewMessageMutation(content: content, sender: sender)
        self.client.perform(mutation: mutation) { (result, error) in
            if let error = error as? AWSAppSyncClientError {
                flutterResult(FlutterError(code: "1", message: error.localizedDescription, details: nil))
            } else {
                if let errors = result!.errors {
                    let error = errors.map({ (error) -> String in
                        error.message
                    }).joined(separator: ", ")
                    flutterResult(FlutterError(code: "1", message: error, details: nil))
                } else {
                    let newMessage = result!.data!.newMessage!
                    let values:[String:Any] = [
                        "id": newMessage.id,
                        "content": newMessage.content,
                        "sender": newMessage.sender
                    ]
                    
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

