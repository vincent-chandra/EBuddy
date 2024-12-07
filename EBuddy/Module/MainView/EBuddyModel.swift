//
//  EBuddyModel.swift
//  EBuddy
//
//  Created by Vincent on 04/12/24.
//

import Foundation

struct UserJSON: Codable {
    let uid: String?
    let email: String?
    let phoneNumber: String?
    let gender: GenderEnum
    let profilePic: String?
    
    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case gender = "ge"
        case phoneNumber
        case profilePic
    }
}

enum GenderEnum: Codable {
    case female
    case male
    
    var value: Int {
        switch self {
        case .female:
            return 0
        case .male:
            return 1
        }
    }
}
