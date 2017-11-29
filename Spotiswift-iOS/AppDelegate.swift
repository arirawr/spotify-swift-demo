//
//  AppDelegate.swift
//  Spotiswift-iOS
//
//  Created by Arielle Vaniderstine on 2017-07-21.
//  Copyright © 2017 Arielle Vaniderstine. All rights reserved.
//

import UIKit
import SpotifyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SpotifyLogin.shared.configure(clientID: id, clientSecret: secret, redirectURL: URL(string: "io.ariari.spotify-swift-demo://")!)
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = SpotifyLogin.shared.applicationOpenURL(url) { (error) in }
        return handled
    }

}

