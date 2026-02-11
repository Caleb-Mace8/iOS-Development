//
//  SignInViewModel.swift
//  FA_Calendar-Project
//
//  Created by Caleb Mace on 2/6/26.
//


import Observation

@Observable
class SignInViewModel {
    var email: String = ""
    var password: String = ""
    var isPasswordHidden: Bool = true
    
    var user: User? = nil
    
    var error: Error? = nil
    
    var isLoggedIn: Bool = false
    var isLoading: Bool = false
    
    var gotResponse: Bool {
        if user != nil {
            return true
        } else if error != nil {
            return true
        } else {
            return false
        }
    }
    
    func triggerNextScreen() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        if user != nil {
            isLoggedIn = true
        } else {
            error = nil
        }
    }
}
