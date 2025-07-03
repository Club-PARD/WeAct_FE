//
//  UserModel.swift
//  WeAct
//
//  Created by 주현아 on 7/1/25.
//

import Foundation
import SwiftUI

class UserModel: ObservableObject {
    @Published var username: String = "이주원"
    @Published var profileImage: UIImage? = nil
}
