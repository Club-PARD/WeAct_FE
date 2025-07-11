//
//  NavigationDestination.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import Foundation

enum NavigationDestination: Hashable {
    case createGroup
    case addPartner
    case groupBoard(GroupModel)
    case notification
    case myPage
    case nameEdit // myPage -> nameEdit
    case certification(roomId: Int)
    case setuphabit(roomId: Int)
}
