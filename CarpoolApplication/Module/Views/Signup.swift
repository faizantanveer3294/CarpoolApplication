//
//  Signup.swift
//  CarpoolApplication
//
//  Created by Faizan Tanveer on 17/12/2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignupView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    // Firestore database reference
    private let db = Firestore.firestore()

    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                VStack(spacing: 20) {
                    Text("Sign Up")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 150)
                    
                    // Name Field
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                        .padding(.horizontal)
                    
                    // Email Field
                    TextField("Email", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .disableAutocorrection(true)
                        .padding(.horizontal)
                    
                    // Password Field
                    SecureField("Password", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Confirm Password Field
                    SecureField("Confirm Password", text: $confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.horizontal)
                    
                    // Signup Button
                    Button(action: {
                        if validateInputs() {
                            signupUser(email: email, password: password, name: name)
                        } else {
                            alertMessage = "Please ensure all fields are filled and passwords match."
                            showAlert = true
                        }
                    }) {
                        Text("Sign Up")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .alert(alertMessage, isPresented: $showAlert) {
                        Button("OK", role: .cancel) {
                            
                        }
                    }
                    
                    Spacer()
                    
                    
                    // NavigationLink to Login Screen
                    NavigationLink(destination: Login()) {
                        Text("Already have an account? Log in")
                            .foregroundColor(.blue)
                            .font(.callout)
                            .padding(.top)
                    }
                }
                .padding()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    // Validate Inputs
    private func validateInputs() -> Bool {
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            return false
        }
        guard password == confirmPassword else {
            return false
        }
        return true
    }
    
    private func signupUser(email: String, password: String, name: String) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                alertMessage = "Signup failed: \(error.localizedDescription)"
                showAlert = true
            } else if let user = result?.user {
                saveUserData(userId: user.uid, name: name, email: email)
                
                // Send verification email
                user.sendEmailVerification { error in
                    if let error = error {
                        alertMessage = "Failed to send verification email: \(error.localizedDescription)"
                        showAlert = true
                    } else {
                        alertMessage = "A verification email has been sent to \(email). Please verify your email to proceed."
                        showAlert = true
                    }
                }
            }
        }
    }

    private func saveUserData(userId: String, name: String, email: String) {
        let userDocument = db.collection("users").document(userId)
        let userData: [String: Any] = [
            "name": name,
            "email": email,
            "userId": userId,
            "createdAt": Timestamp()
        ]
        
        userDocument.setData(userData) { error in
            if let error = error {
                alertMessage = "Failed to save user data: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }

}

#Preview {
    SignupView()
}
