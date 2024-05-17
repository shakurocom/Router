//
// Copyright (c) 2019 Shakuro (https://shakuro.com/)
//

import UIKit
import Shakuro_ContainerViewController

/// The style of navigation to use to present view controller
public enum NavigationStyle {

    public enum TransitionType {
        case defaultTransition
        case fade
    }

    case push(asRoot: Bool, transitionStyle: TransitionType)
    case modal(transitionStyle: UIModalTransitionStyle?, completion: (() -> Void)?)
    case container(transitionStyle: ContainerViewController.TransitionStyle)
    case splitDetail
    case content(containerView: UIView, completion: (() -> Void)?)

    public static let pushDefault: NavigationStyle = .push(asRoot: false, transitionStyle: .defaultTransition)
    public static let modalDefault: NavigationStyle = .modal(transitionStyle: nil, completion: nil)
    public static let modalCrossDissolve: NavigationStyle = .modal(transitionStyle: .crossDissolve, completion: nil)
}

/// - Tag: Router
open class Router: NSObject, RouterProtocol {

    /// The root navigation controller
    public let rootNavigationController: UINavigationController

     /// The root view controller of root navigation controller
    private(set) public var rootViewController: UIViewController?

     /// true if at least one modal controller is presented
    public var isModalViewControllerOnScreen: Bool {
        return rootNavigationController.presentedViewController != nil
    }

    public init(rootController: UINavigationController) {
        rootNavigationController = rootController
        super.init()
    }

    // MARK: - General

    /// Presents specified view controller using provided style
    /// - Parameters:
    ///   - controller: The UIViewController to present
    ///   - from:The presenting view controller
    ///   - style: presentation (navigation) style
    ///   - animated: true to animate the transition, false to make the transition immediate.
    /// - Returns: newly presented controller in case of success, nil otherwise.
    @discardableResult
    public func presentViewController(controller: UIViewController,
                                      from: UIViewController?,
                                      style: NavigationStyle,
                                      animated: Bool) -> UIViewController? {
        // some of controllers (for example MFMessageComposeViewController) can return nil in non optional value even if canSendText() == true
        let uikitBugFixController: UIViewController? = controller
        guard uikitBugFixController != nil else {
            return nil
        }
        switch style {
        case .push(let asRoot, let transitionType):
            let presentingController: UINavigationController = from?.navigationController ?? rootNavigationController
            if asRoot {
                if presentingController === rootNavigationController {
                    rootViewController = controller
                }
                if animated {
                    switch transitionType {
                    case .defaultTransition:
                        presentingController.setViewControllers([controller], animated: true)
                    case .fade:
                        presentingController.setViewControllers([controller], animated: false)
                        presentingController.view.superview?.layer.addTransitionAnimation(type: .fade, duration: 0.3)
                    }
                } else {
                    presentingController.setViewControllers([controller], animated: false)
                }
            } else {
                if animated {
                    switch transitionType {
                    case .defaultTransition:
                        presentingController.pushViewController(controller, animated: true)
                    case .fade:
                        presentingController.pushViewController(controller, animated: false)
                        presentingController.view.superview?.layer.addTransitionAnimation(type: .fade, duration: 0.3)
                    }
                } else {
                    presentingController.pushViewController(controller, animated: false)
                }
            }
        case .modal(let transitionStyle, let completion):
            let presentingController: UIViewController = from ?? rootNavigationController
            if let trStyle = transitionStyle {
                controller.modalTransitionStyle = trStyle
            }
            presentingController.present(controller, animated: animated, completion: completion)
        case .container(let transitionStyle):
            if let customContainer: ContainerViewControllerPresenting = from?.lookupCustomContainerViewControllerPresening() {
                customContainer.present(controller, style: transitionStyle, animated: animated)
            } else {
                assertionFailure("\(type(of: self)) - \(#function): CustomContainerViewControllerPresening is nil")
            }
        case .splitDetail:
            let presentingController: UIViewController = from ?? rootNavigationController
            if let splitViewController = presentingController.splitViewController ?? (presentingController as? UISplitViewController) {
                splitViewController.showDetailViewController(controller, sender: presentingController)
                if animated {
                    controller.view.superview?.layer.addTransitionAnimation(duration: 0.2)
                }
            } else {
                assertionFailure("\(type(of: self)) - \(#function): splitViewController is nil")
            }
        case .content(let containerView, let completion):
            guard let parentVC = from else {
                assertionFailure("\(type(of: self)) - \(#function): parent view controller (from) is nil.")
                return nil
            }
            guard !(from is UINavigationController) else {
                assertionFailure("\(type(of: self)) - \(#function): 'content' presentation style require 'from' to be not UINavigationController.")
                return nil
            }
            let animations: ((UIView, UIView) -> Void)?
            if animated {
                controller.view.alpha = 0.0
                animations = { (_, childView) in
                    childView.alpha = 1.0
                }
            } else {
                animations = nil
            }
            controller.view.frame = containerView.bounds
            parentVC.addChildViewController(controller,
                                            notifyAboutAppearanceTransition: true,
                                            targetContainerView: containerView,
                                            animationDuration: 0.1,
                                            animations: animations,
                                            completion: completion)
        }
        return controller
    }

    /// Pops view controllers until view controller with the specified type is at the top of the navigation stack.
    /// - Parameters:
    ///   - controllerType: The type of view controller that you want to be at the top of the stack.
    ///   - sender: The view controller to get navigation controller
    ///   - animated: Set this value to true to animate the transition.
    public func popToFirstViewController<ControllerType>(_ controllerType: ControllerType.Type,
                                                         sender: UIViewController,
                                                         animated: Bool = true) {
        if let navController: UINavigationController = sender.navigationController,
            navController.viewControllers.count > 1 {
            let controllers: [UIViewController] = navController.viewControllers
            for actualController: UIViewController in controllers where (actualController as? ControllerType) != nil {
                navController.popToViewController(actualController, animated: animated)
                break
            }
        }
    }

    /// The same as UINavigationController popToViewController, but with additional check of .viewControllers.count
    public func popToViewController(_ controller: UIViewController, sender: UIViewController, animated: Bool = true) {
        if let navController: UINavigationController = sender.navigationController, navController.viewControllers.count > 1 {
            navController.popToViewController(controller, animated: animated)
        }
    }

    /// Dismisses the view controller that was presented modally or via UINavigationController.
    /// - Parameters:
    ///   - controller: The controller to dismiss
    ///   - animated: Set this value to true to animate the transition.
    public func dismissViewController(_ controller: UIViewController, animated: Bool = true) {
        dismissViewController(controller, animated: animated, completion: nil)
    }

    /// Dismisses the view controller that was presented modally or via UINavigationController.
    /// - Parameters:
    ///   - controller: The controller to dismiss
    ///   - animated: Set this value to true to animate the transition.
    ///   - completion: Closure that executed after ciontroller has been dismissed
    public func dismissViewController(_ controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let navigationController = controller.navigationController,
           navigationController.viewControllers.count > 1,
           navigationController.topViewController === controller {
            CATransaction.begin()
            CATransaction.setCompletionBlock(completion)
            navigationController.popViewController(animated: animated)
            CATransaction.commit()
            return
        }
        if let presentingController = controller.presentingViewController,
           (controller.parent == nil || controller.parent == controller.navigationController) {
            presentingController.dismiss(animated: animated, completion: completion)
            return
        }
        if controller.parent != nil {
            if animated {
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        controller.view.alpha = 0.0
                    },
                    completion: { (_) in
                        controller.removeFromParentViewController(notifyAboutAppearanceTransition: true)
                        completion?()
                    })
            } else {
                controller.removeFromParentViewController(notifyAboutAppearanceTransition: true)
                completion?()
            }
            return
        }
        assertionFailure("dismissViewController: attemt to dismiss not presented ViewController")
    }

    /// Dismisses all view controller that were presented modally.
    public func dismissAllModalViewControllers(_ animated: Bool = true) {
        rootNavigationController.dismiss(animated: animated, completion: nil)
    }

    /// Replaces the view controllers currently managed by the root navigation controller with the specified controller.
    public func setRootViewController(controller: UIViewController, animated: Bool = true) {
        rootViewController = controller
        rootNavigationController.setViewControllers([controller], animated: animated)
    }
}

// MARK: - Private

private extension UIViewController {
    func lookupCustomContainerViewControllerPresening() -> ContainerViewControllerPresenting? {
        return (self as? ContainerViewControllerPresenting) ?? self.containerViewController ?? self.parent?.lookupCustomContainerViewControllerPresening()
    }
}
