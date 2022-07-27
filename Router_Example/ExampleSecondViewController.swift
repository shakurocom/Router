//
// Copyright (c) 2022 Shakuro (https://shakuro.com/)
//
//

import UIKit
import Router_Framework

class ExampleSecondViewController: UIViewController {

    @IBOutlet private var inputURL: UITextField!

    private enum Constants {
        static let storyboardName = "Main"
        static let controllerName = "ExampleSecondViewController"
    }

    static func instantiate(_ router: RoutingSupport) -> UIViewController {
        let storyboard = UIStoryboard(name: Constants.storyboardName, bundle: nil)
        let controller: ExampleSecondViewController = storyboard.instantiateViewController(withIdentifier: Constants.controllerName)

        controller.router = router

        return controller
    }

    private var router: RoutingSupport?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.controllerName
    }
}

private extension ExampleSecondViewController {
    @IBAction private func openURLButtonTapped() {
        let components = URLComponents(string: inputURL.text ?? "")
        guard let url = components?.url, UIApplication.shared.canOpenURL(url) else {
            router?.presentErrorAlert(NSLocalizedString("Enter valid URL.", comment: ""), sender: self, animated: true)
            return
        }
        router?.presentURL(self, options: SafariViewControllerOptions(URI: url))
    }

    @IBAction private func backButtonTapped() {
        router?.dismissViewController(self, animated: true)
    }
}
