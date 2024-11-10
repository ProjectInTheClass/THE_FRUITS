//
//  FruitCardView.swift
//  THE_FRUITS
//
//  Created by 김진주 on 11/6/24.
//

import SwiftUI
import Foundation

struct FruitCardView: View {
    let brand: FruitItem
    @State private var currentLikes:Int//좋아요 수 관리
    @State private var hasLiked:Bool=false //사용자가 좋아요를 눌렀는지 관리
    
    init(brand:FruitItem){
        self.brand=brand
        _currentLikes=State(initialValue: brand.likes)
        //_hasLiked=State(initialValue: liked)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 이미지 부분
            AsyncImage(url: URL(string: brand.imageUrl)) { image in
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

            // 상점 이름//클릭하면 해당 상점으로 이동해야 함
            Text("[\(brand.name)]")
                .font(.headline)
                .foregroundColor(Color.gray)

            // 태그
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 4) {
                    ForEach(brand.tags, id: \.self) { tag in
                        Text(tag)
                            .font(.custom("Pretendard-SemiBold",size:10))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 7)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        //.frame(width: 100, height:100)
                    }
                }
                .frame(maxWidth:.infinity,alignment: .center)
            }

            // 좋아요를 클릭하면 좋아요 수가 올라가야 함. 취소하면 다시 -1
            HStack(spacing: 4) {
                Button(action:toggleLike){
                    Image(systemName: hasLiked ? "heart.fill": "heart")
                        .foregroundColor(hasLiked ? .red : Color("darkGreen"))
                }
                Text("\(currentLikes)")
                    .foregroundColor(Color("darkGreen"))
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 4)
        .frame(width: 180,height:280) // 카드 전체 너비 설정
    }
    
//    private func incrementLikes(){
//        guard !hasLiked else {return} //이미 좋아요를 눌렀으면 아무것도 안하게
//        currentLikes+=1
//        hasLiked = true
//        
//    }
    private func toggleLike(){
        if hasLiked{
            currentLikes-=1
            //db에 반영하는 로직 추가
            
        }else{
            currentLikes+=1
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
