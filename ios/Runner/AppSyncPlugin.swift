//
//  AppSyncPlugin.swift
//  Runner
//
//  Created by Mehdi SLIMANI on 05/07/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import Flutter
import AWSCore
import AWSAppSync

/*
 * Plugin to call GraphQL requests generated from the schema
 */
public class AppSyncPlugin: NSObject, FlutterPlugin {
    
    static let CHANNEL_NAME = "com.ineat.appsync"
    static let QUERY_GET_ALL_MESSAGES = "getAllMessages"
    static let MUTATION_NEW_MESSAGE = "newMessage"
    static let SUBSCRIBE_NEW_MESSAGE = "subscribeNewMessage"
    static let SUBSCRIBE_NEW_MESSAGE_RESULT = "subscribeNewMessageResult"
    
    // Client AWS AppSync for call GraphQL requests
    var appSyncClient: AWSAppSyncClient?
    
    let channel: FlutterMethodChannel
    
    init(channel: FlutterMethodChannel) {
        self.channel = channel
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: CHANNEL_NAME, binaryMessenger: registrar.messenger())
        let instance = AppSyncPlugin(channel: channel)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        prepareClient(call: call)
        onPerformMethodCall(call: call, result: result)
    }
    
    /**
     * Handle type method. Call task for run GraphQL request
     */
    private func onPerformMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case AppSyncPlugin.QUERY_GET_ALL_MESSAGES:
            GetAllMessages(client: appSyncClient!).exec(flutterMethodCall: call, flutterResult: result)
        case AppSyncPlugin.MUTATION_NEW_MESSAGE:
            NewMessage(client: appSyncClient!).exec(flutterMethodCall: call, flutterResult: result)
        case AppSyncPlugin.SUBSCRIBE_NEW_MESSAGE:
            SubscriptionToNewMessage(client: appSyncClient!, channel: self.channel).exec(flutterMethodCall: call, flutterResult: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    /**
     * Create AWS AppSync Client if not exist
     */
    private func prepareClient(call: FlutterMethodCall) {
        let args = call.arguments as! Dictionary<String, Any>
        let endpoint = args["endpoint"] as! String
        let apiKey = args["apiKey"] as! String
        let databaseName = "appsync-local-db"
        
        let databaseURL = URL(fileURLWithPath:NSTemporaryDirectory()).appendingPathComponent(databaseName)
        
        
        do {
            let provider: AWSAPIKeyAuthProvider = APIKeyAuthProvider(apiKey: apiKey)
            let appSyncConfig = try AWSAppSyncClientConfiguration(url: URL(string:endpoint)!,
                                                                  serviceRegion: .EUCentral1,
                                                                  apiKeyAuthProvider: provider,
                                                                  databaseURL:databaseURL)
            appSyncClient = try AWSAppSyncClient(appSyncConfig: appSyncConfig)
            appSyncClient?.apolloClient?.cacheKeyForObject = { $0["id"] }
            
        } catch {
            print("Error initializing AppSync client. \(error)")
        }
    }
    
}

