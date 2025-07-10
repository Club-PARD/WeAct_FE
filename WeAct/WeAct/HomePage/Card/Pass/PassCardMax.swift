//
//  PassCardMax.swift
//  WeAct
//
//  Created by 현승훈 on 7/9/25.
//

import SwiftUI

struct PassCardMax: View {
    @Binding var isPresented: Bool
    @State private var isFlipped = false
    
    var body: some View {
        ZStack {
            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                .ignoresSafeArea()
            
            ZStack {
                if !isFlipped {
                    PassCardDetail(isFlipped: $isFlipped, isPresented: $isPresented)
                        .transition(.identity)
                }
                
                if isFlipped {
                    CommentPage_pass(isFlipped: $isFlipped)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .transition(.identity)
                }
            }
            .frame(width: 280, height: 500)
            .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            .animation(.easeInOut(duration: 0.6), value: isFlipped)
        }
    }
}
