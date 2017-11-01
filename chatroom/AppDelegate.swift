//
//  AppDelegate.swift
//  chatroom
//
//  Created by Neo Ighodaro on 26/10/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit

struct AppConstants {
    static let ENDPOINT    = "http://localhost:4000";
    static let INSTANCE_LOCATOR = "PUSHER_CHATKIT_INSTANCE_LOCATOR";
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

