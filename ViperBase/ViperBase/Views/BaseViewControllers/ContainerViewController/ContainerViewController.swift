//
//  ContainerController.swift
//  ViperBase
//
//  Created by SOL on 28.04.17.
//  Copyright © 2017 SOL. All rights reserved.
//

/**
 Container class can display content represented by single view controller.
 It supports dynamic and animated switching between different content controllers
 */
open class ContainerViewController: PresentableViewController {
    fileprivate var innerContainerView: UIView?
    
    /// The view controller that is contained in this container controller
    @IBOutlet fileprivate(set) open var contentViewController: UIViewController?
    
    /// The view that will be a superview for content view controller's view
    @IBOutlet open var containerView: UIView! {
        get {
            if !isViewLoaded {
                if #available(iOS 9.0, *) {
                    loadViewIfNeeded()
                } else {
                    // Load view in 'brute' way
                    let _ = view
                }
            }
            
            return innerContainerView ?? view
        }
        set(newView) {
            innerContainerView = newView
        }
    }
    
    /// Method creates and returns default transition context to implement animation between old and new content view controller.
    /// Override it to use your custom transition context. It wouldn't be deallocated until animation has ended.
    /// - parameter containerView: will be a container view for future animation
    /// - parameter fromViewController: view controller that will be hidden
    /// - parameter toViewController: view controller that should be shown
    open func transitionContext(containerView: UIView,
                                from fromViewController: UIViewController? = nil,
                                to toViewController: UIViewController? = nil) -> ContainerViewControllerTransitionContext {
        return ContainerViewControllerTransitionContext(containerView: containerView,
                                                        from: fromViewController,
                                                        to: toViewController)
    }
    
    /// Set new child content view controller and add it's view as a subview to container view. The action can be animated.
    /// - parameter toViewController: view controller that will be set as content
    /// - parameter animator: represents animation logic that will be executed during transition between currently presented view controller and the new one.
    /// If this parameter is nil the change between controller will be immediate.
    open func setContentViewController(_ toViewController: UIViewController?, animator: UIViewControllerAnimatedTransitioning? = nil) {
        if contentViewController != toViewController {
            if let animator = animator {
                let fromViewController = contentViewController
                contentViewController = toViewController
                
                let context = transitionContext(containerView: containerView,
                                                from: fromViewController,
                                                to: toViewController)
                
                fromViewController?.willMove(toParentViewController: nil)
                toViewController?.willMove(toParentViewController: self)
                if let toViewController = toViewController {
                    containerView.addSubview(toViewController.view)
                }
                
                animator.animateTransition(using: context)
                DispatchQueue.main.asyncAfter(deadline: .now() + animator.transitionDuration(using: context), execute: { [weak self] in
                    if let fromViewController = fromViewController {
                        fromViewController.removeFromParentViewController()
                        fromViewController.view.removeFromSuperview()
                        fromViewController.didMove(toParentViewController: nil)
                    }
                    
                    if let toViewController = toViewController {
                        self?.addChildViewController(toViewController)
                        toViewController.didMove(toParentViewController: self)
                    }
                    
                    animator.animationEnded?(true)
                })
            } else {
                let fromViewController = contentViewController
                contentViewController = toViewController
                
                if let fromViewController = fromViewController {
                    fromViewController.willMove(toParentViewController: nil)
                    fromViewController.removeFromParentViewController()
                    fromViewController.view.removeFromSuperview()
                    fromViewController.didMove(toParentViewController: nil)
                }
                
                if let toViewController = toViewController {
                    toViewController.willMove(toParentViewController: self)
                    addChildViewController(toViewController)
                    
                    containerView.addSubview(toViewController.view)
                    toViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                    toViewController.view.frame = containerView.bounds
                    
                    toViewController.didMove(toParentViewController: self)
                }
            }
        }
    }
}
