//
//  CustomerInfoSetting.swift
//  THE_FRUITS
//
//  Created by 박지은 on 11/5/24.
//

import SwiftUI

struct CustomerInfoSetting: View {
    @State private var userName: String = "김철수"
    @State private var userId: String = "chulsu"
    @State private var userPwd: String = ""
    @State private var userPwdConfirm: String = ""
    @State private var userPhone: String = "01000000000"
    
    
    @State private var showAlert = false // 모달창을 띄우기 위한 상태관리 변수
    @State private var alertMessage:String=""
    
    
    var body: some View {
//        BackArrowButton(title: "내정보 설정")
//        Spacer()
        
        CustomerInputBox(inputText: $userName, title: "이름", placeholder: userName)
        CustomerInputBox(inputText: $userId, title: "아이디", placeholder: userId)
        CustomerInputBox(inputText: $userPwd,title: "비밀번호", placeholder: "비밀번호", isPwd: true)
        CustomerInputBox(inputText: $userPwdConfirm, title: "비밀번호 확인", placeholder: "비밀번호 확인", isPwd:true)
        
        if userPwd != userPwdConfirm {
            Text("비밀번호가 일치하지 않습니다.")
                .foregroundColor(.red)
                .font(.caption)
                .padding(.top, -10)
        }
        
        CustomerInputBox(inputText: $userPhone, title: "휴대폰", placeholder: userPhone)
        
        CustomButton(
            title: "확인",
            background: Color("darkGreen"),
            foregroundColor: .white,
            width: 140,
            height: 33,
            size: 14,
            cornerRadius: 15,
            action: {
                //버튼을 누르면 서버로 수정된 주소를 submit
                submitUserInfo()
            }
        )
        .alert(isPresented:$showAlert){
            Alert(
                title:Text("알림"),
                message:Text(alertMessage),
                dismissButton: .default(Text("확인"),action:{
                    showAlert=false
                })
            )
        }
        
    }
    private func submitUserInfo(){
        
        if userPwd != userPwdConfirm {
            alertMessage = "비밀번호가 일치하지 않습니다."
        }else {
            alertMessage = """
            입력하신 정보는 다음과 같습니다:
            이름: \(userName)
            아이디: \(userId)
            비밀번호: \(userPwd)
            휴대폰: \(userPhone)
            """
        }
        showAlert=true
        
    }
    
}

#Preview {
    CustomerInfoSetting()
}
