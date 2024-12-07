//
//  EBiddyViewModel.swift
//  EBuddy
//
//  Created by Vincent on 04/12/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class EBuddyViewModel: ObservableObject {
    @Published var users: [UserJSON]? = nil
    
    private let user = Auth.auth().currentUser
    private let db = Firestore.firestore()
    
    func fetchData(completion: @escaping () -> Void) {
        db.collection("USERS").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No data")
                return
            }
            
            self.users = documents.map { queryDocumentSnapshot -> UserJSON in
                let data = queryDocumentSnapshot.data()
                let uid = data["uid"] as? String ?? ""
                let gender = data["ge"] as? Int ?? 0
                let profilePic = data["profilePic"] as? String ?? ""
                
                return UserJSON(uid: uid, email: "test@gmail.com", phoneNumber: "+628581234567", gender: gender == 0 ? .female : .male, profilePic: profilePic)
            }
            completion()
        }
    }
    
    func uploadImage(child: String, image: UIImage, completion: @escaping (_ url: String?) -> Void) {
        if let uploadData = image.jpegData(compressionQuality: 0.1)?.base64EncodedString(options: .lineLength64Characters) {
            let setData = ["profilePic": uploadData]
            db.collection("USERS").document(child).updateData(setData)
        }
    }
}
