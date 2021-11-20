//
//  ContentView.swift
//  SwiftUIChat
//
//  Created by Salma Hassan on 19/11/2021.
//

import SwiftUI

enum LoginCases: String {
	case login = "Login"
	case createAccount = "Create Account"
}

struct RegisterationView: View {
	// MARK: - Variables
	@State var isLoginMode = false
	@State var shouldShowImagePicker: Bool = false
	@State var selectedImage: UIImage?
	private var title: String {
		return isLoginMode ? LoginCases.login.rawValue : LoginCases.createAccount.rawValue
	}
	
	// MARK: - Content
    var body: some View {
		NavigationView {
			ScrollView {
				Picker(selection: $isLoginMode, label: Text("Picker"), content: {
					Text(LoginCases.login.rawValue).tag(true)
					Text(LoginCases.createAccount.rawValue).tag(false)
				})
				.pickerStyle(SegmentedPickerStyle())
				.padding()
				
				FormView(isLoginMode: $isLoginMode,
						 selectedImage: $selectedImage,
						 shouldShowImagePicker: $shouldShowImagePicker)
			}
			.navigationTitle(title)
			.background(Color(white: 0, opacity: 0.05)
							.ignoresSafeArea())
		}
		.navigationViewStyle(StackNavigationViewStyle())
		.fullScreenCover(isPresented: $shouldShowImagePicker,
						 onDismiss: nil,
						 content: {
			ImagePicker(image: $selectedImage)
		})
    }
}

struct RegisterationView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterationView()
    }
}
