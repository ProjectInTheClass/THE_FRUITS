import SwiftUI
import FirebaseFirestore

struct CustomerWishList: View {
    @EnvironmentObject var firestoreManager: FireStoreManager
    @State private var likeBrands: [String] = [] // 좋아요한 브랜드 ID 배열
    @State private var brandDetails: [BrandModel] = [] // 브랜드 상세 정보 저장
    @State private var isLoading: Bool = false // 로딩 상태 표시
    @State private var storeLikes: Int = 0

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("로딩 중...")
                } else if brandDetails.isEmpty {
                    Text("찜한 브랜드가 비어 있습니다.")
                        .font(.title3)
                        .foregroundColor(.gray)
                } else {
                    List(brandDetails, id: \.brandid) { brand in
                        //let storeLikes = brand.likes
                        NavigationLink(destination: BrandHome(brand: brand, storeLikes: .constant(brand.likes))) {
                            BrandRowView(brand: brand)
                                .padding(.vertical, 8)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("찜한 브랜드")
            .onAppear {
                fetchBrandLikesItems()
            }
        }
    }

    private func fetchBrandLikesItems() {
        isLoading = true
        firestoreManager.fetchCustomerLikes { result in
            switch result {
            case .success(let brandIds):
                likeBrands = brandIds
                Task {
                    await fetchBrandDetails()
                }
            case .failure(let error):
                print("Error fetching likes: \(error.localizedDescription)")
                isLoading = false
            }
        }
    }

    private func fetchBrandDetails() async {
        var fetchedDetails: [BrandModel] = []
        for brandId in likeBrands {
            do {
                if let brand = try await firestoreManager.asyncFetchBrand(brandId: brandId) {
                    fetchedDetails.append(brand)
                }
            } catch {
                print("Error fetching brand details for \(brandId): \(error.localizedDescription)")
            }
        }
        DispatchQueue.main.async {
            brandDetails = fetchedDetails
            isLoading = false
        }
    }
}

struct BrandRowView: View {
    let brand: BrandModel
    //let storeLikes: Int

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // 썸네일 이미지
            if let url = URL(string: brand.thumbnail) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            }

            VStack(alignment: .leading, spacing: 8) {
                // 브랜드 이름
                Text((brand.name))
                    .font(.custom("Pretendard-SemiBold", size: 20)) // 원하는 폰트 이름과 크기 설정
                    .fontWeight(.bold)
                    
                // 태그 목록
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(brand.sigtype?.filter { !$0.isEmpty } ?? [], id: \.self) { tag in // 빈 문자열 필터링
                            Text(tag)
                                .font(.custom("Pretendard-SemiBold", size: 13))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }

            Spacer()

            // 찜 하트 아이콘
            Button(action: {
                // 찜 버튼 액션
            }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
        }
        .padding(.vertical, 8)
    }
}

