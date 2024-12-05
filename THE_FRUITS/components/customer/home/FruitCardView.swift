import SwiftUI
import Foundation
import FirebaseFirestore

struct FruitCardView: View {
    let brand: BrandModel
    @State private var currentLikes: Int // 좋아요 수 관리
    @State private var hasLiked: Bool = false // 사용자가 좋아요를 눌렀는지 관리
    @EnvironmentObject var firestoreManager: FireStoreManager
    //현재 과일이 선호하는 브랜드 과일인지 확인하는 prop을 받음
    @Binding var isLiked: Bool // 부모 뷰와 상태 동기화
    var onLikeChanged: (Bool) -> Void // 부모 뷰에서 좋아요 상태 변경을 처리하는 클로저
    
    init(brand: BrandModel, isLiked: Binding<Bool>, onLikeChanged: @escaping (Bool) -> Void) {
          self.brand = brand
          _currentLikes = State(initialValue: brand.likes)
          _isLiked = isLiked
          self.onLikeChanged = onLikeChanged
      }

    var body: some View {
        NavigationLink(destination: BrandHome(brand:brand,storeLikes: $currentLikes)) {
            VStack(alignment: .leading, spacing: 3) {
                // 이미지
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: brand.thumbnail)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 160, height: 165)
                            .clipped()
                            .cornerRadius(8)
                    } placeholder: {
                        Color.gray.opacity(0.2)
                            .frame(width: 160, height: 165)
                            .cornerRadius(8)
                    }
                    Spacer()
                }

                // 상점 이름
                Text("[\(brand.name)]")
                    .font(.headline)
                    .foregroundColor(Color.gray)

                // 태그
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 4) {
                        ForEach(brand.sigtype ?? [], id: \.self) { tag in
                            Text(tag)
                                .font(.custom("Pretendard-SemiBold", size: 10))
                                .padding(.vertical, 5)
                                .padding(.horizontal, 8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }

                // 좋아요 버튼
                HStack(spacing: 4) {
                    Button(action: toggleLike) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundColor(isLiked ? .red : Color("darkGreen"))
                        
                        //버튼이 눌리면 해당 브랜드의 이름을 넘겨줘야 함
                        //어디에?
                        //현재 customer의 likebrand에.
                        
                    }
                    Text("\(currentLikes)")
                        .foregroundColor(Color("darkGreen"))
                        .font(.caption)
                }
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 1)
            .frame(width: 160, height: 260)
        }
        .buttonStyle(PlainButtonStyle()) // NavigationLink 스타일 제거
    }

    private func toggleLike() {
        print("isLiked: \(isLiked)")
        if isLiked {
            currentLikes -= 1
            firestoreManager.updateCustomerLikes(brandid: brand.brandid, add:false)
 
        } else {
            currentLikes += 1
            firestoreManager.updateCustomerLikes(brandid: brand.brandid, add:true)
        }
        hasLiked.toggle()
        isLiked.toggle()
        
        onLikeChanged(hasLiked) // 부모 뷰에 좋아요 상태 전달
        firestoreManager.uploadCurrentLikes(brand: brand, currentLikes:currentLikes)
    }
    
    
        //해당 브랜드의 db에
        //currentLikes를 해당 브랜드의 db likes를 currentLikes로 바꾸어 주어야 함.
        //이미 여기서 브랜드를 페치왔기 때문에 브랜드 테이블에 접근하는 건 쉬움
    
    //해당 브랜드id가 customer의 brandlike배열에 이미 포함된 항목이라면
    //기본값이 heartfill임.
    //이제 거기서 한번 더 누르면 delete brand가 되는 거임
    //그런데 포함되지 않은 brand라면 기본값이 heart이고 거기서 한번더 누르면 브랜드 add인거임
    
    
}

