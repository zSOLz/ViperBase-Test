//
//  UserProfileInteractor.swift
//  ViperBase-Sample
//
//  Created by SOL on 08.05.17.
//  Copyright © 2017 SOL. All rights reserved.
//

import ViperBase

final class UserProfileInteractor: Interactor {
    fileprivate let userDataSession: UserDataSession
    
    init(userDataSession: UserDataSession) {
        self.userDataSession = userDataSession
    }
}

// MARK: - UserProfileInteractorInterface
extension UserProfileInteractor: UserProfileInteractorInterface {
    var isUserAuthenticated: Bool {
        return (userDataSession.profile != nil && userDataSession.authenticationToken != nil)
    }
    
    var username: String {
        return userDataSession.profile?.username ?? ""
    }
    
    var email: String {
        return userDataSession.profile?.email ?? ""
    }
    
    func logoutUser() {
        userDataSession.authenticationToken = nil
        userDataSession.profile = nil
    }
}
