import UIKit
import Router_Framework

typealias RoutingSupport = RouterProtocol & RoutingAlertsProtocol & RoutingURLProtocol

class ExampleRouter: Router {
    func setupRootViewController() {
        presentViewController(controller: ExampleFirstViewController.instantiate(self),
                              from: nil,
                              style: .push(asRoot: true, transitionStyle: .defaultTransition),
                              animated: false)
    }
}
