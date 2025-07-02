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
            VStack(alignment: .leading) {
                HStack {
                    //Image("로고이미지")
                    Text("로고")
                    Spacer()
                    Button {
                        navigationPath.append(NavigationDestination.notification)
                    } label: {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundColor((Color(hex: "9FADBC")))
                    } // Button
                    .padding(.trailing, 7)
                    
                    Button {
                        navigationPath.append(NavigationDestination.myPage)
                    } label: {
                        
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundColor((Color(hex: "9FADBC")))
                        
                    } // Button
                } // HStack
                .padding(.bottom, 33)
                
                Text(TodayDate.formatted(.dateTime.month(.wide).day().locale(Locale(identifier: "ko_KR"))))
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(Color(hex: "5F656E"))
                
                Text("습관 인증을 해볼까요")
                    .foregroundColor(Color(hex: "8691A2"))
                    .font(.system(size: 26, weight: .medium))
                Spacer()
                if groupStore.groups.isEmpty {
                    HStack {
                        Spacer()
                        Image("")
                        
                        Text("습관 방이 텅 비어있어요\n         추가해주세요")
                            .foregroundColor(Color(hex: "9FADBC"))
                            .font(.system(size: 20, weight: .medium))
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
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 74)
                            .foregroundColor((Color(hex: "9FADBC")))
                        
                    } // Button
                    .padding(.bottom, 58)
                } // HStack
                .padding(.horizontal, 24)
                
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
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    let testUserModel = UserViewModel()
    MainView(userViewModel: testUserModel)
}
