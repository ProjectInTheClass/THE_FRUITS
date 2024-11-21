import SwiftUI
import Foundation

struct FruitCardView: View {
    let brand: FruitItem
    @State private var currentLikes: Int // 좋아요 수 관리
    @State private var hasLiked: Bool = false // 사용자가 좋아요를 눌렀는지 관리

    init(brand: FruitItem) {
        self.brand = brand
        _currentLikes = State(initialValue: brand.likes)
    }

    var body: some View {
        NavigationLink(destination: BrandHome(storeName: brand.name, storeLikes: $currentLikes)) {
            VStack(alignment: .leading, spacing: 3) {
                // 이미지
                HStack {
                    Spacer()
                    AsyncImage(url: URL(string: brand.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 165, height: 165)
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
                        ForEach(brand.tags, id: \.self) { tag in
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
                        Image(systemName: hasLiked ? "heart.fill" : "heart")
                            .foregroundColor(hasLiked ? .red : Color("darkGreen"))
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
        if hasLiked {
            currentLikes -= 1
        } else {
            currentLikes += 1
        }
        hasLiked.toggle()
    }
}

#Preview {
    FruitCardView(brand: FruitItem(
        id: "1",
        name: "온브릭스",
        imageUrl: "https://example.com/image.jpg",
        tags: ["애플망고", "수박", "샤인머스캣"],
        likes: 27
    ))
}

