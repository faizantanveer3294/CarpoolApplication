//
//  HomeScreen.swift
//  CarpoolApplication
//
//  Created by Faizan Tanveer on 17/12/2024.
//

//import SwiftUI
//import FirebaseFirestore
//import FirebaseAuth
//
//struct HomeScreen: View {
//    @State private var users = [User]()
//    @State private var currentUserID: String? = nil
//    private var db = Firestore.firestore()
//
//    var body: some View {
//        NavigationStack {
//            List(users) { user in
//                NavigationLink(destination: ChatingScreen(selectedUserID: user.id ?? "", selectedUserName: user.name)) {
//                    VStack(alignment: .leading) {
//                        Text(user.name)
//                            .font(.headline)
//                    }
//                }
//            }
//            .onAppear {
//                fetchCurrentUser()
//                fetchUsers()
//            }
//            .navigationTitle("Users")
//        }
//    }
//
//    func fetchCurrentUser() {
//        if let currentUser = Auth.auth().currentUser {
//            currentUserID = currentUser.uid
//        }
//    }
//
//    func fetchUsers() {
//        db.collection("users")
//            .getDocuments { snapshot, error in
//                if let error = error {
//                    print("Error fetching users: \(error.localizedDescription)")
//                    return
//                }
//                users = snapshot?.documents.compactMap { document in
//                    let user = try? document.data(as: User.self)
//                    if let user = user, user.id != currentUserID {
//                        return user
//                    }
//                    return nil
//                } ?? []
//            }
//    }
//}
//
//struct User: Identifiable, Decodable {
//    @DocumentID var id: String?
//    var name: String
//    var email: String
//}
//
//#Preview {
//    HomeScreen()
//}
import SwiftUI
import FirebaseFirestore
import FirebaseAuth
import SendbirdSwiftUI

struct HomeScreen: View {
    
    
    var body: some View {
        
        GroupChannelListView()
    }
    
}

#Preview {
    HomeScreen()
}
