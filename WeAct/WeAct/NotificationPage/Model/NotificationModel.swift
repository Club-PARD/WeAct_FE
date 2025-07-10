//
//  NotificationModel.swift
//  WeAct
//
//  Created by 주현아 on 7/10/25.
//

import SwiftUI
import Foundation

struct NotificationModel: Codable {
    let roomName: String
    let message: String
    let type: String
    let roomId: Int
}
