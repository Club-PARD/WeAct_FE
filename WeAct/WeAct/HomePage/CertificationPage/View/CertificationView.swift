import SwiftUI

struct CertificationView: View {
    @StateObject private var viewModel = CertificationViewModel()
    @State private var roomDetail: RoomGroupModel?
    @State private var showingImagePicker = false
    @Environment(\.dismiss) private var dismiss

    let roomId: Int
    
    init(roomId: Int) {
        self.roomId = roomId
       }
    
    var body: some View {
        NavigationView {
            VStack {
                // 헤더
                ZStack {
                    Text("습관 인증하기")
                        .font(.body)
                        .foregroundColor(.black)

                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 15)

                VStack(alignment: .leading) {
                    Text("오늘은 어떻게 인증할까요?")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(Color(hex: "858588"))
                        .padding(.top, 43)
                    
                    // 선택 버튼
                    HStack(spacing: 10) {
                        Button(action: {
                            viewModel.selectedOption = "인증할래요"
                        }) {
                            Text("인증할래요")
                                .font(.custom("Pretendard-Medium", size: 16))
                                .foregroundColor(viewModel.selectedOption == "인증할래요" ? .white : .gray)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(viewModel.selectedOption == "인증할래요" ? Color(hex: "464646") : Color(hex: "E7E7E7"))
                                .cornerRadius(8)
                        }

                        Button(action: {
                            viewModel.selectedOption = "해명할래요"
                        }) {
                            Text("해명할래요")
                                .font(.custom("Pretendard-Medium", size: 16))
                                .foregroundColor(viewModel.selectedOption == "해명할래요" ? .white : .gray)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(viewModel.selectedOption == "해명할래요" ? Color(hex: "464646") : Color(hex: "E7E7E7"))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.vertical, 12)

                    // 메시지 입력
                    VStack(alignment: .leading) {
                        Text(viewModel.selectedOption == "인증할래요" ? "한 마디를 작성해주세요" : "친구에게 해명 한마디를 전해주세요")
                            .font(.custom("Pretendard-Medium", size: 16))
                            .foregroundColor(Color(hex: "858588"))

                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                                .frame(height: 54)

                            HStack {
                                LimitedTextField(text: $viewModel.message, placeholder: "오늘의 인증합니다", characterLimit: 15)
                                    .frame(height: 20)
                                    .padding(.vertical, 22)
                                
                                Spacer()
                                (
                                    Text("\(viewModel.message.count)")
                                        .foregroundColor(Color(hex: "FF4B2F"))
                                    +
                                    Text("/15")
                                        .foregroundColor(.gray)
                                )
                                .font(.caption)
                                .padding(.trailing, 22)
                            }
                            .padding(.horizontal, 12)
                        }
                    }

                    // 이미지 선택 (인증할래요일 때만)
                    if viewModel.selectedOption == "인증할래요" {
                        VStack(alignment: .leading, spacing: 17) {
                            Text("인증 사진을 등록해주세요")
                                .font(.custom("Pretendard-Medium", size: 16))
                                .foregroundColor(Color(hex: "858588"))
                                .padding(.top, 10)

                            HStack {
                                Spacer()
                                Button(action: {
                                    showingImagePicker = true
                                }) {
                                    if let image = viewModel.image {
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 181, height: 229)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                            .clipped()
                                    } else {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [6]))
                                            .foregroundColor(.gray)
                                            .frame(width: 200, height: 280)
                                            .overlay(
                                                Image(systemName: "plus")
                                                    .font(.system(size: 30, weight: .regular))
                                                    .foregroundColor(.gray)
                                            )
                                    }
                                }
                                .sheet(isPresented: $showingImagePicker) {
                                    ImagePicker(image: $viewModel.image)
                                }
                                Spacer()
                            }
                        }
                        .transition(.opacity)
                    }

                    Spacer()

                    // 게시하기 버튼
                    Button(action: {
                        Task {
                            await viewModel.submitHabit(roomId: roomId)
                        }
                    }) {
                        if viewModel.isSubmitting {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                                Text("게시 중...")
                                    .foregroundColor(.white)
                            }
                        } else {
                            Text("게시하기")
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.isSubmitting ? Color.gray : Color(hex: "FF4B2F"))
                    .cornerRadius(10)
                    .disabled(viewModel.isSubmitting)
                }
                .padding(.bottom, 18)
                .padding(.horizontal, 18)
            }
        }
        .navigationBarBackButtonHidden(true)
        .alert("알림", isPresented: $viewModel.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    CertificationView(roomId: 1)
}
