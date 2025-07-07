//
//  ContentView.swift
//  WeAct-Watch Watch App
//
//  Created by 현승훈 on 7/4/25.
//

import SwiftUI

struct ContentView: View {
    @State private var habit = "물 마시기"
    @State private var isCompleted = false
    
    var body: some View {
        VStack {
            // ✅ 사진 추가 (너가 원하는 이미지 이름으로 교체 가능)
            Image("habitImage") // 여기에 네 Asset 이미지 이름 넣기 (예: "water")
                .resizable()
                .scaledToFit()
                .frame(height: 100) // 워치 화면에 맞게 적당한 크기
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            Text("오늘의 습관")
                .font(.headline)
            
            Button(action: {
                isCompleted.toggle()
            }) {
                HStack {
                    Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    Text(habit)
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
