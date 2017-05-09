//
//  RegistrationAssemblyInterface.swift
//  ViperBase-Sample
//
//  Created by SOL on 09.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import ViperBase

protocol RegistrationAssemblyInterface: AssemblyInterface {
    func emailViewController() -> RegistrationEmailViewController
    func credentialsViewController() -> RegistrationCredentialsViewController
}
