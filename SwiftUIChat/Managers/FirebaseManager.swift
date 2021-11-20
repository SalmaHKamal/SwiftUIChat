//
//  FirebaseManager.swift
//  SwiftUIChat
//
//  Created by Salma Hassan on 20/11/2021.
//

import Foundation
import Firebase

class FirebaseManager {
	static let shared = FirebaseManager()
	let auth: Auth
	
	init() {
		FirebaseApp.configure()
		auth = Auth.auth()
	}
}

// MARK: - Authentication
extension FirebaseManager {
	func createAccount(with email: String, and password: String, completion: @escaping (String) -> Void) {
		auth.createUser(withEmail: email, password: password) { (result, error) in
			if let error = error {
				completion("Failed to Create Account with \(error)")
				return
			}
			completion("Account Created Successfully with uid \(result?.user.uid ?? "")")
		}
	}
	
	func login(with email: String, and password: String, completion: @escaping (String) -> Void) {
		auth.signIn(withEmail: email, password: password) { (result, error) in
			if let error = error {
				completion("Failed to Login with \(error)")
				return
			}
			completion("LoggedIn Successfully with uid \(result?.user.uid ?? "")")
		}
	}
}
