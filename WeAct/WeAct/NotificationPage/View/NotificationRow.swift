

import SwiftUI

enum NotificationType {
    case groupInvite(sender: String, groupName: String)
    case memberNoVerification(sender: String, groupName: String)
    case forcedOut(sender: String, groupName: String)
    case postConfirm(sender: String, groupName: String)
}

struct NotificationRow: View {
    let model: NotificationModel
    var onAccept: () -> Void = {}
    var onReject: () -> Void
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5){
                Text(model.message)
                    .font(.custom("Pretendard-Medium", size: 16))
                    .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
                Text(model.roomName)
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.53))
            }
            Spacer()
            
            if model.type == "INVITE" {
                Button("수락", action: onAccept)
                    .font(.custom("Pretendard-Medium", size: 14))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .foregroundColor(Color(red: 0.2, green: 0.44, blue: 0.87)) // 진한 파랑
                    .background(Color(red: 0.9, green: 0.95, blue: 1.0)) // 연파랑 배경
                    .cornerRadius(8)
                
                Button("거절", action: onReject)
                    .font(.custom("Pretendard-Medium", size: 14))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .foregroundColor(.red)
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal)
    }
}
