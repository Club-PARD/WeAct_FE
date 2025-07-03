//
//  GroupDetailBoard.swift
//  WeAct
//
//  Created by 최승아 on 7/1/25.
//

import SwiftUI

struct GroupDetailBoard: View {
    @Binding var navigationPath: NavigationPath
    let group: GroupModel
    @ObservedObject var groupStore: GroupStore
    @State var presentSideMenu = false
    
    @State private var showImagePicker = false
    
    var customBackButton: some View {
        Button(action: {
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 12, height: 21)
            }
            .foregroundColor(.black)
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "F7F7F7")
                .edgesIgnoringSafeArea(.all)
            VStack {
                // 상단 그룹 정보
                VStack(alignment: .leading) {
                    HStack {
                        Text(group.name)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(Color(hex: "40444B"))
                        Spacer()
                        
                        Text(group.period)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "8691A2"))
                    } // HStack
            
                    HStack {
                        Text("주기")
                            .font(.system(size: 14))
                            .padding(.vertical, 3)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "CFD7DE"))
                            .background(Color(hex: "EFF1F5"))
                            .cornerRadius(6)
                        
                        Text(group.selectedDaysString.joined(separator: ", "))
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "8691A2"))
                    } // HStack
                    
                    HStack {
                        Text("보상")
                            .font(.system(size: 14))
                            .padding(.vertical, 3)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "CFD7DE"))
                            .background(Color(hex: "EFF1F5"))
                            .cornerRadius(6)
                        
                        Text(group.reward)
                            .font(.system(size: 14))
                            .foregroundColor(Color(hex: "8691A2"))
                    } // HStack
                    
                    //                // 참여자 목록
                    //                HStack {
                    //                    Text("참여자")
                    //                        .font(.system(size: 16, weight: .medium))
                    //                        .foregroundColor(Color(hex: "40444B"))
                    //
                    //                    Spacer()
                    //
                    //                    HStack(spacing: -8) {
                    //                        ForEach(Array(group.partners.prefix(5)), id: \.self) { partner in
                    //                            Circle()
                    //                                .fill(Color(hex: "40444B"))
                    //                                .frame(width: 32, height: 32)
                    //                                .overlay(
                    //                                    Image(systemName: "person")
                    //                                        .font(.system(size: 12))
                    //                                        .foregroundColor(.white)
                    //                                )
                    //                        }
                    //
                    //                        if group.partners.count > 5 {
                    //                            Circle()
                    //                                .fill(Color(hex: "8691A2"))
                    //                                .frame(width: 32, height: 32)
                    //                                .overlay(
                    //                                    Text("+\(group.partners.count - 5)")
                    //                                        .font(.system(size: 10, weight: .medium))
                    //                                        .foregroundColor(.white)
                    //                                )
                    //                        }
                    //                    }
                    //                } // HStack
                } // VStack
                .padding(.horizontal, 18)
                .padding(.vertical, 20)
                .background(Color(hex: "F8F8F9"))
                .cornerRadius(12)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button {
                        //navigationPath.append(NavigationDestination.createGroup)
                    } label: {
                        HStack {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(.white)
                            Text("인증하기")
                                .foregroundColor(.white)
                                .font(.custom("Pretendard-Medium", size: 16))
                        }
                        .padding(.vertical, 11)
                        .padding(.horizontal, 18)
                        .background(Color(hex: "FF4B2F"))
                        .cornerRadius(30)
                    } // Button
                    .padding(.bottom, 42)
                } // HStack
                .padding(.horizontal, 19)
                
            } // VStack
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: customBackButton, trailing:  Button(action: {
                // 설정 메뉴
            }) {
                Image(systemName: "line.3.horizontal")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(hex: "8691A2"))
            })
            .navigationTitle(group.name)
            .navigationBarTitleDisplayMode(.inline)
//            .sheet(isPresented: $showImagePicker) {
//                ImagePickerSheet()
//            }
        } // ZStack
//        
//        .overlay(
//                        ZStack {
//                            HStack {
//                                Button {
//                                    presentSideMenu.toggle()
//                                } label: {
//                                    Image("Menu")
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                }
//                                .frame(width: 24, height: 24)
//                                .padding(.leading, 30)
//                                
//                                Spacer()
//                            } // HStack
//                        } // ZStack
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 56)
//                            .background(Color.white)
//                            .zIndex(1)
//                            .shadow(radius: 0.3)
//                        , alignment: .top) // overlay
//                    .background(Color.gray.opacity(0.8))
//                    
//                    SideMenu()
//                }
//    @ViewBuilder
//       private func SideMenu() -> some View {
//           SideView(isShowing: $presentSideMenu, direction: .leading) {
//               SideMenuViewContents(presentSideMenu: $presentSideMenu)
//                   .frame(width: 300)
//           }
       
    }
}

// 그룹 카드 컴포넌트
struct GroupCard: View {
    let group: GroupModel
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(group.name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(Color(hex: "40444B"))
                    Spacer()
                    Text("주 \(group.selectedDaysCount)회")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(Color(hex: "8691A2"))
                } // HStack
                
                Text("기간: \(group.period)")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8691A2"))
                
                Text("보상: \(group.reward)")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8691A2"))
                
                HStack {
                    Text("참여자: \(group.partners.count)명")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "8691A2"))
                    Spacer()
                    
                    // 참여자 아바타들
                    HStack(spacing: -8) {
                        ForEach(Array(group.partners.prefix(3)), id: \.self) { partner in
                            Circle()
                                .fill(Color(hex: "40444B"))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Image(systemName: "person")
                                        .font(.system(size: 10))
                                        .foregroundColor(.white)
                                )
                        }
                        
                        if group.partners.count > 3 {
                            Circle()
                                .fill(Color(hex: "8691A2"))
                                .frame(width: 24, height: 24)
                                .overlay(
                                    Text("+\(group.partners.count - 3)")
                                        .font(.system(size: 8, weight: .medium))
                                        .foregroundColor(.white)
                                )
                        }
                    } // HStack
                } // HStack
            } // VStack
            .padding(16)
            .background(Color(hex: "F8F9FA"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "E9ECEF"), lineWidth: 1)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                onTap()
            }
        }
    }
}




#Preview {
    @State var path = NavigationPath()
    let groupStore = GroupStore()
    
    let group = GroupModel(
        name: "아침 운동 챌린지",
        period: "2024.07.01 ~ 2024.07.31",
        reward: "스타벅스 기프티콘",
        partners: ["김철수", "이영희", "박민수", "최수진", "정다은", "홍길동"],
        selectedDaysString: ["월", "수", "금"],
        selectedDaysCount: 3
    )
    
    GroupDetailBoard(navigationPath: .constant(path),group: group, groupStore: groupStore)
}
