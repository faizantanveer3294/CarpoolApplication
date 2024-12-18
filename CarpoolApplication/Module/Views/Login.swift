//
//  Login.swift
//  CarpoolApplication
//
//  Created by Faizan Tanveer on 17/12/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

struct Login: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var isLoggedIn: Bool = false
    @State private var showPhoneVerificationSheet = false

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 150)
                    
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .padding(.horizontal)
                    
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    Button(action: {
                        loginUser(email: email, password: password)
                    }) {
                        Text("Login")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel) { }
                    }
                    HStack {
                        Button(action: {
                            signInWithGmail()
                        }) {
                            HStack {
                                Image("Google-Icon")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 8)
                            }
                            .padding()
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        Button(action: {
                            showPhoneVerificationSheet = true
                        }) {
                            HStack {
                                Image("Phone-Icon")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(.trailing, 8)
                            }
                            .padding()
                            .cornerRadius(10)
                            .padding(.horizontal)
                        }
                        .sheet(isPresented: $showPhoneVerificationSheet) {
                            PhoneVerificationSheet()
                        }
                    }
                    Spacer()
                    
                    NavigationLink(destination: SignupView()) {
                        Text("Don't Have an Account? Sign Up")
                            .font(.system(size: 15))
                            .bold()
                            .padding(.top)
                    }
                    
                }
                .padding()
                
                NavigationLink(
                    destination: HomeScreen(),
                    isActive: $isLoggedIn,
                    label: { EmptyView() }
                )
            }
        } else {
            
        }
    }
    
    // Login Function with Email Verification Check
    private func loginUser(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = "Login failed: \(error.localizedDescription)"
                showAlert = true
            } else if let user = result?.user {
                if user.isEmailVerified {
                    // Navigate to the home screen or show a success message
                    isLoggedIn = true
                } else {
                    alertMessage = "Please verify your email before logging in."
                    showAlert = true
                }
            }
        }
    }
    private func signInWithGmail(){
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
          guard error == nil else {
            return
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            return
          }

          let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

            Auth.auth().signIn(with: credential) { result,error in
                guard error == nil else {
                    return
                }
                isLoggedIn = true  // Set to true after successful Google login
            }
        }
    }
}
