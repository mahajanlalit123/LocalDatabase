//
//  AppDelegate.swift
//  LocalDatabase
//
//  Created by Harpalsingh Bachher on 20/02/19.
//  Copyright © 2019 softaidcomputers. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
           _ = try Realm()
        }catch{
            print("Error in installing realm \(error)")
        }
        return true
    }


}

