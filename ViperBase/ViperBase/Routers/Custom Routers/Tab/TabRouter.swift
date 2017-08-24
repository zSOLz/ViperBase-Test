//
//  TabRouter.swift
//  ViperBase
//
//  Created by SOL on 02.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import UIKit

/**
 Custom router represents capabilities of tab bar controller: You can use multiple child controllers and navigate between them by 'tabs'.
 Use it to implement tab bar based routing logic.
 By default this class implements only base tab bar controller logic. Subclass it to add specipic behavior.
 */
open class TabRouter: Router, StackRouterInterface {
    /// Strong reference to tab bar controller
    fileprivate var innerTabBarController: PresentableTabBarController?

    /// Initialized tab bar controller's property. In case tab bar controller is not initialized calls *loadNavigationController()* method (Similar to *loadView()* pattern of UIViewController class).
    open var tabBarController: PresentableTabBarController {
        get {
            if let controller = innerTabBarController {
                return controller
            }
            
            loadTabBarController()
            
            guard let controller = innerTabBarController else {
                fatalError("ViperBase.TabRouter.tabBarController\n" +
                    "'tabBarController' variable should be initialized after 'loadTabBarController' method call.")
            }
            return controller
        }
        set {
            innerTabBarController = newValue
        }
    }
    
    /// Overrided property of 'Router' class.
    /// Returns the same object as *navigationController* property.
    override open var baseViewController: UIViewController {
        return tabBarController
    }
    
    /// Overrided property of 'Router' class.
    /// Returns the selected view controller of tab bar controller
    override open var activeViewController: UIViewController? {
        return tabBarController.selectedViewController
    }
    
    /// Creates the tab bar controller that the router manages. You should never call this method directly.
    /// The tab bar router calls method when its tab bar controller is never beeng initialized.
    /// The default implementation of this method creates object of *PresentableTabBarController* class and assigns it to *tabBarController* property.
    /// Override this method to assign custom navigation controller.
    open func loadTabBarController() {
        tabBarController = PresentableTabBarController()
    }
    
    /// Returns first controller with given type from *viewControllers* list of tab bar controller if exists. Otherwise returns nil.
    /// - parameter type: view controller's type to find
    open func viewController<ControllerType: UIViewController>(withType type: ControllerType.Type) -> UIViewController? {
        return tabBarController.viewControllers?.first { $0 is ControllerType }
    }
    
    /// Returns **true** if view controller with given type is found in *viewControllers* list of tab bar controller. Otherwise returns **false**.
    /// - parameter type: view controller type to find
    open func containsViewController<ControllerType: UIViewController>(withType type: ControllerType.Type) -> Bool {
        return (viewController(withType: ControllerType.self) != nil)
    }
    
    /// Select view controller with given type. Throws assert if view controller with given type is not found.
    /// - parameter type: view controller's type to find
    open func selectViewController<ControllerType: UIViewController>(withType type: ControllerType.Type) {
        guard let viewController = viewController(withType: ControllerType.self) else {
            assertionFailure("ViperBase.TabRouter.selectViewController(withRouterType:)\n" +
                "Could not find view controller with type <\(type)>")
            return
        }

        tabBarController.selectedViewController = viewController
    }
    
    /// Select base view controller of router with given type.
    /// Throws assert if either router with given type is not found or router's controller is not child controller of tab bar controller.
    /// - parameter type: view controller's type to find
    open func selectViewController<RouterType: Router>(withRouterType type: RouterType.Type) {
        guard let router = childRouter(withType: RouterType.self) else {
            assertionFailure("ViperBase.TabRouter.selectViewController(withRouterType:)\n" +
                "Could not find router with type <\(type)>")
            return
        }
        
        guard (tabBarController.viewControllers?.contains(router.baseViewController) ?? false) else {
            assertionFailure("ViperBase.TabRouter.selectViewController(withRouterType:)\n" +
                "Tab bar controller does not contain router's base view controller")
            return
        }

        tabBarController.selectedViewController = router.baseViewController
    }
}
