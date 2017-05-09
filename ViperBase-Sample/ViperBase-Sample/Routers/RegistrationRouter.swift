//
//  RegistrationRouter.swift
//  ViperBase-Sample
//
//  Created by SOL on 08.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import ViperBase

final class RegistrationRouter: StackRouter {
    fileprivate let registrationAssembly: RegistrationAssemblyInterface
    
    var completionClosure: (()->())?
    var cancelClosure: (()->())?
    
    init(registrationAssembly: RegistrationAssemblyInterface) {
        self.registrationAssembly = registrationAssembly
    }
    
    override func loadNavigationController() {
        super.loadNavigationController()
        
        navigationController.viewControllers = [registrationAssembly.emailViewController()]
    }
}

// MARK: - RegistrationRouterInterface
extension RegistrationRouter: RegistrationRouterInterface {
    func cancelRegistration() {
        cancelClosure?()
    }

    func completeRegistration() {
        completionClosure?()
    }

    func showCredentialsScreen() {
        navigationController.pushViewController(registrationAssembly.credentialsViewController(), animated: true)
    }
}
