//
//  Mypage.swift
//  WeAct
//
//  Created by 주현아 on 6/30/25.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        
        VStack{
            Text("알림")
                .font(Font.custom("Pretendard", size: 18).weight(.medium))
                .foregroundColor(.black)
                .frame(height: 44)
                .padding(.vertical, 5)

            //경계바
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 375, height: 8)
                .background(Color(red: 0.97, green: 0.97, blue: 0.98))
            
            ScrollView{
                VStack(spacing: 40) {
//                    NotificationRow(content:"이주원님이 보낸 그룹 초대",title:"롱커톤 모여라")
//                    NotificationRow(content:"주현아님이 보낸 그룹 초대",title:"숏커톤 모여라")
//            
//                    NotificationRow(content:"이주원님의 인증이 거절되었어요",title:"아무것도 안보여....")
                }
                .padding(.top, 10)
                .padding(.horizontal, 5)
                
                Spacer()
                
            }//VStack
        }//ScrollView
            .background(Color.white)


    }
}

#Preview {
    NotificationView()
    
}
