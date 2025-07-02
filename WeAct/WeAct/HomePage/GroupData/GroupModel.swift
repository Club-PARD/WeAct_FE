//
//  GroupModel.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct GroupModel: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let period: String
    let reward: String
    let partners: [String]
    let selectedDaysString: [String]
    let selectedDaysCount: Int
}
