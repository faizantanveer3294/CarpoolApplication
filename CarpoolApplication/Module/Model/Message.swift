//
//  Message.swift
//  CarpoolApplication
//
//  Created by Faizan Tanveer on 17/12/2024.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

// Message model to represent a single message
struct Message: Identifiable {
    var id: String
    var senderID: String
    var receiverID: String
    var content: String
    var timestamp: Timestamp

    // To map the Firestore data to a Message
    init(id: String = UUID().uuidString, senderID: String, receiverID: String, content: String, timestamp: Timestamp) {
        self.id = id
        self.senderID = senderID
        self.receiverID = receiverID
        self.content = content
        self.timestamp = timestamp
    }
}
