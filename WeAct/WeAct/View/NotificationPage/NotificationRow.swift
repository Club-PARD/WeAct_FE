

import SwiftUI

struct NotificationRow: View {
    var content: String
    var title: String
    
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
}

#Preview {
    NotificationRow(content:"이주원님이 보낸 그룹 초대",title:"롱커톤 모여라")
}

