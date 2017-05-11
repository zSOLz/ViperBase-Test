//
//  ContainerRouterTest.swift
//  ViperBaseTests
//
//  Created by SOL on 02.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import XCTest
@testable import ViperBase

fileprivate class OneViewController: UIViewController { }
fileprivate class AnotherViewController: UIViewController { }
fileprivate class CustomContainerViewController: ContainerViewController { }

fileprivate class ContainerRouterSubcassMock: ContainerRouter {
    var isLoadContainerViewControllerCalled = false
    
    override fileprivate func loadContainerViewController() {
        isLoadContainerViewControllerCalled = true
        
        super.loadContainerViewController()
    }
}

class ContainerRouterTests: XCTestCase {
    func testDefaultLoad() {
        let containerRouter = ContainerRouter()
        
        XCTAssertNotNil(containerRouter.containerViewController)
        XCTAssertNil(containerRouter.activeViewController)
        XCTAssertNil(containerRouter.contentRouter)
    }
    
    func testBaseViewControllerMethod() {
        let containerRouter = ContainerRouter()
        let customContainerViewController = CustomContainerViewController()
        
        containerRouter.containerViewController = customContainerViewController
        XCTAssertEqual(containerRouter.containerViewController, customContainerViewController)
        XCTAssertEqual(containerRouter.baseViewController, customContainerViewController)
    }
    
    func testActiveViewControllerMethod() {
        let containerRouter = ContainerRouter()
        let oneViewController = OneViewController()
        let anotherViewController = AnotherViewController()
        
        containerRouter.containerViewController.setViewController(oneViewController)
        XCTAssertEqual(containerRouter.activeViewController, oneViewController)
        
        containerRouter.containerViewController.setViewController(anotherViewController, animator: nil)
        XCTAssertEqual(containerRouter.activeViewController, anotherViewController)
    }

    func testLoadContainerViewControllerMethod() {
        let router1 = ContainerRouterSubcassMock()
        let _ = router1.containerViewController
        XCTAssertTrue(router1.isLoadContainerViewControllerCalled)
        
        let router2 = ContainerRouterSubcassMock()
        router2.containerViewController = CustomContainerViewController()
        let _ = router2.containerViewController
        XCTAssertFalse(router2.isLoadContainerViewControllerCalled)
    }
    
    func testContentRouterMethod() {
        let containerRouter = ContainerRouter()
        let childViewController1 = UIViewController()
        let childViewController2 = UIViewController()
        let childViewController3 = UIViewController()
        let childRouter1 = RouterSubclassMock()
        let childRouter2 = RouterSubclassMock()
        let childRouter3 = RouterSubclassMock()
        
        childRouter1.getBaseViewControllerClosure = {
            return childViewController1
        }
        childRouter2.getBaseViewControllerClosure = {
            return childViewController2
        }
        childRouter3.getBaseViewControllerClosure = {
            return childViewController3
        }

        containerRouter.contentRouter = childRouter1
        XCTAssertEqual(containerRouter.childRouters, [childRouter1])
        XCTAssertEqual(containerRouter.activeViewController, childViewController1)

        containerRouter.contentRouter = childRouter2
        XCTAssertEqual(containerRouter.childRouters, [childRouter2])
        XCTAssertEqual(containerRouter.activeViewController, childViewController2)
        
        containerRouter.contentRouter = nil
        XCTAssertEqual(containerRouter.childRouters, [])
        XCTAssertNil(containerRouter.activeViewController)
        
        containerRouter.addChild(router: childRouter1)
        containerRouter.addChild(router: childRouter2)
        containerRouter.contentRouter = childRouter3
        
        XCTAssertEqual(containerRouter.childRouters, [childRouter3])
        XCTAssertEqual(containerRouter.activeViewController, childViewController3)
    }
}
