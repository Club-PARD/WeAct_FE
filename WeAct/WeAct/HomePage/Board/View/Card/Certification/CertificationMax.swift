//
//  CerificationMax.swift
//  WeAct
//
//  Created by 현승훈 on 7/8/25.
//
import SwiftUI

struct CertificationMax: View {
    @Binding var isPresented: Bool
    let postDetail: HabitPostDetailResponse
    @EnvironmentObject var habitBoardVM: HabitBoardViewModel 
    @State private var isFlipped = false  // ✅ 뒤집힘 상태
    
    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                .ignoresSafeArea()
            
            ZStack {
                if !isFlipped {
                    CertificationCardDetail(
                        isFlipped: $isFlipped,
                        isPresented: $isPresented,
                        userName: postDetail.userName,
                        message: postDetail.message,
                        imageUrl: postDetail.imageUrl
                    )

                        .transition(.identity)
                }
                
                if isFlipped {
                    CommentPage(isPresented: $isPresented,
                        postDetail: postDetail,
                        onPhotoView: {
                        withAnimation {
                            isFlipped = false  // 뒤집기만 함, 모달 안 닫음
                        }
                    })
                    .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))  // ✅ 정방향 보정
                    .transition(.identity)
                }
            }
            .frame(width: 280, height: 500)
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .animation(.easeInOut(duration: 0.6), value: isFlipped)
        }
    }
}



// ✅ Blur View 커스텀 구현
struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
