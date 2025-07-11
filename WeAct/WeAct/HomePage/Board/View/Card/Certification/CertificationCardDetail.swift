import SwiftUI

struct CertificationCardDetail: View {
    @Binding var isFlipped: Bool
    @Binding var isPresented: Bool

    @State private var isLiked = UserDefaults.standard.bool(forKey: "isLiked")
    @State private var likeCount = UserDefaults.standard.integer(forKey: "likeCount")

    let userName: String
    let message: String
    let imageUrl: String?

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .frame(width: 280, height: 452)
                .overlay(
                    VStack {
                        ZStack(alignment: .topTrailing) {
                            if let imageUrl = imageUrl, let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 268, height: 372)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .padding(.top, 26)
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                        .frame(width: 268, height: 372)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                        .padding(.top, 26)
                                }
                            }

                            Button(action: {
                                withAnimation {
                                    isPresented = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .padding(.top, 25)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, 20)
                            .padding(.trailing, 20)
                        }

                        Spacer()

                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image("BasicProfile")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .clipShape(Circle())
                                Text(userName)
                                    .font(.custom("Pretendard-Bold", size: 18))
                                Spacer()
                                Button(action: {
                                    isLiked.toggle()
                                    likeCount += isLiked ? 1 : -1

                                    UserDefaults.standard.set(isLiked, forKey: "isLiked")
                                    UserDefaults.standard.set(likeCount, forKey: "likeCount")
                                }) {
                                    HStack(spacing: 4) {
                                        Image(systemName: isLiked ? "heart.fill" : "heart")
                                            .foregroundColor(Color(hex: "FF4B2F"))
                                        Text("\(likeCount)")
                                            .font(.custom("Pretendard-Medium", size: 14))
                                            .foregroundColor(Color(hex: "FF4B2F"))
                                    }
                                }
                                .buttonStyle(.plain)
                            }

                            Text(message)
                                .font(.custom("Pretendard-Medium", size: 14))
                                .foregroundColor(Color(hex: "464646"))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                    }
                )

            Spacer().frame(height: 53)

            Button(action: {
                withAnimation {
                    isFlipped = true
                }
            }) {
                HStack {
                    Image(systemName: "message.fill")
                    Text("댓글 달기")
                }
            }
            .foregroundColor(.white)
            .frame(width: 118, height: 48)
            .background(Color(hex: "FF4B2F"))
            .cornerRadius(24)
        }
    }
}
