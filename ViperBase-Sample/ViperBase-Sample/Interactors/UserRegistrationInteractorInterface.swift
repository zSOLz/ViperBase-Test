//
//  RegistrationInteractorInterface.swift
//  ViperBase-Sample
//
//  Created by SOL on 08.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import ViperBase

protocol RegistrationInteractorInterface: InteractorInterface {
    func isValidUsername(_ username: String) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func isValidEmail(_ email: String) -> Bool

    var username: String { get set }
    var password: String { get set }
    var email: String { get set }
    
    func registerUser(success: (()->Void)?, failure:((Error)->Void)?)
}
