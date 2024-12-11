//
//  SellerInfoSetting.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/19/24.
//

import SwiftUI
import FirebaseFirestore

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
        
        SellerInputBox(inputText: $userName, title: "이름", placeholder: userName)
        SellerInputBox(inputText: $userId, title: "아이디", placeholder: userId)
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
        
        var updatedData: SellerEditModel = SellerEditModel(
            name: userName,
            userid: userId,
            password: userPwd.isEmpty ? "" : userPwd,
            phone: userPhone
        )
        
        do {
            let resultMessage = try await firestoreManager.editSeller(updatedData: updatedData)
            alertMessage = resultMessage
            showAlert = true
        } catch {
            alertMessage = "정보 수정 중 오류가 발생했습니다: \(error.localizedDescription)"
            showAlert = true
        }
    }
}

#Preview {
    SellerInfoSetting()
}
