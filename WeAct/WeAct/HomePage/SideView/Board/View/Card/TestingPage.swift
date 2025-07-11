//
//  TestingPage.swift
//  WeAct
//
//  Created by 현승훈 on 7/8/25.
//
//
//import SwiftUI
//
//struct TestingPage: View {
//    @State private var showMaxView = false
//    @State private var showPassCard = false
//
//    var body: some View {
//        ZStack {
//            Color(hex: "F7F7F7").ignoresSafeArea()
//            
//            VStack {
//                HStack(spacing: 25) {
//                    CertificationCard(userName: "이주원", userId:)
//                        .rotationEffect(.degrees(-4))
//                        .onTapGesture {
//                            withAnimation(.easeInOut(duration: 0.3)) {
//                                showMaxView = true
//                            }
//                        }
//                    
//                    PassCard()
//                        .rotationEffect(.degrees(4))
//                        .onTapGesture {
//                            withAnimation(.easeInOut(duration: 0.3)) {
//                                showPassCard = true
//                            }
//                        }
//                    
//                }
//                Spacer().frame(height:30)
//                
//                HStack(spacing: 25) {
//                    
//                    PassCard(userName: "현승훈")
//                        .rotationEffect(.degrees(-4))
//                        .onTapGesture {
//                            withAnimation(.easeInOut(duration: 0.3)) {
//                                showPassCard = true
//                            }
//                        }
//                    
//                    CertificationCard(userName: "최승아")
//                        .rotationEffect(.degrees(4))
//                        .onTapGesture {
//                            withAnimation(.easeInOut(duration: 0.3)) {
//                                showMaxView = true
//                            }
//                        }
//                }
//            }
//            
//            // ✅ 확대 화면들은 ZStack의 위쪽에 둬야 함!
//            if showMaxView {
//                CerificationMax(isPresented: $showMaxView)
//                    .transition(.opacity)
//                    .zIndex(1)
//            }
//            
//            if showPassCard {
//                PassCardMax(isPresented: $showPassCard)
//                    .transition(.opacity)
//                    .zIndex(1)
//            }
//        }
//    }
//}
//
//#Preview {
//    TestingPage()
//}
