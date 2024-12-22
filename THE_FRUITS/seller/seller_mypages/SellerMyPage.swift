//  MyPage.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/19/24.
//

import SwiftUI
import FirebaseAuth

struct SellerProfileSection: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var userName: String = ""
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("beige"))
            .frame(width: UIScreen.main.bounds.width - 30, height: 180)
            .overlay(
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Image("appleLogo")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        
                        Text(userName)
                            .font(.custom("Pretendard-SemiBold", size: 18))
                            .padding(.leading, 10)
                            .padding(.top, 10)
                        Spacer()
                    }
                    .onAppear{
                        Task {
                            await loadSellerInfo()
                        }
                    }
                    .padding(.leading, 20)
                    .padding(.bottom, 10)
                    Divider()
                    
                    VStack {
                        
                        NavigationButton(
                        icon: "person.fill",
                        title: "내정보 설정",
                        destination: SellerInfoSetting()
                        )
                        .padding(.top, 10)
                        .padding(.bottom, 10)
                        
                    }
                }
            )
    }
    
    private func loadSellerInfo() async {
        firestoreManager.fetchSeller()
        if let seller = firestoreManager.seller {
            userName = seller.name
        }
    }
}

struct SellerMenuSection: View {
    @State var selectedTab: Int = 1
    
    var body: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color("beige"))
            .frame(width: UIScreen.main.bounds.width - 30, height: 70)
            .overlay(
                HStack {
                    Spacer()
                   NavigationButton(
                       icon: nil,
                       title: "주문내역", // 글자 길이에 따라 영역을 차지하는 넓이가 달라짐 -> 수정필요?
                       destination: SellerRootView(selectedTab: $selectedTab)
                        .navigationBarBackButtonHidden(true)
                   )
                    Spacer()
               }
            )
    }
}

struct SellerMyPage: View {
    @State private var isLoggedIn: Bool = true
    var body: some View {
        if isLoggedIn {
            NavigationStack {
                VStack() {
                    SellerProfileSection()
                        .padding(.top, 40)
                        .padding(.bottom, 15)
                    SellerMenuSection()
                    LogoutButton{
                        isLoggedIn = false // 로그아웃 후 상태 업데이트
                    }
                    .padding(.top, 25)
                    SellerAccountDeletionButton {
                        isLoggedIn = false // 계정 삭제 후 상태 업데이트
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                }
            }
            
        } else {
            OnBoarding() // 로그아웃 후 Onboarding 화면으로 전환
        }
    }
}

struct SellerAccountDeletionButton: View {
    var onAccountDeleted: () -> Void
    @State private var showAlert: Bool = false
    @State private var showConfirmationDialog: Bool = false
    @State private var confirmationInput: String = ""
    @EnvironmentObject var firestoreManager: FireStoreManager
    
    var body: some View {
        Button(action: {
            showAlert = true
        }) {
            Text("회원탈퇴")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                .background(Color.gray)
                .cornerRadius(25)
        }
        .buttonStyle(PlainButtonStyle())
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("회원탈퇴"),
                message: Text("정말로 계정을 삭제하시겠습니까? 이 작업은 되돌릴 수 없으며 모든 데이터와 활동 기록이 삭제됩니다."),
                primaryButton: .destructive(Text("삭제")) {
                    showConfirmationDialog = true
                },
                secondaryButton: .cancel(Text("취소"))
            )
        }
        .sheet(isPresented: $showConfirmationDialog) {
            VStack(spacing: 20) {
                Text("계정 삭제 확인")
                    .font(.headline)
                Text("계속하려면 아래 입력란에 '회원탈퇴'를 입력하세요.")
                    .multilineTextAlignment(.center)
                
                TextField("회원탈퇴", text: $confirmationInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                Button(action: {
                    if confirmationInput == "회원탈퇴" {
                        deleteAccount()
                        showConfirmationDialog = false
                    }
                }) {
                    Text("확인")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(confirmationInput == "회원탈퇴" ? Color.red : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(confirmationInput != "회원탈퇴")
                
                Button(action: {
                    showConfirmationDialog = false
                }) {
                    Text("취소")
                        .foregroundColor(.blue)
                }
            }
            .padding()
        }
    }
    
    private func deleteAccount() {
        guard let user = Auth.auth().currentUser else {
            print("사용자가 인증되지 않았습니다.")
            return
        }
        
        // Delete user document from Firestore
        let userId = user.uid
        firestoreManager.deleteSellerDocument(userId: userId) { success in
            if success {
                // Proceed to delete user from Firebase Authentication
                user.delete { error in
                    if let error = error {
                        print("Firebase Auth 계정 삭제 실패: \(error.localizedDescription)")
                    } else {
                        print("계정이 삭제되었습니다.")
                        onAccountDeleted()
                    }
                }
            } else {
                print("Firestore 문서 삭제 실패")
            }
        }
    }
}


