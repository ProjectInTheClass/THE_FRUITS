//
//  CustomerInfoSetting.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/5/24.
//
import SwiftUI

struct CustomerInfoSetting: View {
    @State private var userName: String = ""
    @State private var userId: String = ""
    @State private var userPwd: String = ""
    @State private var userPwdConfirm: String = ""
    @State private var userPhone: String = ""
    
    @State private var showAlert = false
    @State private var alertMessage: String = ""
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var customer: CustomerModel? // 기존 고객 데이터를 저장
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
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
            
            CustomerInputBox(inputText: $userName, title: "이름", placeholder: customer?.name ?? "이름")
            CustomerInputBox(inputText: $userPwd, title: "비밀번호", placeholder: "비밀번호", isPwd: true)
            CustomerInputBox(inputText: $userPwdConfirm, title: "비밀번호 확인", placeholder: "비밀번호 확인", isPwd: true)
            
            if userPwd != userPwdConfirm && !userPwd.isEmpty {
                Text("비밀번호가 일치하지 않습니다.")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding(.top, -10)
            }
            
            CustomerInputBox(inputText: $userPhone, title: "휴대폰", placeholder: customer?.phone ?? "휴대폰 번호")
        }
        .padding(.top, 20)
        .onAppear {
            fetchCustomerInfo() // 뷰가 로드될 때 호출
        }
        
        Spacer()
        
        CustomButton(
            title: "확인",
            background: Color("darkGreen"),
            foregroundColor: .white,
            width: 140,
            height: 33,
            size: 14,
            cornerRadius: 15,
            action: {
                submitUserInfo()
            }
        )
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("알림"),
                message: Text(alertMessage),
                dismissButton: .default(Text("확인")) {
                    showAlert = false
                    dismiss()
                }
            )
        }
        
        Spacer()
    }
    
    private func submitUserInfo() {
        guard let customer = customer else {
            alertMessage = "고객 정보를 불러오는 데 실패했습니다."
            showAlert = true
            return
        }
        
        let updatedName = userName.isEmpty ? customer.name : userName
        let updatedPhone = userPhone.isEmpty ? customer.phone : userPhone
        let updatedPwd = userPwd.isEmpty ? customer.password : userPwd
        
        if userPwd != userPwdConfirm && !userPwd.isEmpty {
            alertMessage = "비밀번호가 일치하지 않습니다."
            showAlert = true
            return
        }
        if userPwd.count < 6 {
            alertMessage = "비밀번호를 6자 이상 입력해주세요."
            showAlert = true
            return
        }
        
        Task {
            do {
                try await firestoreManager.updateCustomerInfo(
                    customerId: customer.customerid,
                    name: updatedName,
                    phone: updatedPhone,
                    password: updatedPwd
                )
                
                if !userPwd.isEmpty {
                    try await updateFirebasePassword(newPassword: userPwd)
                }
                
                alertMessage = """
                입력하신 정보가 성공적으로 업데이트되었습니다:
                이름: \(updatedName)
                휴대폰: \(updatedPhone)
                """
                showAlert = true
            } catch {
                alertMessage = "정보 업데이트 중 오류가 발생했습니다: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
    
    private func fetchCustomerInfo() {
        Task {
            do {
                customer = firestoreManager.customer // FirestoreManager에서 고객 정보 가져오기
                userName = customer?.name ?? ""
                userId = customer?.username ?? ""
                userPhone = customer?.phone ?? ""
            } catch {
                alertMessage = "고객 정보를 불러오는 데 실패했습니다."
                showAlert = true
            }
        }
    }
}

#Preview {
    CustomerInfoSetting()
        .environmentObject(FireStoreManager())
}

