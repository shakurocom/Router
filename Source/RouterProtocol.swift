//
// Copyright (c) 2019 Shakuro (https://shakuro.com/)
//

import SafariServices
import UIKit
import Shakuro_CommonTypes

/// Router public interface see [Router](x-source-tag://Router)
public protocol RouterProtocol: AnyObject {

    var isModalViewControllerOnScreen: Bool { get }

    @discardableResult
    func presentViewController(controller: UIViewController,
                               from: UIViewController?,
                               style: NavigationStyle,
                               animated: Bool) -> UIViewController?

    func popToViewController(_ controller: UIViewController, sender: UIViewController, animated: Bool)
    func popToFirstViewController<ControllerType>(_ controllerType: ControllerType.Type,
                                                  sender: UIViewController,
                                                  animated: Bool)

    func dismissViewController(_ controller: UIViewController, animated: Bool)
    func dismissViewController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?)

}

/// SFSafariViewController support protocol see [Router+URL](x-source-tag://RouterURL)
public protocol RoutingURLProtocol: AnyObject {
    @discardableResult
    func presentURL(_ sender: UIViewController, options: SafariViewControllerOptions) -> SFSafariViewController?
}

/// Alerts support protocol see [Router+Alert](x-source-tag://RouterAlerts)
public protocol RoutingAlertsProtocol: AnyObject {

    func presentActionSheet(_ title: String?,
                            message: String?,
                            actions: [UIAlertAction],
                            sender: UIViewController?,
                            popoverSourceView: UIView?,
                            animated: Bool)

    func presentAlert(_ title: String?, message: String?, actions: [UIAlertAction], sender: UIViewController?, animated: Bool)
    func presentAlert(_ title: String?, message: String?, sender: UIViewController?, animated: Bool)

    func presentErrorAlert(_ error: PresentableError, sender: UIViewController?, animated: Bool)
    func presentErrorAlert(_ error: PresentableError,
                           actions: [UIAlertAction],
                           sender: UIViewController?,
                           animated: Bool)
    func presentErrorAlert(_ errorMessage: String,
                           sender: UIViewController?,
                           animated: Bool)
    func presentErrorAlert(_ errorMessage: String,
                           actions: [UIAlertAction],
                           sender: UIViewController?,
                           animated: Bool)

}
