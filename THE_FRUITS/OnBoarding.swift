import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct OnBoarding: View {
    @EnvironmentObject var firestoreManager: FireStoreManager // 공유 객체
    @State private var isUserAuthenticated: Bool = false
    @State private var userType: String? = nil
    @State var currentUserId: String? = nil
    @State var selectedTab = 0
    

    var body: some View {
        NavigationStack {
            if isUserAuthenticated {

                if let userType = userType, let currentUserId = currentUserId {

                    if userType == "customer" {
                        CustomerRootView( selectedTab: $selectedTab)
                    
                    } else if userType == "seller" {
                        SellerRootView(selectedTab: $selectedTab)
                    }
                } else {
                    // 인증 중이지만 데이터가 아직 로드되지 않은 경우
                    Text("사용자 데이터를 불러오는 중입니다...")
                }
            } else {
            ZStack {
                Image("onBoardingImageOriginal")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    Spacer() // 여백 추가
                        .frame(height: 450)

                    Text("TheFruits")
                        .font(.custom("Magnolia Script", size: 63))
                        
                        .foregroundStyle(.white)
                        .padding(.bottom, 8)

                        // 인증되지 않은 경우, 로그인 버튼 표시
                        NavigationLink(destination: Login(userType: "customer")) {
                            Text("구매자로 시작하기")
                                .font(.custom("Pretendard-SemiBold", size: 18))
                                .frame(width: 330, height: 60)
                                .foregroundStyle(.white)
                                .background(Color(red: 26 / 255, green: 50 / 255, blue: 27 / 255))
                                .cornerRadius(40)
                        }

                        NavigationLink(destination: Login(userType: "seller")) {
                            Text("판매자로 시작하기")
                                .font(.custom("Pretendard-SemiBold", size: 18))
                                .frame(width: 330, height: 60)
                                .foregroundStyle(.black)
                                .background(Color(red: 233 / 255, green: 229 / 255, blue: 219 / 255))
                                .cornerRadius(40)
                        }
                    }
                }
            }
        }
        .onAppear {
            checkUserAuthentication()
        }
        
    }


    func checkUserAuthentication() {
        if let currentUser = Auth.auth().currentUser {
            let db = firestoreManager.db
            currentUserId = currentUser.uid

            let customerDocRef = db.collection("customer").document(currentUser.uid)
            customerDocRef.getDocument { (document, error) in
                if let error = error {
                    print("Error fetching customer data: \(error.localizedDescription)")
                    return
                }

                if let document = document, document.exists {
                    DispatchQueue.main.async {
                        self.isUserAuthenticated = true
                        self.userType = "customer"
                        firestoreManager.customerid = currentUser.uid
                        firestoreManager.fetchUserData(userType: "customer", userId: currentUser.uid)
                        firestoreManager.fetchCustomer()
                    }
                    return
                }

                // 고객 데이터가 없으면 판매자 데이터 확인
                let sellerDocRef = db.collection("seller").document(currentUser.uid)
                sellerDocRef.getDocument { (document, error) in
                    if let error = error {
                        print("Error fetching seller data: \(error.localizedDescription)")
                        return
                    }

                    if let document = document, document.exists {
                        DispatchQueue.main.async {
                            self.isUserAuthenticated = true
                            self.userType = "seller"
                            firestoreManager.sellerid = currentUser.uid
                            firestoreManager.fetchUserData(userType: "seller", userId: currentUser.uid)
                            firestoreManager.fetchSeller()
                        }
                        return
                    } else {
                        print("User not found in customers or sellers collection")
                    }
                }
            }
        } else {
            print("No user is logged in")
        }
    }
}
