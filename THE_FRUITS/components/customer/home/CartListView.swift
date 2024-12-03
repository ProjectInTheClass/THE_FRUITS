import SwiftUI
import FirebaseFirestore

struct CartListView: View {
    @EnvironmentObject var products: ObservableProducts
    @EnvironmentObject var firestoreManager: FireStoreManager // FirestoreManager 주입
    @State private var isModalPresented = false // 모달 상태
    @State private var isReplaceCartModalPresented = false
    @State private var newBrandId: String = ""
    @State private var currentBrandId: String = ""
    let brandid:String
    
    var body: some View {
        VStack {
            Text("장바구니")
                .font(.title)
                .padding()
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(products.items.enumerated()), id: \.1.id) { index, item in
                        CartItemView(
                            itemName: $products.items[index].name,
                            price: $products.items[index].price,
                            f_count: $products.items[index].f_count
                        )
                    }
                }
                .padding()
            }
            Button(action: {
                let cartItems = products.getCartItems()
                guard !cartItems.isEmpty else {
                    isModalPresented = false
                    return
                    //nil인 경우 모달 축
                }
                // 현재 장바구니 상태 확인
                firestoreManager.fetchCartBrandId { currentBrandId in
                    if currentBrandId == nil || currentBrandId == brandid {
                        // 같은 브랜드거나, 장바구니가 비어 있으면 바로 추가
                        firestoreManager.uploadCartItems(brandid: brandid, cartItems: cartItems) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    isModalPresented = true
                                    products.items.forEach { $0.f_count = 0 }
                                }
                            case .failure(let error):
                                print("Error uploading cart items: \(error.localizedDescription)")
                                
                            }
                        }
                    } else {
                        // 다른 브랜드인 경우 모달 표시
                        self.currentBrandId = currentBrandId ?? ""
                        self.newBrandId = brandid
                        isReplaceCartModalPresented = true
                    }
                }
            }){
                Text("장바구니 담기")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            .alert(isPresented: $isReplaceCartModalPresented) { // 이 부분 추가
                Alert(
                    title: Text("장바구니 브랜드 변경"),
                    message: Text("장바구니에는 한 브랜드의 상품들만 담을 수 있습니다. 현재 상품으로 바꾸시겠습니까?"),
                    primaryButton: .destructive(Text("확인")) {//확인을 누르면 그제서야
                        let cartItems = products.getCartItems()//orderprod테이블에 장바구니가 등록되고
                        firestoreManager.uploadCartItems(brandid: brandid, cartItems: cartItems) { result in
                            switch result {
                            case .success:
                                DispatchQueue.main.async {
                                    isModalPresented = true
                                    products.items.forEach { $0.f_count = 0 }
                                }
                            case .failure(let error):
                                print("Error replacing cart items: \(error.localizedDescription)")
                            }
                        }
                    },
                    secondaryButton: .cancel(Text("취소"))
                )
            }
            .alert("장바구니에 담겼습니다.", isPresented: $isModalPresented, actions: {
                Button("확인", role: .cancel) {
                    isModalPresented = false
                    isReplaceCartModalPresented = false
                }
            })
            
        }
        .presentationDetents([.fraction(0.4), .large])
    }
}
