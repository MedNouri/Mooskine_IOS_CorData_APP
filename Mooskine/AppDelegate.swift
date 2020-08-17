//
//  AppDelegate.swift
//  Mooskine
//
//  Created by Josh Svatek on 2017-05-29.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
 let dataControler = DataController(modelName: "Mooskine")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        dataControler.load {
            print("im loded")
        }
        let root = window?.rootViewController as? UINavigationController
        let listview = root?.topViewController as? NotebooksListViewController
        listview?.dataControler = dataControler
        
        return true
    }

 
    
    func applicationDidEnterBackground(_ application: UIApplication) {
         // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
         // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
         saveViewContext()
     }

     func applicationWillEnterForeground(_ application: UIApplication) {
         // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
     }

     func applicationDidBecomeActive(_ application: UIApplication) {
         // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     }

     func applicationWillTerminate(_ application: UIApplication) {
         // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
         saveViewContext()
     }

     func saveViewContext() {
         try? dataControler.viewContext.save()
     }
}

