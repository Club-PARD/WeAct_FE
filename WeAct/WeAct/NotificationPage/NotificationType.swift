//
//  NotificationType.swift
//  WeAct
//
//  Created by 주현아 on 7/1/25.
//

import SwiftUI



enum NotificationType: Identifiable {

    case groupInvite(sender: String, groupName: String)
    case memberNoVerification(sender: String, groupName: String)
    
    var id: String {
       switch self {
       case let .groupInvite(sender, groupName):
           return "invite-\(sender)-\(groupName)"
       case let .memberNoVerification(sender, groupName):
           return "verify-\(sender)-\(groupName)"
       }
   }
}
