//
//  RegistrationEmailViewInterface.swift
//  ViperBase-Sample
//
//  Created by SOL on 08.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import ViperBase

protocol RegistrationEmailViewInterface: ViewInterface {
    func setup(email: String)
    func setContinueButton(enabled isEnabled: Bool)
}
