//
//  FruitCardView.swift
//  THE_FRUITS
//
//  Created by 김진주 on 11/6/24.
//

import SwiftUI


struct FruitCardView: View {
    let fruit: FruitItem

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 이미지 부분
            AsyncImage(url: URL(string: fruit.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 160)
                    .clipped()
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.blue, lineWidth: 2)
                    )
            } placeholder: {
                Color.gray.opacity(0.2)
                    .frame(width: 160, height: 160)
                    .cornerRadius(8)
            }

            // 과일 이름
            Text("[\(fruit.name)]")
                .font(.headline)
                .foregroundColor(Color.gray)

            // 태그
            HStack(spacing: 4) {
                ForEach(fruit.tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                        //.frame(width:100)
                }
            }

            // 좋아요 수
            HStack(spacing: 4) {
                Image(systemName: "heart")
                    .foregroundColor(.green)
                Text("\(fruit.likes)")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 4)
        .frame(width: 180) // 카드 전체 너비 설정
    }
}

#Preview {
    FruitCardView(fruit: FruitItem(
        id: "1",
        name: "온브릭스",
        imageUrl: "https://example.com/image.jpg",
        tags: ["애플망고", "수박", "샤인머스캣"],
        likes: 27
    ))
}
