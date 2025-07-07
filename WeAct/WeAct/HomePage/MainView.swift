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
                        Image("logo").resizable().frame(width:90, height: 30)
                        Spacer()
                        Button {
                            navigationPath.append(NavigationDestination.notification)
                        } label: {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "9FADBC"))
                        }
                        .padding(.trailing, 7)
                        
                        Button {
                            navigationPath.append(NavigationDestination.myPage)
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "9FADBC"))
                        }
                    } // HStack
                    
                    ZStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HStack {
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
                            } // HStack
                            
                            Text("습관 인증 해볼까요?")
                                .foregroundColor(Color(hex: "171717"))
                                .font(.custom("Pretendard-SemiBold", size: 26))
                        } // VStack
                        
                        HStack {
                            Spacer()
                            Image("IllustHome")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 92)
                        } // HStack
                    } // HStack
                    .padding(.top, 22)
                    
                    // 그룹 없을 때
                    if groupStore.groups.isEmpty {
                        HStack {
                            Spacer()
                            VStack {
                                Image("NoGroup")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.bottom, 32)
                                    .padding(.top, UIScreen.main.bounds.height * 0.106)
                                
                                Text("생성된 습관 그룹이 없어요\n 그룹을 추가해 주세요")
                                    .foregroundColor(Color(hex: "C6C6C6"))
                                    .font(.custom("Pretendard-Medium", size: 20))
                                    .multilineTextAlignment(.center)
                            } // VStack
                            Spacer()
                        } // HStack
                    }
                    // 그룹 있을 때
                    else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(groupStore.groups) { group in
                                    GroupList(navigationPath: $navigationPath, group: group)
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 그룹 만들기 버튼
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
                        }
                        .padding(.bottom, 42)
                    }
                    .padding(.horizontal, 4)
                    
                }
                .padding(.horizontal, 20)
                
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .createGroup:
                        CreateGroup(groupStore: groupStore, navigationPath: $navigationPath)
                    case .addPartner:
                        AddPartner(groupStore: groupStore, navigationPath: $navigationPath)
                    case .groupBoard(let group):
                        GroupDetailBoard(navigationPath: $navigationPath, group: group, groupStore: groupStore)
                    case .notification:
                        NotificationView(navigationPath: $navigationPath)
                    case .myPage:
                        MypageView(navigationPath: $navigationPath, userViewModel: userViewModel)
                    case .nameEdit:
                        NameEditView(navigationPath: $navigationPath, userViewModel: userViewModel)
                    case .certification:
                        CertificationView()
                    case .setuphabit:
                        SetUpHabbit(navigationPath: $navigationPath)
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
