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
    @State private var alertMessage:String = ""
    @State private var isAlertPresented: Bool = false // 알림 표시 상태
    @State private var navigateToCustomerCart = false
    
    var body: some View{
        VStack(spacing:0) {
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
                               /* HStack(spacing: 8) {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                    Text("\(storeLikes)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }*/
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
            }
            .padding()
            .padding(.bottom,10) // Sticky Footer 높이만큼 추가


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
                            .frame(height:4)
                    }
                    .frame(height: 20) // 전체 높이 조정
                    .clipped() // 추가된 패딩 영향을 제거
                    .padding(.bottom,10)
                    
                    HStack {
                        Button(action: {
                            let cartItems = products.getCartItems()
                            
                            if cartItems.isEmpty{
                                isModalPresented = false
                                alertMessage = "1개 이상의 상품을 담아주세요."
                                isAlertPresented = true
                                return
                            }
                            // 현재 장바구니 상태 확인
                            firestoreManager.fetchCartBrandId { currentBrandId in
                                if currentBrandId == nil || currentBrandId == brand.brandid||currentBrandId == "" {
                                    // 같은 브랜드거나, 장바구니가 비어 있으면 바로 추가
                                    firestoreManager.uploadCartItems(brandid: brand.brandid, cartItems: cartItems) { result in
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
                                    self.newBrandId = brand.brandid
                                    isReplaceCartModalPresented = true
                                }
                            }
                        }){ Text("장바구니 추가")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color("darkGreen"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .alert(alertMessage, isPresented:$isAlertPresented){
                            Button("확인" , role: .cancel) {}
                        }
                        .alert(isPresented: $isReplaceCartModalPresented) {
                            Alert(
                                title: Text("장바구니 브랜드 변경"),
                                message: Text("장바구니에는 같은 브랜드의 상품만 담을 수 있습니다. '\(brand.name)' 브랜드 상품으로 변경하시겠습니까?"),
                                primaryButton: .destructive(Text("확인")) {
                                    Task {
                                        do {
                                            // 기존 카트의 항목 가져오기
                                            //실시간 페치
                                            //await firestoreManager.fetchCart();
                                            let deleteItems = try await firestoreManager.fetchCartOrderprodid()
                                            
                                            print("deleteItems: \(deleteItems)")
                                            
                                            // 기존 카트 항목 삭제
                                            for orderprodid in deleteItems {
                                                try await firestoreManager.deleteOrderProd(orderprodId:orderprodid)
                                            }
                                            // 새 장바구니 항목 업로드
                                            let cartItems = products.getCartItems()
                                            firestoreManager.uploadCartItems(brandid: brand.brandid, cartItems: cartItems) { result in
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
                                        } catch {
                                            print("Error fetching cart orderprodid: \(error.localizedDescription)")
                                        }
                                    }
                                },
                                secondaryButton: .cancel(Text("취소"))
                            )
                        }

                    }
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 2)
            }
            .frame(height: 100) // 고정된 Footer 높이
            //.frame(maxHeight: .infinity, alignment: .bottom) // 하단 고정
        }
        .toolbar {//툴바를 누르면 장바구니 페이지로 이동
            ToolbarItem(placement:.navigationBarTrailing){
                CartToolbar(navigateToCart: $navigateToCustomerCart)
            }
        }
        
        .onAppear {
            Task{
                await firestoreManager.fetchCart();
                loadProducts()
            }
        }
        .background(
            NavigationLink(
                destination: CustomerCart(), // 이동할 뷰
                isActive: $navigateToCustomerCart, // 상태 관리
                label: { EmptyView() }
            )
        )

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

