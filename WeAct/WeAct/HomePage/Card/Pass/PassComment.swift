//
//  CommentPage_pass.swift
//  WeAct
//
//  Created by 현승훈 on 7/9/25.
//

import SwiftUI

struct PassComment: Identifiable, Hashable, Codable {
    let id: UUID
    let text: String
    let date: Date
    
    init(id: UUID = UUID(), text: String, date: Date) {
        self.id = id
        self.text = text
        self.date = date
    }
}

struct CommentPage_pass: View {
    @Binding var isFlipped: Bool
    @State private var commentText = ""
    @State private var comments: [PassComment] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 0) {
            // ✅ 카드 (댓글 영역)
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 280, height: 452)
                .overlay(
                    VStack(spacing: 0) {
                        // 상단 바 (타이틀 + 닫기 버튼)
                        HStack {
                            Text("댓글")
                                .font(.custom("Pretendard-Bold", size: 18))
                                .padding(.leading)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isFlipped = false  // 뒤집기 (카드로 돌아가기)
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundStyle(.black)
                                    .font(.system(size: 18, weight: .bold))
                                    .padding()
                            }
                        }
                        .padding(.top, 10)
                        
                        // 댓글 리스트
                        ScrollView {
                            VStack(alignment: .leading, spacing: 15) {
                                ForEach(comments) { comment in
                                    HStack(alignment: .top, spacing: 10) {
                                        Image("BasicProfile")
                                            .resizable()
                                            .frame(width: 32, height: 32)
                                            .clipShape(Circle())
                                        
                                        VStack(alignment: .leading, spacing: 4) {
                                            HStack {
                                                Text("이주원")
                                                    .font(.custom("Pretendard-Bold", size: 14))
                                                Text(relativeTimeString(from: comment.date))
                                                    .font(.custom("Pretendard-Medium", size: 12))
                                                    .foregroundColor(.gray)
                                            }
                                            Text(comment.text)
                                                .font(.custom("Pretendard-Medium", size: 14))
                                        }
                                        Spacer()
                                    }
                                }
                            }
                            .padding()
                        }
                        
                        // 댓글 입력창
                        ZStack {
                            TextField("댓글을 입력하세요", text: $commentText)
                                .padding(10)
                                .background(Color(hex: "F7F7F7"))
                                .cornerRadius(8)
                                .frame(width: 252, height: 44)
                            
                            HStack {
                                Spacer()
                                Button(action: {
                                    if !commentText.trimmingCharacters(in: .whitespaces).isEmpty {
                                        let newComment = PassComment(text: commentText, date: Date())
                                        comments.append(newComment)
                                        saveComments()
                                        commentText = ""
                                    }
                                }) {
                                    Image(systemName: "arrow.up.circle.fill")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                        .foregroundStyle(Color(hex: "FF4B2F"))
                                }
                                .padding(.trailing, 26)
                            }
                        }
                        .padding(.bottom, 14)
                    }
                )
            
            // ✅ 카드 밖 버튼 (사진 보기)
            Spacer().frame(height: 53)
            Button(action: {
                withAnimation {
                    isFlipped = false  // 1️⃣ 카드 뒤집기 (사진으로)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {  // 2️⃣ 뒤집기 끝나고
                    withAnimation(.easeInOut(duration: 0.3)) {  // 3️⃣ Fade Out 애니메이션
                        dismiss()  // 4️⃣ TestingPage 사라짐
                    }
                }
            }) {
                HStack {
                    Image("album")
                    Text("사진보기")
                }
            }
            .foregroundColor(.white)
            .frame(width: 118, height: 48)
            .background(Color(hex: "464646"))
            .cornerRadius(24)
        }
        .onAppear {
            loadComments()
        }
    }
    
    // ✅ 시간 표시
    func relativeTimeString(from date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        if seconds < 60 {
            return "\(seconds)초 전"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)분 전"
        } else {
            let hours = seconds / 3600
            return "\(hours)시간 전"
        }
    }
    
    // ✅ 댓글 저장
    func saveComments() {
        if let data = try? JSONEncoder().encode(comments) {
            UserDefaults.standard.set(data, forKey: "savedPassComments")
        }
    }
    
    // ✅ 댓글 불러오기
    func loadComments() {
        if let data = UserDefaults.standard.data(forKey: "savedPassComments"),
           let decoded = try? JSONDecoder().decode([PassComment].self, from: data) {
            comments = decoded
        }
    }
}

//#Preview {
//    CommentPage_pass(isFlipped: .constant(true))
//}
