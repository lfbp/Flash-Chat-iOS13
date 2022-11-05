//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by lpereira on 26/09/22.
//  Copyright © 2022 Angela Yu. All rights reserved.
//

import Foundation

struct Constants {
    static let appName = "⚡️ Flash Chat"
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToApp"
    static let loginSegue = "LoginToApp"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
