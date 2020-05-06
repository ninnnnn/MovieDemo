//
//  AppDelegate.swift
//  MovieDemo
//
//  Created by ST_Ninn.Wang 王季寧 on 2020/4/24.
//  Copyright © 2020 ST_Ninn.Wang 王季寧. All rights reserved.
//

import UIKit

let width = UIScreen.main.bounds.width
let height = UIScreen.main.bounds.height

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    static let shared = UIApplication.shared.delegate as! AppDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                            NSAttributedString.Key.font: UIFont(name: "PingFangSC-Semibold", size: 22)!
        ]
        
        return true
    }

}

