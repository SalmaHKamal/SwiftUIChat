//
//  FirebaseManager.swift
//  SwiftUIChat
//
//  Created by Salma Hassan on 20/11/2021.
//

import UIKit
import Firebase

class FirebaseManager {
	static let shared = FirebaseManager()
	let auth: Auth
	let storage: Storage
	
	init() {
		FirebaseApp.configure()
		auth = Auth.auth()
		storage = Storage.storage()
	}
}

// MARK: - Authentication
extension FirebaseManager {
	func createAccount(with email: String,
					   and password: String,
					   profileImage: UIImage?,
					   completion: @escaping (String) -> Void) {
		auth.createUser(withEmail: email, password: password) { [weak self] (result, error) in
			if let error = error {
				completion("Failed to Create Account with \(error)")
				return
			}
			completion("Account Created Successfully with uid \(result?.user.uid ?? "")")
			guard let profileImage = profileImage else {
				return
			}
			self?.uploadProfileImage(image: profileImage, completion: { message in
				completion(message)
			})
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

// MARK: - Helper Methods
extension FirebaseManager {
	private func getCurrentUserID() -> String? {
		return auth.currentUser?.uid
	}
	
	private func uploadProfileImage(image: UIImage, completion: @escaping (String) -> Void) {
		guard let uid = getCurrentUserID() else { return }
		let reference = storage.reference(withPath: uid)
		guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
		reference.putData(imageData, metadata: nil) { (result, error) in
			if let error = error {
				completion("Failed to upload image with \(error)")
				return
			}
			reference.downloadURL { (url, error) in
				if let error = error {
					completion("Failed to get photo download url with error: \(error)")
				}
				completion("Photo uploaded successfully with url: \(url?.absoluteString ?? "")")
			}
		}
	}
}
