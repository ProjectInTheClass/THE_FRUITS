//
//  SellerInfoSetting.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/19/24.
//

import SwiftUI
import FirebaseFirestore
import FirebaseAuth

struct SellerInfoSetting: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State var selectedTab: Int = 2
    
    @State private var userName: String = ""
    @State private var userId: String = ""
    @State private var userPwd: String = ""
    @State private var userPwdConfirm: String = ""
    @State private var userPhone: String = ""
    
    
    @State private var showAlert = false // 모달창을 띄우기 위한 상태관리 변수
    @State private var alertMessage:String=""
    
    @State private var navigateToSellerRoot = false
    
    var body: some View {
        //        BackArrowButton(title: "내정보 설정")
        //        Spacer()
        Text("아이디")
            .padding(.top,10)
            .font(.custom("Pretendard-SemiBold", size: 16)) // 폰트 조정 가능
            .frame(maxWidth: .infinity, alignment: .leading) // 왼쪽 정렬
            .padding(.leading, 17) // 왼쪽에 패딩 추가
            .padding(.bottom, -15)
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray, lineWidth: 1)
                .frame(height: 50)
            TextField(userId, text: .constant(userId))
                .foregroundColor(.gray)
                .padding(.leading, 10)
                .frame(height: 50)
                .disabled(true)
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
        .padding(.bottom, 10)

        SellerInputBox(inputText: $userName, title: "이름", placeholder: userName)
        SellerInputBox(inputText: $userPwd,title: "비밀번호", placeholder: "비밀번호", isPwd: true)
        SellerInputBox(inputText: $userPwdConfirm, title: "비밀번호 확인", placeholder: "비밀번호 확인", isPwd:true)
        
        if userPwd != userPwdConfirm {
            Text("비밀번호가 일치하지 않습니다.")
                .foregroundColor(.red)
                .font(.caption)
                .padding(.top, -10)
        }
        
        SellerInputBox(inputText: $userPhone, title: "휴대폰", placeholder: userPhone)
        
        NavigationLink(
            destination: SellerRootView(selectedTab: $selectedTab).navigationBarBackButtonHidden(true),
            isActive: $navigateToSellerRoot
        ) {
            CustomButton(
                title: "확인",
                background: Color("darkGreen"),
                foregroundColor: .white,
                width: 140,
                height: 33,
                size: 14,
                cornerRadius: 15,
                action: {
                    Task {
                        await submitUserInfo()
                    }
                }
            )
        }
        .buttonStyle(PlainButtonStyle())
        .alert(isPresented:$showAlert){
            Alert(
                title:Text("알림"),
                message:Text(alertMessage),
                dismissButton: .default(Text("확인")){
                    navigateToSellerRoot = true
                }
            )
        }
        .onAppear{
            Task {
                await loadSellerInfo()
            }
        }
        
    }
    
    private func loadSellerInfo() async {
        firestoreManager.fetchSeller()
        if let seller = firestoreManager.seller {
            userName = seller.name
            userId = seller.username
            userPhone = seller.phone
        }
    }
    
    private func submitUserInfo() async {
        
        if userPwd != userPwdConfirm {
            alertMessage = "비밀번호가 일치하지 않습니다."
            showAlert = true
            return
        }
        if userPwd.count < 6 {
            alertMessage = "비밀번호를 6자 이상 입력해주세요."
            showAlert = true
            return
        }
        
        var updatedData: SellerEditModel = SellerEditModel(
            name: userName,
            userid: userId,
            password: userPwd.isEmpty ? "" : userPwd,
            phone: userPhone
        )
        
        do {
            let resultMessage = try await firestoreManager.editSeller(updatedData: updatedData)
            
            if !userPwd.isEmpty {
                try await updateFirebasePassword(newPassword: userPwd)
            }
            
            alertMessage = resultMessage
            showAlert = true
        } catch {
            alertMessage = "정보 수정 중 오류가 발생했습니다: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

func updateFirebasePassword(newPassword: String) async throws {
    guard let currentUser = Auth.auth().currentUser else {
        throw NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "로그인이 필요합니다."])
    }
    
    do {
        try await currentUser.updatePassword(to: newPassword)
        print("Password updated successfully in Firebase Authentication.")
    } catch {
        print("Failed to update password: \(error.localizedDescription)")
        throw NSError(domain: "AuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "비밀번호 변경 중 오류가 발생했습니다."])
    }
}

#Preview {
    SellerInfoSetting()
}
