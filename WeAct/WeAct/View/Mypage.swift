//
//  Mypage.swift
//  WeAct
//
//  Created by 주현아 on 6/30/25.
//

import SwiftUI

struct Mypage: View {
    var body: some View {
        ZStack {
            VStack{
                HStack(alignment: .center, spacing: 116) {
                    Image("Icon")
                      .frame(width: 8.90909, height: 17.81818)
                      .overlay(
                        Rectangle()
                          .stroke(Color(red: 0.53, green: 0.57, blue: 0.64), lineWidth: 2.9697)
                      )
                    
                    Text("마이페이지")
                        .font(
                            Font.custom("Pretendard", size: 18)
                                .weight(.medium)
                        )
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                }//HStack
                .padding(.horizontal, 24)
                .padding(.vertical, 15)
                .frame(width: 374, alignment: .leading)
                
                
                
                ZStack{
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 100, height: 100)
                      .background(Color(red: 0.93, green: 0.95, blue: 0.96))
                      .cornerRadius(20)
                    
                    Text("프로필\n사진")
                      .font(
                        Font.custom("Pretendard", size: 16)
                          .weight(.medium)
                      )
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                } //ZStack
                
                Text("이주원")
                  .font(
                    Font.custom("Pretendard", size: 22)
                      .weight(.medium)
                  )
                  .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                
                HStack{
                    HStack(alignment: .center, spacing: 8) {
                        Text("프로필 사진 변경")
                          .font(
                            Font.custom("Pretendard", size: 16)
                              .weight(.medium)
                          )
                          .foregroundColor(.white)
                    }
                    .padding(.horizontal, 44)
                    .padding(.vertical, 5)
                    .frame(width: 144, height: 42, alignment: .center)
                    .background(Color(red: 0.7, green: 0.74, blue: 0.78))
                    .cornerRadius(6)
                    
                    HStack(alignment: .center, spacing: 8) {
                        Text("이름 변경")
                          .font(
                            Font.custom("Pretendard", size: 16)
                              .weight(.medium)
                          )
                          .foregroundColor(.white)
                    }
                    .padding(.horizontal, 44)
                    .padding(.vertical, 5)
                    .frame(width: 144, height: 42, alignment: .center)
                    .background(Color(red: 0.7, green: 0.74, blue: 0.78))
                    .cornerRadius(6)
                }//HStack
              
                //경계바
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 375, height: 8)
                  .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                
                Text("내 습관 기록")
                  .font(
                    Font.custom("Pretendard", size: 16)
                      .weight(.medium)
                  )
                  .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                
                Text("로그아웃")
                  .font(
                    Font.custom("Pretendard", size: 16)
                      .weight(.medium)
                  )
                  .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                
                Text("회원 탈퇴")
                  .font(
                    Font.custom("Pretendard", size: 16)
                      .weight(.medium)
                  )
                  .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
             

            }//VStack
        }
        .frame(width: 375, height: 812)
        .background(.white)
    }
}

#Preview {
    Mypage()
    
}
