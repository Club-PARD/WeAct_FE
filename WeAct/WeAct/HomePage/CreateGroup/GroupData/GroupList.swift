import SwiftUI

struct GroupList: View {
    @Binding var navigationPath: NavigationPath
    var homeGroup: HomeGroupModel
    var group: GroupModel
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    HStack {
                        Text(homeGroup.roomName)
                            .font(.custom("Pretendard-SemiBold", size: 22))
                            .foregroundColor(Color(hex: "171717"))
                        //                        Text("\(group.partners.count)")
                        //                            .font(.custom("Pretendard-Medium", size: 18))
                        //                            .foregroundColor(Color(hex: "929292"))
                    } // HStack
                    
                    
                    Text(homeGroup.habit)
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(Color(hex: "171717"))
                    
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
                
                Text("\(homeGroup.percent)%")
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
            onTap()
        }
    }
}
//
//#Preview {
//    StatefulPreviewWrapper(NavigationPath()) { path in
//        GroupList(
//            navigationPath: path,
//            homeGroup: HomeGroupModel(
//                roomName: "아침 운동 챌린지",
//                habit: "스트레칭하기",
//                period: "2025.07.01 - 2025.07.31",
//                dayCountByWeek: 3,
//                percent: 58
//            ),
//            group: GroupModel,
//            onTap: { }
//        )
//    }
//}
