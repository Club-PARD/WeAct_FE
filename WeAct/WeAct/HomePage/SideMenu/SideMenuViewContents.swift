//
//  SideMenuViewContents.swift
//  WeAct
//
//  Created by 최승아 on 7/1/25.
//

import SwiftUI

struct SideMenuViewContents: View {
    @Binding var presentSideMenu: Bool
    
    // 샘플 데이터 - 실제로는 GroupModel에서 받아올 것
    let members = [
        ("김종언", "1시간에 한 걸기", 0.0),
        ("이단지", "자기 전 일기 쓰기", 0.0),
        ("주현아", "기상 후 물 마시기", 0.0),
        ("최송아", "10분 독서", 0.0),
        ("빈지성", "자기 전 일기 쓰기", 0.0),
        ("현승훈", "기상 후 오늘의 할 일 정리", 0.0)
    ]
    
    var body: some View {
            VStack {
                // 상단 헤더
                VStack(spacing: 16) {
                    HStack {
                        Button(action: {
                            presentSideMenu.toggle()
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(Color(hex: "858588"))
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 정보 버튼 액션
                        }) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(Color(hex: "858588"))
                        }
                        
                        Button(action: {
                            // 공유 버튼 액션
                        }) {
                            Image("share")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color(hex: "858588"))
                        }
                        
                    } // HStack
                    .padding(.horizontal, 18)
                    
                    // 그룹 정보
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "8FB4D3"))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "figure.walk")
                                    .font(.system(size: 24, weight: .medium))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("이주원")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.black)
                            
                            HStack(spacing: 4) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "FF6B47"))
                                Text("10분 독서")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "666666"))
                            } // HStack
                            
                            HStack(spacing: 4) {
                                Image(systemName: "arrow.up.right")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color(hex: "FF6B47"))
                                Text("내 습관 달성률")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "666666"))
                                
                                Spacer()
                                
                                Text("58%")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(Color(hex: "FF6B47"))
                            } // HStack
                            
                            // 진행률 바
                            ProgressView(value: 0.58)
                                .progressViewStyle(LinearProgressViewStyle(tint: Color(hex: "FF6B47")))
                                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                        } // VStack
                        
                        Spacer()
                    } // HStack
                    .padding(.horizontal, 20)
                } // VStack
                .padding(.bottom, 24)
                
                // 구분선
                Rectangle()
                    .fill(Color(hex: "F0F0F0"))
                    .frame(height: 8)
                
                // 멤버 목록
                VStack(alignment: .leading, spacing: 0) {
                    Text("친구 목록")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "333333"))
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 12)
                    
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(Array(members.enumerated()), id: \.offset) { index, member in
                                HStack(spacing: 12) {
                                    // 프로필 이미지
                                    Circle()
                                        .fill(Color(hex: "E8E8E8"))
                                        .frame(width: 40, height: 40)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(Color(hex: "999999"))
                                        )
                                    
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(member.0)
                                            .font(.system(size: 16, weight: .medium))
                                            .foregroundColor(.black)
                                        
                                        Text(member.1)
                                            .font(.system(size: 14))
                                            .foregroundColor(Color(hex: "666666"))
                                    } // VStack

                                    Spacer()
                                } // HStack
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                            } // ForEach
                        } // LazyVStack
                    } // ScrollView
                }
                
                Spacer()
                
                // 하단 그룹 나가기 버튼
                Button(action: {
                    // 그룹 나가기 액션
                }) {
                    Text("그룹 나가기")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "FF6B47"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 16)
                } // Button
                .padding(.horizontal, 20)
            } // VStack
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white)
        
    }
}

struct SideView<RenderView: View>: View {
    @Binding var isShowing: Bool
    var direction: Edge
    @ViewBuilder var content: RenderView
    
    var body: some View {
        ZStack(alignment: direction == .trailing ? .trailing : .leading) {
            if isShowing {
                // 배경 오버레이 - 이전 페이지가 비치도록
                Color.black
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                
                // 사이드 메뉴 컨텐츠
                HStack(spacing: 0) {
                    if direction == .trailing {
                        Spacer() // 오른쪽 정렬을 위한 Spacer
                    }
                    
                    content
                        .frame(width: UIScreen.main.bounds.width * 0.76)
                        .background(Color.white)
                        .transition(.move(edge: direction))
                    
                    if direction == .leading {
                        Spacer() // 왼쪽 정렬을 위한 Spacer
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SideMenuViewContents(presentSideMenu: .constant(true))
}
