//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 17.07.2022.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if CommandLine.arguments.contains("IS_RUNNING_UITEST") {
            ExchangeService.coreDataStack = TestCoreDataStack()
            let mockUrlSession = MockURLSession()
            mockUrlSession.createTestData(for: .privatBank(with: Date()))
            NetworkService.urlSession = mockUrlSession.byDefault
        }
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
