//
//  FormView.swift
//  SwiftUIChat
//
//  Created by Salma Hassan on 19/11/2021.
//

import SwiftUI

struct FormView: View {
	@Binding var isLoginMode: Bool
	@State private var email = ""
	@State private var password = ""
	private var buttonTitle: String {
		return isLoginMode ? LoginCases.login.rawValue : LoginCases.createAccount.rawValue
	}
	
	var body: some View {
		VStack(spacing: 16) {
			if !isLoginMode {
				Button(action: uploadPhoto, label: {
					Image(systemName: "person.fill")
						.font(.system(size: 64))
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
		}
		.padding()
	}
	
	private func uploadPhoto() {
		print("upload photo")
	}
	
	private func actionButtonPressed() {
		if isLoginMode {
			print("Login")
		} else {
			print("create account")
		}
	}
}

struct FormView_Previews: PreviewProvider {
	static var previews: some View {
		FormView(isLoginMode: .constant(false))
	}
}
