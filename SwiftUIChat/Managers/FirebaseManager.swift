//
//  FirebaseManager.swift
//  SwiftUIChat
//
//  Created by Salma Hassan on 20/11/2021.
//

import UIKit
import Firebase
import FirebaseFirestore

class FirebaseManager {
	private enum Collections: String {
		case users = "users"
	}
	static let shared = FirebaseManager()
	let auth: Auth
	let storage: Storage
	let firestore: Firestore
	
	init() {
		FirebaseApp.configure()
		auth = Auth.auth()
		storage = Storage.storage()
		firestore = Firestore.firestore()
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
			self?.uploadProfileImage(for: result?.user.uid,
									 email: email,
									 with: profileImage, completion: { message in
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
	
	private func uploadProfileImage(for uid: String?,
									email: String,
									with image: UIImage, completion: @escaping (String) -> Void) {
		guard let uid = getCurrentUserID() else { return }
		let reference = storage.reference(withPath: uid)
		guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
		reference.putData(imageData, metadata: nil) { (result, error) in
			if let error = error {
				completion("Failed to upload image with \(error)")
				return
			}
			reference.downloadURL { [weak self] (url, error) in
				if let error = error {
					completion("Failed to get photo download url with error: \(error)")
				}
				completion("Photo uploaded successfully with url: \(url?.absoluteString ?? "")")
				let userModel = UserModel(uid: uid,
										  email: email,
										  profileImageUrl: url)
				self?.saveToFirestore(user: userModel, completion: { message in
					completion(message)
				})
			}
		}
	}
	
	private func saveToFirestore(user: UserModel, completion: @escaping (String) -> Void) {
		guard let uid = getCurrentUserID(),
			  let dict = user.dict else { return }
		firestore.collection(Collections.users.rawValue).document(uid).setData(dict) { (error) in
			if let error = error {
				completion("Failed to save user data to firestore with error : \(error)")
				return
			}
			completion("User info saved successfully in firestore")
		}
	}
}
