

import SwiftUI

enum NotificationType {
    case groupInvite
    case verificationRejected
    case memberNoVerification
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let type: NotificationType
    let senderName: String
    let title: String?       // 그룹명, 부가 설명 등
    let reason: String?      // 거절 사유
    let image: UIImage?      // 거절 이미지
}

struct NotificationRow: View {
    var content: String
    var title: String
    var item: NotificationItem
    
    var body: some View {

            HStack {
                VStack(alignment: .leading, spacing: 5){
                    Text(content)
                        .font(.custom("Pretendard", size: 16))
                        .foregroundColor(Color(red: 0.33, green: 0.37, blue: 0.42))
                    
                    
                    Text(title)
                        .font(.custom("Pretendard", size: 14))
                        .foregroundColor(Color(red: 0.76, green: 0.8, blue: 0.86))
                    
            
                }//VStack

                Spacer()
                
                Button(action: {
                    // 여기에 액션 로직
                }) {
                    Image(systemName: "checkmark")
                }
                    .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                   .frame(width: 43, height: 43)
                   .background(Color(red: 0.9, green: 0.93, blue: 0.96))
                   .cornerRadius(50)
                
                Button(action: {
                    // 여기에 액션 로직
                }) {
                    Image(systemName: "xmark")
                }
                    .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                   .frame(width: 43, height: 43)
                   .background(Color(red: 0.9, green: 0.93, blue: 0.96))
                   .cornerRadius(50)
              
                
            } //HStack
            .padding(.horizontal)

    }
    
    var mainText: String {
           switch item.type {
           case .groupInvite:
               return "\(item.senderName)님이 보낸 그룹 초대"
           case .verificationRejected:
               return "\(item.senderName)의 인증이 거절되었어요"
           case .memberNoVerification:
               return "\(item.senderName)가 오늘 인증하지 않았어요"
           }
       }

       var subtitle: String? {
           return item.title
       }
}



//그룹 초대 알림 : 수락, 거절
//다른 멤버의 미인증 알림
//내 인증에 대한 거절 알림 : 사진


//
//#Preview {
//    NotificationRow(content:"이주원님이 보낸 그룹 초대",title:"롱커톤 모여라")
//}
//
