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
    //사실은 브랜드에 맞는 products json을 페치받아와야 함
    /*init() {
        self.items = [
            ProductItem(id: "1", name: "프리미엄 고당도 애플망고", price: 7500, imageUrl: "https://example.com/mango.jpg"),
            ProductItem(id: "2", name: "골드 키위", price: 5500, imageUrl: "https://example.com/kiwi.jpg"),
            ProductItem(id: "3", name: "꿀 사과", price: 2000, imageUrl: "https://example.com/kiwi.jpg"),
            ProductItem(id: "4", name: "골드 샤인머스캣", price: 9900, imageUrl: "https://example.com/kiwi.jpg"),
            ProductItem(id: "5", name: "하우스 겨울딸기", price: 8500, imageUrl: "https://example.com/kiwi.jpg"),
            ProductItem(id: "6", name: "골드 키위", price: 5500, imageUrl: "https://example.com/kiwi.jpg"),
        ]
    }*/
}
struct BrandHome: View {
    let storeName: String//FruitCardView에서 프롭으로 받음.
    let storeDesc: String = "Whatever Your Pick!"
    @Binding var storeLikes: Int //
    @StateObject private var products = ObservableProducts()//전역 상태 관리
    let backgroundUrl: String = "https://example.com/background.jpg"
    let logoUrl: String = "https://example.com/store-logo.jpg"
    
    @State private var searchFruit: String = ""
    @State private var isCartPresented = false // 장바구니 드롭업 뷰 상태
    @State private var isModalPresented = false // 모달창 상태
    //@State var tmp_storeLikes = 27 // State 변수 정의
    @EnvironmentObject var firestoreManager: FireStoreManager
    //브랜드 id를 가지고 오고, 그 brand테이블에 가서 productid json에 있는 productid를 보고 product테이블에서 해당 과일 정보를 가지고 와야 함.
    
    var body: some View {
        VStack(alignment: .leading) {
            // Background image and store details section
            ZStack(alignment: .bottomLeading) {
                // 상위 배경 이미지
                AsyncImage(url: URL(string: backgroundUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                        .clipped()
                } placeholder: {
                    Color.gray.opacity(0.2)
                        .frame(height: 200)
                }
                
                // Store logo and details
                HStack(alignment: .bottom) {
                    AsyncImage(url: URL(string: logoUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 90, height: 90)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(8)
                            .padding(.bottom, 1)
                    } placeholder: {
                        Color.gray.opacity(0.2)
                            .frame(width: 90, height: 90)
                            .cornerRadius(8)
                            .padding(.bottom, 1)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(storeName)
                                .font(.title)
                                .fontWeight(.bold)
                            Text(storeDesc)
                                .font(.custom("Pretendard-SemiBold", size: 16))
                                .foregroundColor(Color("darkGreen"))
                        }
                        .padding(.bottom, -70)
                        Spacer()
                        
                        VStack {
                            NavigationLink(destination: BrandDetail(storeName: storeName)) {
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
                        .padding(.top, 60)
                        .padding(.leading, 8)
                    }
                    .padding(.leading, 8)
                }
                .padding(.leading, -14)
                .padding(.horizontal, 12)
                .padding(.bottom, -60)
            }
            .padding(.bottom, 53)
            
            Divider()
                .frame(height: 2)
                .padding(.vertical, 8)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(products.items) { product in
                        ProductRow(product: product)//가져온 데이터 렌더링
                    }
                }
            }
            
            
            // 담은 옵션 보기 드롭업 버튼
            Button(action: {
                isCartPresented = true
            }) {
                Text("담은 옵션 보기")
                    .font(.custom("Pretendard-SemiBold", size: 16))
                    .frame(maxWidth: .infinity,alignment: .leading)
                    .frame(height:20)
                    .background(Color("lightGreen"))
                    .foregroundColor(.black)
                    .cornerRadius(5)
            }
            //Spacer()
        
            .padding(.bottom,-10)
            
            Divider()
                .frame(height: 1)
                .background(Color.gray.opacity(0.4)) // 선 색상 조정
            
            HStack {
                Button(action: {
                    //1이상 고른 과일을 {"num":f_count,"productid":db에 담긴 productid}
                    //saveProductsToDB(products: products, firestoreManager: FireStoreManager())
                    
                    isModalPresented = true // 모달창 표시
                }) {
                    Text("장바구니 추가")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                Button(action: {
                    //purchaseNow()
                }) {
                    Text("바로 구매하기")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("beige"))
                        .foregroundColor(Color("darkGreen"))
                        .cornerRadius(10)
                }
            }
            .padding()
            .sheet(isPresented: $isCartPresented) {
                CartListView()
                    .environmentObject(products)
            }
            .alert("장바구니에 담겼습니다.", isPresented: $isModalPresented, actions: {
                Button("확인", role: .cancel) { isModalPresented = false }
            })
        }
        .padding()
        .navigationTitle(storeName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {//장바구니 툴바 추가
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
        .onAppear{
            loadProducts()
        }
        
    }
    
    func loadProducts() {
        firestoreManager.fetchProductIdsForBrand(storeName: storeName) { productIds in
            print("Fetched Product IDs: \(productIds)") // 디버그 출력

            firestoreManager.fetchProducts(for: productIds) { fetchedProducts in
                print("Fetched Products: \(fetchedProducts)") // 디버그 출력

                DispatchQueue.main.async {
                    self.products.items = fetchedProducts
                    print("Items updated: \(self.products.items)") // 업데이트 확인
                }
            }
        }
    }
    
        
}

struct ProductRow: View {
    @ObservedObject var product: ProductItem
    
    var body: some View {
//        ZStack {
            
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
                    CustomStepper(f_count: $product.f_count,width:120,height:20)
                        .padding(.leading, -173)
                        .padding(.top, 80)
                    //전역으로 products배열을 하나 선언한 다음에. 여기서 f_count("num"의 value)를
                }
                Spacer()
            }
            .padding(.vertical, 8)
       // }
    }
}

/*func prepareProductsForDB(products:ObservableProducts)->[ [String:Any]]{
    return products.items.map{ product in
        [
        "productid":product.id,
        "num":product.f_count
        ]
        //배열의 각 하나의 요소가 {"num":3,"prodid":과일 이름} 이어야 함.
    }
    //배열을 리턴함.
    
}

func saveProductsToDB(products:ObservableProducts,firestoreManager:FireStoreManager){//orderprod 테이블에 orderedid(파이어베이스가 자동생성), products(배열),selected(bool-default:false)가 추가되어야 함.
    //@StateObject var firestoreManager=FireStoreManager()
    let db = Firestore.firestore()
    let cartId = firestoreManager.cartId
    let productData = prepareProductsForDB(products:products)
    
    
    //cartId에 맞는 테이블에 넣어야 하는데
    db.collection("orderprod").addDocument(data: [
        "products":productData,
        "selected":false,
        "timestamp":Date(),
        "cartId":cartId
        
    ]){
        error in
        if let error = error{
            print("오류 발생")
        }
        else{
            print("성공적으로 add")
        }
    }
    
}*/
//
//#Preview {
//    BrandHome(storeName: "온브릭스",storeLikes: $storeLikes)
//}
