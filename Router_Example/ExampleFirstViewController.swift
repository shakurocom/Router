//
// Copyright (c) 2022 Shakuro (https://shakuro.com/)
//
//

import UIKit
import Shakuro_CommonTypes

class ExampleFirstViewController: UIViewController {

    private enum Constants {
        static let storyboardName = "Main"
        static let controllerName = "ExampleFirstViewController"
    }

    static func instantiate(_ router: RoutingSupport) -> UIViewController {
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        let controller: ExampleFirstViewController = storyboard.instantiateViewController(withIdentifier: Constants.controllerName)

        controller.router = router

        return controller
    }

    private var router: RoutingSupport?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.controllerName
    }
}

private extension ExampleFirstViewController {
    @IBAction private func secondControllerButtonTapped() {
        guard let actualRouter = router else {
            return
        }
        actualRouter.presentViewController(
            controller: ExampleSecondViewController.instantiate(actualRouter),
            from: self,
            style: .pushDefault,
            animated: true)
    }
}
