//
//  RegistrationAssembly.swift
//  ViperBase-Sample
//
//  Created by SOL on 09.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import ViperBase

final class RegistrationAssembly: Assembly {
    fileprivate let userDataSession: UserDataSession
    fileprivate let registrationDataSession = UserRegistrationDataSession()
    fileprivate weak var innerRegistrationRouter: RegistrationRouter?
    
    func registrationRouter() -> RegistrationRouter {
        if let registrationRouter = innerRegistrationRouter {
            return registrationRouter
        } else {
            let registrationRouter = RegistrationRouter(registrationAssembly: self)
            innerRegistrationRouter = registrationRouter
            return registrationRouter
        }
    }

    init(userDataSession: UserDataSession) {
        self.userDataSession = userDataSession
    }
}

// MARK: - Fileprivate
fileprivate extension RegistrationAssembly {
    func registrationInteractor() -> RegistrationInteractorInterface {
        let dataManager = UserRegistrationDataManager()
        let interactor = RegistrationInteractor(userRegistrationDataSession: registrationDataSession,
                                                userDataSession: userDataSession,
                                                registrationDataManager: dataManager)
        return interactor
    }
}

// MARK: - RegistrationAssemblyInterface
extension RegistrationAssembly: RegistrationAssemblyInterface {
    func emailViewController() -> RegistrationEmailViewController {
        let presenter = RegistrationEmailPresenter(router: registrationRouter(), registrationInteractor: registrationInteractor())
        let view = RegistrationEmailViewController()
        
        view.presenterInterface = presenter
        
        return view
    }
    
    func credentialsViewController() -> RegistrationCredentialsViewController {
        let presenter = RegistrationCredentialsPresenter(router: registrationRouter(), registrationInteractor: registrationInteractor())
        let view = RegistrationCredentialsViewController()
        
        view.presenterInterface = presenter
        
        return view
    }
}
