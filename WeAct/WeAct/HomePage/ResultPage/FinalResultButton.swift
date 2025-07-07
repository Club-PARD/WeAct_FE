//
//  FinalResultButton.swift
//  WeAct
//
//  Created by 현승훈 on 7/1/25.
//

import SwiftUI

struct FinalResultButton: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                Button(action: {
                    path.append("final")
                }) {
                    HStack {
                        Image(systemName: "megaphone.fill")
                            .foregroundColor(.white)
                        Text("최종 결과가 도착했어요")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 24)
                    .clipShape(Capsule())
                }
                .background(Color(hex: "FF4B2F"))
                .cornerRadius(30)
            }

            .navigationDestination(for: String.self) { value in
                if value == "final" {
                    FinalResultPage_Rank1(path: $path)
                } else if value == "celebrate" {
                    CelebratePage(path: $path)
                }
            }
        }
    }
}
