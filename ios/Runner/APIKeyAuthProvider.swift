//
//  APIKeyAuthProvider.swift
//  Runner
//
//  Created by Mehdi SLIMANI on 05/07/2018.
//  Copyright © 2018 The Chromium Authors. All rights reserved.
//

import Foundation
import AWSCore
import AWSAppSync

class APIKeyAuthProvider: AWSAPIKeyAuthProvider {
    
    private var key: String
    
    init(apiKey: String) {
        self.key = apiKey
    }
    
    func getAPIKey() -> String {
        return self.key
    }
    
}
