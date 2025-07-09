//
//  TestingPage.swift
//  WeAct
//
//  Created by 현승훈 on 7/8/25.
//

import SwiftUI

struct TestingPage: View {
    @State private var showMaxView = false
    @State private var showPassCard = false

    var body: some View {
        ZStack {
            Color(hex: "F7F7F7").ignoresSafeArea()
            
            VStack{
                
                
                
                
                HStack(spacing: 16) {
                    CertificationCard(userName: "이주원")
                        .rotationEffect(.degrees(-4))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showMaxView = true
                            }
                        }
                    
                    PassCard()
                        .rotationEffect(.degrees(4))
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showPassCard = true
                            }
                        }
                }
                
                // ✅ 인증 카드 최대 확대 뷰
                if showMaxView {
                    CerificationMax(isPresented: $showMaxView)
                        .transition(.opacity)
                        .zIndex(1)
                }
                
                // ✅ 패스 카드 최대 확대 뷰
                if showPassCard {
                    PassCardMax(isPresented: $showPassCard)
                        .transition(.opacity)
                        .zIndex(1)
                }
            }
        }
    }
}

#Preview {
    TestingPage()
}
