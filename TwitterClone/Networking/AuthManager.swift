//
//  AuthManager.swift
//  TwitterClone
//
//  Created by RUMEN GUIN on 30/03/23.
//

import Foundation
import Firebase
import FirebaseAuthCombineSwift
import Combine

//Singleton Class -> Only one instance of this class is going to be located inside our memory
final class AuthManager {
    
    //static means only this instance is going to found one time in mobile's memory
    static let shared = AuthManager()
    
    func registerUser(with email: String, and password: String) -> AnyPublisher<User, Error> {
        
        
        return Auth.auth().createUser(withEmail: email, password: password)
            .map(\.user)
            .eraseToAnyPublisher()
    }
    
}
