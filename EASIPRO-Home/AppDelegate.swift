//
//  AppDelegate.swift
//  EASIPRO-Home
//
//  Created by Raheel Sayeed on 5/1/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//

import UIKit
import EASIPRO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        
        let baseURL = URL(string: "https://launch.smarthealthit.org/v/r3/sim/eyJoIjoiMSIsImkiOiIxIiwiZSI6InNtYXJ0LVByYWN0aXRpb25lci03MTAzMjcwMiJ9/fhir")!
        let settings = [ "client_name" : "EASIPRO",
                         "redirect"    : "easipro-home://callback",
                         "scope"       : "openid profile user/*.*",
                         "client_id"   : "7c5dc7c9-74ca-451a-bd3d-eeb21bb66e93",
                         ]
        
        
//        SMARTManager.shared.client = SMARTManager.client(with: baseURL, settings: settings)
        
        
        
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        print(url)
        let client = SMARTManager.shared.client
        if client.awaitingAuthCallback {
            return client.didRedirect(to: url)
        }
        return false
    }


}

