//
//  AppDelegate.swift
//  Todomy
//
//  Created by Jason on 2018/8/6.
//  Copyright © 2018年 Jiaxin Li. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        do
        {
            _ = try Realm()
        }
        catch
        {
            print("Error intialising new realm, \(error)")
        }
        
        return true
    }

    
}
