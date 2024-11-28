import SwiftUI
import FirebaseFirestore

struct CartListView: View {
    @EnvironmentObject var products: ObservableProducts
    @EnvironmentObject var firestoreManager: FireStoreManager // FirestoreManager 주입
    @State private var isModalPresented = false // 모달 상태
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
                    isModalPresented = false // 담긴 상품이 없으면 동작 안 함
                    return
                }

                firestoreManager.uploadCartItems(brandid: brandid, cartItems: cartItems) { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            isModalPresented = true // 업로드 성공 모달 표시
                            products.items.forEach { $0.f_count = 0 } // 수량 초기화
                        }
                    case .failure(let error):
                        print("Error uploading cart items: \(error.localizedDescription)")
                    }
                }
            }) {
                Text("장바구니 담기")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .alert("장바구니에 담겼습니다.", isPresented: $isModalPresented, actions: {
                Button("확인", role: .cancel) { isModalPresented = false }
            })
        }
        .presentationDetents([.fraction(0.4), .large])
    }
}
