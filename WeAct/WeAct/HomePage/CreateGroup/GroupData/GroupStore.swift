//
//  GroupStore.swift
//  WeAct
//
//  Created by 최승아 on 7/1/25.
//

import SwiftUI

class GroupStore: ObservableObject {
    @Published var groups: [GroupModel] = []
    
    func addGroup(_ group: GroupModel) {
        groups.append(group)
    }
}
