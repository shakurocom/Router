//
// Copyright (c) 2022 Shakuro (https://shakuro.com/)
//
//

import UIKit
import Router_Framework
import Shakuro_CommonTypes

class ExampleSecondViewController: UIViewController {

    @IBOutlet private var scrollView: UIScrollView!
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
    
    private var keyboardHandler: KeyboardHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = Constants.controllerName

        keyboardHandler = KeyboardHandler(enableCurveHack: false, heightDidChange: { [weak self] (change: KeyboardHandler.KeyboardChange) in
            guard let actualSelf = self else {
                return
            }
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: change.newHeight, right: 0.0)
            UIView.animate(withDuration: change.animationDuration, animations: {
                actualSelf.scrollView.contentInset = contentInsets
            })
        })
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler?.isActive = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        keyboardHandler?.isActive = false
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

// MARK: - UITextFieldDelegate

extension ExampleSecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
}
