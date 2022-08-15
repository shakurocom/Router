//
// Copyright (c) 2022 Shakuro (https://shakuro.com/)
//
//

import UIKit
import Router_Framework

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private var exampleRouter: ExampleRouter?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        guard let rootNavigationController: UINavigationController = window?.rootViewController as? UINavigationController else {
            fatalError("\(type(of: self)) - \(#function): self.window?.rootViewController has wrong type")
        }

        exampleRouter = ExampleRouter(rootController: rootNavigationController)
        exampleRouter?.setupRootViewController()

        return true
    }

}
