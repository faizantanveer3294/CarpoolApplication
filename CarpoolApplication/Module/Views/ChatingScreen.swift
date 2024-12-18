//
//  ChatingScreen.swift
//  CarpoolApplication
//
//  Created by Faizan Tanveer on 17/12/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct ChatingScreen: View {
    
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    @State private var currentUserID: String = ""
    
    let selectedUserID: String
    let selectedUserName: String
    
    private let db = Firestore.firestore()

    var body: some View {
        VStack {
            // Chat messages display
            ScrollView {
                ForEach(messages) { message in
                    HStack {
                        if message.senderID == currentUserID {
                            Spacer()
                            Text(message.content)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        } else {
                            Text(message.content)
                                .padding()
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(10)
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                    .padding(message.senderID == currentUserID ? .top : .bottom, 5)
                }
            }
            .padding(.top)

            // Input area for new message
            HStack {
                TextField("Type your message...", text: $newMessage)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray))
                
                Button(action: sendMessage) {
                    Text("Send")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(newMessage.isEmpty)
            }
            .padding()
        }
        .navigationTitle("Chat with \(selectedUserName)")
        .onAppear {
            fetchCurrentUser()
            fetchMessages()
        }
    }

    // Fetch the current user's Firebase Auth ID
    func fetchCurrentUser() {
        if let user = Auth.auth().currentUser {
            currentUserID = user.uid
        }
    }
    
    // Listen for new messages in real-time
    func fetchMessages() {
    
        db.collection("messages")
            .whereField("senderID", in: [currentUserID, selectedUserID])
            .whereField("receiverID", in: [currentUserID, selectedUserID])
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching messages: \(error.localizedDescription)")
                    return
                }
                
                // Update the messages array
                messages = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    guard let senderID = data["senderID"] as? String,
                          let receiverID = data["receiverID"] as? String,
                          let content = data["content"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp else {
                        return nil
                    }
                    
                    return Message(
                        id: document.documentID,
                        senderID: senderID,
                        receiverID: receiverID,
                        content: content,
                        timestamp: timestamp
                    )
                } ?? []
            }
    }


    // Function to send a message
    func sendMessage() {
        fetchCurrentUser()
        fetchMessages()
        guard !newMessage.isEmpty else { return }
        let messageData: [String: Any] = [
            "senderID": currentUserID,
            "receiverID": selectedUserID,
            "content": newMessage,
            "timestamp": Timestamp()
        ]
        db.collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
            } else {
                print("Message sent successfully!")
                newMessage = ""
            }
        }
    }
}

#Preview {
    ChatingScreen(selectedUserID: "exampleID", selectedUserName: "User2")
}
