//
//  FormView.swift
//  SwiftUIChat
//
//  Created by Salma Hassan on 19/11/2021.
//

import SwiftUI

struct FormView: View {
	// MARK: - Variables
	@Binding var isLoginMode: Bool
	@State private var email = ""
	@State private var password = ""
	private var buttonTitle: String {
		return isLoginMode ? LoginCases.login.rawValue : LoginCases.createAccount.rawValue
	}
	@State private var loginResponse = ""
	@Binding var selectedImage: UIImage?
	@Binding var shouldShowImagePicker: Bool
	
	// MARK: - Content
	var body: some View {
		VStack(spacing: 16) {
			if !isLoginMode {
				Button(action: uploadPhoto, label: {
					VStack {
						if let selectedImage = self.selectedImage {
							Image(uiImage: selectedImage)
								.resizable()
								.frame(width: 128, height: 128)
								.scaledToFill()
								.cornerRadius(64)
						} else {
							Image(systemName: "person.fill")
								.font(.system(size: 64))
								.padding()
								.foregroundColor(Color(.label))
						}
					}
					.overlay(RoundedRectangle(cornerRadius: 64)
								.stroke(Color.black, lineWidth: 3))
				})
			}
			
			Group {
				TextField("Email", text: $email)
					.keyboardType(.emailAddress)
					.autocapitalization(.none)
				SecureField("Password", text: $password)
			}
			.padding(12)
			.background(Color(.white))
			
			Button(action: actionButtonPressed, label: {
				HStack {
					Spacer()
					Text(buttonTitle)
						.foregroundColor(.white)
						.padding(.vertical, 10)
					Spacer()
				}.background(Color.blue)
			})
			
			Text(loginResponse)
				.foregroundColor(.red)
		}
		.padding()
	}
	
	private func uploadPhoto() {
		shouldShowImagePicker.toggle()
	}
	
	private func actionButtonPressed() {
		if isLoginMode {
			FirebaseManager.shared.login(with: email, and: password, completion: { message in
				loginResponse = message
			})
		} else {
			FirebaseManager.shared.createAccount(with: email,
												 and: password,
												 profileImage: selectedImage) { message in
				loginResponse = message
			}
		}
	}
}

struct FormView_Previews: PreviewProvider {
	static var previews: some View {
		FormView(isLoginMode: .constant(false),
				 selectedImage: .constant(nil),
				 shouldShowImagePicker: .constant(false))
	}
}
