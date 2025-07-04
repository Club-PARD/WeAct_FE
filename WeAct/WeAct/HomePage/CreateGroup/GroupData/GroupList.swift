import SwiftUI

struct GroupList: View {
    @Binding var navigationPath: NavigationPath
    let group: GroupModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(group.name)
                            .font(.custom("Pretendard-SemiBold", size: 22))
                            .foregroundColor(Color(hex: "171717"))
                        Text("\(group.partners.count)")
                            .font(.custom("Pretendard-Medium", size: 18))
                            .foregroundColor(Color(hex: "929292"))
                    } // HStack
                    
                    
                    Text(group.habitText)
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(Color(hex: "171717"))
                    
                    HStack {
                        Text(group.periodShort)
                            .font(.custom("Pretendard-Medium", size: 14))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "939393"))
                            .background(Color(hex: "F7F7F7"))
                            .cornerRadius(6)
                        
                        Text("주 \(group.selectedDaysCount)회")
                            .font(.custom("Pretendard-Medium", size: 14))
                            .padding(.vertical, 2)
                            .padding(.horizontal, 8)
                            .foregroundColor(Color(hex: "939393"))
                            .background(Color(hex: "F7F7F7"))
                            .cornerRadius(6)
                    }
                }
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
                }
            }
            
            Divider()
            
            HStack {
                Image("icon_goal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                
                Text("개인 달성률")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundColor(Color(hex: "464646"))
                
                Text("58%")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundColor(Color(hex: "FF4B2F"))
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 22)
        .background(.white)
        .cornerRadius(20)
        .contentShape(Rectangle()) // 빈 영역 터치 가능하게
        .onTapGesture {
            navigationPath.append(NavigationDestination.groupBoard(group))
        }
    }
}

#Preview {
    StatefulPreviewWrapper(NavigationPath()) { path in
        GroupList(
            navigationPath: path,
            group: GroupModel(
                name: "아침 운동 챌린지",
                period: "2024.07.01 ~ 2024.07.31",
                reward: "스타벅스 기프티콘",
                partners: ["김철수", "이영희", "박민수", "최수진", "정다은"],
                selectedDaysString: ["월", "수", "금"],
                selectedDaysCount: 3,
                habitText: "매일 아침 스트레칭"
            )
        )
    }
}
