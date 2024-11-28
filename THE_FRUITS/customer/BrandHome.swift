import SwiftUI
import FirebaseFirestore

class ProductItem: Identifiable, ObservableObject {
    var id: String
    var name: String
    var price: Int
    var imageUrl: String
    @Published var f_count: Int  // 수량을 관리할 상태 변수
    
    init(id: String, name: String, price: Int, imageUrl: String, f_count: Int = 0) {
        self.id = id
        self.name = name
        self.price = price
        self.imageUrl = imageUrl
        self.f_count = f_count
    }
}
//클래스로 관리
class ObservableProducts: ObservableObject {
    @Published var items: [ProductItem]=[]
    func getCartItems() -> [[String: Any]] {//f_count가 0보다 큰 상품들만 필터링함.
        items.filter { $0.f_count > 0 }.map { product in
            [
                "productid": product.id,
                "num": product.f_count
            ]
        }
    }
}

struct BrandHome: View {
    let brand: BrandModel
    @Binding var storeLikes: Int
    @StateObject private var products = ObservableProducts()
    @State private var isCartPresented = false
    @State private var isModalPresented = false
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var isReplaceCartModalPresented = false
    @State private var newBrandId: String = ""
    @State private var currentBrandId: String = ""

    var body: some View {
        ZStack {
            // Scrollable content
            ScrollView {
                VStack(alignment: .leading) {
                    // 배경 이미지와 가게 상세 정보
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: brand.thumbnail)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 230)
                                .clipped()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                                .frame(height: 200)
                        }
                        .padding(.bottom,100)
                        HStack(alignment: .bottom) {
                            AsyncImage(url: URL(string: brand.logo)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 90, height: 90)

                                    .background(Color.clear) // 배경을 투명하게 설정
                                    .cornerRadius(8)
                                    .padding(.bottom, 1)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                                    .frame(width: 90, height: 90)
                                    .cornerRadius(8)
                                    .padding(.bottom, 1)
                            }

                            VStack(alignment: .leading, spacing: 4) {
                                Text(brand.name)
                                    .font(.title)
                                    .fontWeight(.bold)
                                Text(brand.slogan)
                                    .font(.custom("Pretendard-SemiBold", size: 16))
                                    .foregroundColor(Color("darkGreen"))
                            }

                            Spacer()

                            VStack {
                                NavigationLink(destination: BrandDetail(brand: brand)) {
                                    Text("가게정보")
                                        .font(.custom("Pretendard-SemiBold", size: 14))
                                        .frame(width: 70, height: 30)
                                        .foregroundColor(.black)
                                        .background(Color.yellow)
                                        .cornerRadius(15)
                                }
                                HStack(spacing: 8) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                    Text("\(storeLikes)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .background(Color.clear) // HStack 전체 배경 투명화
                        .padding(.horizontal, 12)
                    }
                    Divider()
                        .frame(height: 2)
                        .padding(.vertical, 8)

                    // 상품 리스트
                    VStack(spacing: 16) {
                        ForEach(products.items) { product in
                            ProductRow(product: product)
                        }
                    }
                }
                .padding()
                .sheet(isPresented: $isCartPresented) {
                    CartListView(brandid:brand.brandid)
                         .environmentObject(products)
                 }
                 .alert("장바구니에 담겼습니다.", isPresented: $isModalPresented, actions: {
                     Button("확인", role: .cancel) { isModalPresented = false }
                 })
             
                .navigationTitle(brand.name)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isCartPresented = true
                        }) {
                            Image(systemName: "cart")
                                .font(.title3)
                                .foregroundColor(.black)
                        }
                    }
                }
                .onAppear {
                    loadProducts()
                }
            }

            // Sticky Footer
            VStack(spacing: 0) {

                VStack {
                    Button(action: {
                        isCartPresented = true
                    }) {
                        Text("담은 옵션 보기")
                            .font(.custom("Pretendard-SemiBold", size: 13))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .background(Color("lightGreen"))
                            .foregroundColor(.black)
                            .cornerRadius(5)
                            .frame(height:2)
                    }
                    .frame(height: 15) // 전체 높이 조정
                    .clipped() // 추가된 패딩의 영향을 제거
                    .padding(.bottom,10)
                    
                    HStack {
                        Button(action: {
                            let cartItems = products.getCartItems()
                            guard !cartItems.isEmpty else {
                                isModalPresented = false
                                return
                            }
                            
                            firestoreManager.uploadCartItems(brandid:brand.brandid, cartItems: cartItems) { result in
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
                        }){
                            Text("장바구니 추가")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("darkGreen"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 2)
            }
            .frame(maxHeight: .infinity, alignment: .bottom) // 하단 고정
        }
    }

    func loadProducts() {
        firestoreManager.fetchProductIdsForBrand(storeName: brand.name) { productIds in
            firestoreManager.fetchProducts(for: productIds) { fetchedProducts in
                DispatchQueue.main.async {
                    self.products.items = fetchedProducts
                }
            }
        }
    }
}

struct ProductRow: View {
    @ObservedObject var product: ProductItem

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 170, height: 170)
                    .cornerRadius(8)
            } placeholder: {
                Color.gray.opacity(0.2)
                    .frame(width: 170, height: 170)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("\(product.price)원")
                    .font(.subheadline)
                    .foregroundColor(.black)
                CustomStepper(f_count: $product.f_count, width: 120, height: 20, strokeColor: .white)
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}
