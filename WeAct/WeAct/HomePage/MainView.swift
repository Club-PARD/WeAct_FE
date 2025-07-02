//
//  MainView.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var groupStore = GroupStore()
    @State private var navigationPath = NavigationPath()
    @ObservedObject var userViewModel: UserViewModel
    @State private var TodayDate = Date()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(hex: "F7F7F7")
                    .edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading) {
                    HStack {
                        //Image("로고이미지")
                        Text("로고")
                        
                        Spacer()
                        Button {
                            navigationPath.append(NavigationDestination.notification)
                        } label: {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                                .foregroundColor((Color(hex: "9FADBC")))
                        } // Button
                        .padding(.trailing, 7)
                        
                        Button {
                            navigationPath.append(NavigationDestination.myPage)
                        } label: {
                            
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundColor((Color(hex: "9FADBC")))
                            
                        } // Button
                    } // HStack
                    .padding(.bottom, 33)
                    
                    HStack {
                        // 월 숫자
                        Text("\(Calendar.current.component(.month, from: TodayDate))")
                            .font(.custom("Pretendard-SemiBold", size: 26))
                            .foregroundColor(Color(hex: "FF4B2F"))
                        
                        Text("월")
                            .font(.custom("Pretendard-SemiBold", size: 26))
                            .foregroundColor(Color(hex: "171717"))
                        
                        Text("\(Calendar.current.component(.day, from: TodayDate))")
                            .font(.custom("Pretendard-SemiBold", size: 26))
                            .foregroundColor(Color(hex: "FF4B2F"))
                        
                        Text("일")
                            .font(.custom("Pretendard-SemiBold", size: 26))
                            .foregroundColor(Color(hex: "171717"))
                    }
                    
                    Text("오늘도 습관 인증해요!")
                        .foregroundColor(Color(hex: "171717"))
                        .font(.custom("Pretendard-SemiBold", size: 26))
                    
                    Spacer()
                    if groupStore.groups.isEmpty {
                        HStack {
                            Spacer()
                            Image("")
                            
                            Text("생성된 습관 그룹이 없어요\n    그룹을 추가해주세요")
                                .foregroundColor(Color(hex: "C6C6C6"))
                                .font(.custom("Pretendard-Medium", size: 20))
                            Spacer()
                        } // HStack
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(groupStore.groups) { group in
                                    GroupCard(group: group) {
                                        navigationPath.append(NavigationDestination.groupBoard(group))
                                    }
                                }
                            }
                            .padding(.top, 20)
                        }
                    }
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            navigationPath.append(NavigationDestination.createGroup)
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Text("그룹 만들기")
                                    .foregroundColor(.white)
                                    .font(.custom("Pretendard-Medium", size: 16))
                            }
                            .padding(.vertical, 11)
                            .padding(.horizontal, 18)
                            .background(Color(hex: "464646"))
                            .cornerRadius(30)
                        } // Button
                        .padding(.bottom, 42)
                    } // HStack
                    .padding(.horizontal, 19)
                    
                } // VStack
                .padding(.horizontal, 18)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .createGroup:
                        CreateGroup(groupStore: groupStore, navigationPath: $navigationPath)
                    case .addPartner:
                        AddPartner(groupStore: groupStore, navigationPath: $navigationPath)
                    case .groupBoard (let group):
                        GroupDetailBoard(navigationPath: $navigationPath, group: group, groupStore: groupStore)
                    case .notification:
                        NotificationView(navigationPath: $navigationPath)
                    case .myPage:
                        MypageView(navigationPath: $navigationPath, userViewModel: userViewModel)
                    case .nameEdit:
                        NameEditView(navigationPath: $navigationPath, userViewModel: userViewModel)
                        
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let testUserModel = UserViewModel()
    MainView(userViewModel: testUserModel)
}
