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
            VStack {
                // 상단 그룹 정보
                VStack(alignment: .leading) {
                    HStack {
                        Text(group.name)
                            .font(.system(size: 24, weight: .bold))
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
                        // 인증 템플릿 연결
                    } label: {
                        
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 78)
                            .foregroundColor((Color(hex: "9FADBC")))
                        
                    } // Button
                    .padding(.bottom, 58)
                } // HStack
                .padding(.horizontal, 24)
                
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
            .sheet(isPresented: $showImagePicker) {
                ImagePickerSheet()
            }
        } // ZStack
        
        .overlay(
                        ZStack {
                            HStack {
                                Button {
                                    presentSideMenu.toggle()
                                } label: {
                                    Image("Menu")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                }
                                .frame(width: 24, height: 24)
                                .padding(.leading, 30)
                                
                                Spacer()
                            } // HStack
                        } // ZStack
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .zIndex(1)
                            .shadow(radius: 0.3)
                        , alignment: .top) // overlay
                    .background(Color.gray.opacity(0.8))
                    
                    SideMenu()
                }
    @ViewBuilder
       private func SideMenu() -> some View {
           SideView(isShowing: $presentSideMenu, direction: .leading) {
               SideMenuViewContents(presentSideMenu: $presentSideMenu)
                   .frame(width: 300)
           }
       
    }
}

// 오늘의 인증 카드
struct TodayVerificationCard: View {
    let onPhotoTap: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("오늘의 인증")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(Color(hex: "40444B"))
                Spacer()
                Text("2024.07.01")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8691A2"))
            }
            
            Button(action: onPhotoTap) {
                VStack(spacing: 12) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 32))
                        .foregroundColor(Color(hex: "8691A2"))
                    
                    Text("사진을 업로드해서\n습관을 인증해보세요!")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "8691A2"))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .background(Color(hex: "F8F9FA"))
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "E9ECEF"), style: StrokeStyle(lineWidth: 1, dash: [5]))
                )
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// 피드 아이템
struct FeedItem: View {
    let userName: String
    let timeAgo: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Circle()
                    .fill(Color(hex: "40444B"))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "person")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(userName)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Color(hex: "40444B"))
                    
                    Text(timeAgo)
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "8691A2"))
                }
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "ellipsis")
                        .foregroundColor(Color(hex: "8691A2"))
                }
            }
            
            Text(content)
                .font(.system(size: 15))
                .foregroundColor(Color(hex: "40444B"))
            
            // 더미 이미지
            Rectangle()
                .fill(Color(hex: "EFF1F5"))
                .frame(height: 200)
                .cornerRadius(8)
                .overlay(
                    Image(systemName: "photo")
                        .font(.system(size: 32))
                        .foregroundColor(Color(hex: "8691A2"))
                )
            
            HStack {
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "heart")
                        Text("12")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8691A2"))
                }
                
                Button(action: {}) {
                    HStack(spacing: 4) {
                        Image(systemName: "message")
                        Text("3")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8691A2"))
                }
                
                Spacer()
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

// 랭킹 아이템
struct RankingItem: View {
    let rank: Int
    let userName: String
    let score: Int
    let isCurrentUser: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // 순위
            Text("\(rank)")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(rank <= 3 ? Color.orange : Color(hex: "8691A2"))
                .frame(width: 30)
            
            // 프로필
            Circle()
                .fill(isCurrentUser ? Color.blue : Color(hex: "40444B"))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                )
            
            // 이름
            VStack(alignment: .leading, spacing: 2) {
                Text(userName)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "40444B"))
                
                if isCurrentUser {
                    Text("나")
                        .font(.system(size: 12))
                        .foregroundColor(.blue)
                }
            }
            
            Spacer()
            
            // 점수
            Text("\(score)점")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(hex: "40444B"))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(isCurrentUser ? Color.blue.opacity(0.1) : Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isCurrentUser ? Color.blue.opacity(0.3) : Color(hex: "E9ECEF"), lineWidth: 1)
        )
    }
}

// 이미지 피커 시트 (더미)
struct ImagePickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                VStack(spacing: 20) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 64))
                        .foregroundColor(Color(hex: "8691A2"))
                    
                    Text("사진 선택 기능")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(Color(hex: "40444B"))
                    
                    Text("실제 구현시 PhotosPicker나\nUIImagePickerController를 사용")
                        .font(.system(size: 14))
                        .foregroundColor(Color(hex: "8691A2"))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
            }
            .navigationTitle("사진 선택")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("취소") {
                    dismiss()
                }
            )
        }
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
