//
//  CarpoolApplicationApp.swift
//  CarpoolApplication
//
//  Created by Faizan Tanveer on 17/12/2024.
//

import SwiftUI
import Firebase
import GoogleSignIn
import SendbirdSwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      FirebaseApp.configure()
      return true
  }
    @available(iOS 9.0, *)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = GIDSignIn.sharedInstance.handle(url)
    return handled
    
    }
}
@main
struct CarpoolApplicationApp: App {
    init() {
        setupSendbird()
        setupCurrentUser()
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                Login()
            }
        }
    }
}
    private extension CarpoolApplicationApp {
        func setupSendbird() {
            let APP_ID = "4F8EDC2B-53F8-495E-9669-8D73A9008801"    // Specify your Sendbird application ID.
            
            SendbirdUI.initialize(
                applicationId: APP_ID
            ) { params in
                // This is the builder block where you can modify the initParameter.
                //
                // [example]
                // params.needsSynchronous = false
            } startHandler: {
                // Initialization of SendbirdSwiftUI has started.
                // We recommend showing a loading indicator once started.
            } migrationHandler: {
                // DB migration has started.
            } completionHandler: { error in
                // If DB migration is successful, proceed to the next step.
                // If DB migration fails, an error exists.
                // We recommend hiding the loading indicator once done.
            }
        }
        
        func setupCurrentUser() {
            // Set current user.
            SBUGlobals.currentUser = SBUUser(userId: "USER_ID")
            SBUGlobals.accessToken = "ACCESS_TOKEN"
        }
    }
