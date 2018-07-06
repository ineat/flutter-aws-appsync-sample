//
//  SubscriptionToNewMessage.swift
//  Runner
//
//  Created by Mehdi SLIMANI on 05/07/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AWSCore
import AWSAppSync

class SubscriptionToNewMessage {
    
    private let client: AWSAppSyncClient
    private let channel: FlutterMethodChannel
    
    init(client: AWSAppSyncClient, channel: FlutterMethodChannel) {
        self.client = client
        self.channel = channel
    }
    
    public func exec(flutterMethodCall: FlutterMethodCall, flutterResult: @escaping FlutterResult) {
        do {
            let subscription = SubscribeToNewMessageSubscription()
            try self.client.subscribe(subscription: subscription, resultHandler: ({ (result, transaction, error) in
                if let result = result {
                    if let subscribeToNewMessage = result.data?.subscribeToNewMessage {
                        let values:[String:Any] = [
                            "id" : subscribeToNewMessage.id,
                            "content" : subscribeToNewMessage.content,
                            "sender" : subscribeToNewMessage.sender
                        ]
                        
                        do {
                            let jsonData = try JSONSerialization.data(withJSONObject: values, options: .prettyPrinted)
                            let convertedString = String(data: jsonData, encoding: String.Encoding.utf8)
                            self.channel.invokeMethod(AppSyncPlugin.SUBSCRIBE_NEW_MESSAGE_RESULT, arguments: convertedString)
                        } catch {
                            flutterResult(FlutterError(code: "1", message: error.localizedDescription, details: nil))
                        }
                    }
                    
                } else if let error = error {
                    print(error.localizedDescription)
                }
            }))
        } catch {
            print("Error starting subscription.")
        }
    }
}

