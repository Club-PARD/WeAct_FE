//
//  NotificationType.swift
//  WeAct
//
//  Created by 주현아 on 7/1/25.
//

import SwiftUI



enum NotificationType: Identifiable {
    var id: UUID { UUID() }

    case groupInvite(sender: String, groupName: String)
    case memberNoVerification(sender: String, groupName: String)
}
