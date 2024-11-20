import SwiftUI

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
    @Published var items: [ProductItem]
    init() {
        self.items = [
            ProductItem(id: "1", name: "프리미엄 고당도 애플망고", price: 7500, imageUrl: "https://example.com/mango.jpg"),
            ProductItem(id: "2", name: "골드 키위", price: 5500, imageUrl: "https://example.com/kiwi.jpg")
        ]
    }
}


struct BrandHome: View {
    let storeName: String
    let storeDesc: String = "Whatever Your Pick!"
    @Binding var storeLikes: Int //
    @StateObject private var products = ObservableProducts()//전역 상태 관리
    let backgroundUrl: String = "https://example.com/background.jpg"
    let logoUrl: String = "https://example.com/store-logo.jpg"
    @State private var searchFruit: String = ""
    @State private var isCartPresented = false // 장바구니 드롭업 뷰 상태
    @State private var isModalPresented = false // 모달창 상태
    @State var tmp_storeLikes = 27 // State 변수 정의

    var body: some View {
        VStack(alignment: .leading) {
//            SearchBar(searchText: $searchFruit)
//                .padding(.top,30)
//            Spacer()
            
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
                            CustomButton(title: "가게정보", background: .yellow, foregroundColor: .black, width: 70, height: 30, size: 14, cornerRadius: 15) {
                                print("가게 정보 버튼이 눌렸습니다.")
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
                        ProductRow(product: product)
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
                }
                Spacer()
            }
            .padding(.vertical, 8)
       // }
    }
}
//
//#Preview {
//    BrandHome(storeName: "온브릭스",storeLikes: $storeLikes)
//}
