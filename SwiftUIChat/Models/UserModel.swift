//
//  UserModel.swift
//  SwiftUIChat
//
//  Created by Salma Hassan on 20/11/2021.
//

import Foundation

struct UserModel: Codable {
	var uid: String?
	var email: String?
	var profileImageUrl: URL?
	
	mutating func update(profileImageUrl: URL) {
		self.profileImageUrl = profileImageUrl
	}
	
	init(uid: String?, email: String?, profileImageUrl: URL?) {
		self.uid = uid
		self.email = email
		self.profileImageUrl = profileImageUrl
	}
	
	init?(dict: [String: Any]) {
		guard let uid = dict["uid"] as? String,
			  let email = dict["email"] as? String,
			  let profileImageUrl = dict["profileImageUrl"] as? URL else {
			return
		}
		self.uid = uid
		self.email = email
		self.profileImageUrl = profileImageUrl
	}
}
