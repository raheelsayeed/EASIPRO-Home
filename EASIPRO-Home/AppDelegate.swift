//
//  AppDelegate.swift
//  EASIPRO-Home
//
//  Created by Raheel Sayeed on 5/1/18.
//  Copyright © 2018 Boston Children's Hospital. All rights reserved.
//
/*
 Heart Icon: https://www.iconfinder.com/icons/1118211/disease_graph_heart_medical_medicine_icon#size=512
 
 
 */

import UIKit
import EASIPRO




@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        window?.tintColor = UIColor.white
        
        
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

