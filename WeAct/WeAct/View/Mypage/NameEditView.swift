//
//  Mypage.swift
//  WeAct
//
//  Created by 주현아 on 6/30/25.
//

import SwiftUI

struct NameEditView: View {
    var body: some View {
        VStack{
            Text("이름 변경")
                .font(Font.custom("Pretendard", size: 18).weight(.medium))
                .foregroundColor(.black)
                .frame(height: 44)
                .padding(.top, 5)
                .padding(.bottom, 44)
            
            VStack(alignment: .leading){
                Text("이름")
                    .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                
                ZStack(alignment: .leading){
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 330, height: 56)
                        .background(Color(red: 0.93, green: 0.95, blue: 0.96))
                        .cornerRadius(4)
                    
                    Text(username)
                        .padding(.leading, 10)
                }
            }
            Spacer()
            
            
            
            Button(action: {
                // 여기에 사진 변경 로직
            }) {
                Text("저장하기")
                    .font(
                      Font.custom("Pretendard", size: 16)
                        .weight(.medium)
                      )
                    .foregroundColor(.white)
            }
            .font(Font.custom("Pretendard", size: 16).weight(.medium))
                   .foregroundColor(.white)
                   .frame(width: 330, height: 56)
                   .background(Color(red: 0.37, green: 0.4, blue: 0.43))
                   .cornerRadius(4)
            
            
        }
        Spacer()
    }
}

#Preview {
    NameEditView()
    
}
