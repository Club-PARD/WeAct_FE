import SwiftUI

struct GroupList: View {
    @Binding var navigationPath: NavigationPath
    var homeGroup: HomeGroupModel // 유저, 홈의 GET
    var group: GroupModel // 룸의 POST
    let canCertifyToday: Bool // 오늘 인증 가능 여부
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(homeGroup.roomName)
                            .font(.custom("Pretendard-SemiBold", size: 22))
                            .foregroundColor(Color(hex: "171717"))
                        Text("\(homeGroup.memberCount)")
                            .font(.custom("Pretendard-Medium", size: 18))
                            .foregroundColor(Color(hex: "929292"))
                    } // HStack
                    
                    
//                    Text(homeGroup.habit)
//                        .font(.custom("Pretendard-Medium", size: 16))
//                        .foregroundColor(Color(hex: "171717"))
                    // 옵셔널 바인딩으로 habit 처리
                                        if let habit = homeGroup.habit, !habit.isEmpty {
                                            Text(habit)
                                                .font(.custom("Pretendard-Medium", size: 16))
                                                .foregroundColor(Color(hex: "171717"))
                                        } else {
                                            Text("습관이 설정되지 않았습니다")
                                                .font(.custom("Pretendard-Medium", size: 16))
                                                .foregroundColor(Color(hex: "929292"))
                                                .italic()
                                        }
                    
                    HStack {
                        Text(homeGroup.period)
                            .font(.custom("Pretendard-Medium", size: 14))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "939393"))
                            .background(Color(hex: "F7F7F7"))
                            .cornerRadius(6)
                        
                        Text("주 \(homeGroup.dayCountByWeek)회")
                            .font(.custom("Pretendard-Medium", size: 14))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "939393"))
                            .background(Color(hex: "F7F7F7"))
                            .cornerRadius(6)
                    } // HStack
                } // VStack
                
                // 인증하기 버튼 (오늘 인증 가능한 경우에만 표시)
                if canCertifyToday {
                    HStack {
                        Spacer()
                        
                        Button {
                            navigationPath.append(NavigationDestination.certification)
                        } label: {
                            VStack {
                                Image(systemName: "camera.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 22, height: 22)
                                    .foregroundColor(.white)
                                Text("인증하기")
                                    .font(.custom("Pretendard-Regular", size: 14))
                                    .foregroundColor(.white)
                            }
                            .padding(10)
                            .background(Color(hex: "FF4B2F"))
                            .cornerRadius(18)
                        } // Button
                    } // HStack
                } // if
            } // HStack
            
            Divider()
            
            HStack {
                Image("icon_goal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text("개인 달성률")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundColor(Color(hex: "464646"))
                
                Text("\(homeGroup.percent)%")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundColor(Color(hex: "FF4B2F"))
            } // HStack
        } // VStack
        .padding(.vertical, 16)
        .padding(.horizontal, 22)
        .background(.white)
        .cornerRadius(20)
        .contentShape(Rectangle()) // 빈 영역 터치 가능하게
        .onTapGesture {
            onTap()
        } // onTapGesture
    }
}
