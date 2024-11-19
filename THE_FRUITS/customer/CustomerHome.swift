//
//  Home.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/19/24.
//

import SwiftUI

struct FruitItem: Identifiable {
    var id: String
    var name: String
    var imageUrl: String
    var tags: [String]
    var likes: Int
}

struct CustomerHome: View {
    
    @State private var searchText:String=""
    private var fruits = [
            FruitItem(id: "1", name: "온브릭스", imageUrl: "https://example.com/image1.jpg", tags: ["애플망고", "수박", "샤인머스캣"], likes: 27),
            FruitItem(id: "2", name: "수플린", imageUrl: "https://example.com/image2.jpg", tags: ["사과", "애플망고", "샤인머스캣"], likes: 30),
            FruitItem(id: "3", name: "과일창고", imageUrl: "https://example.com/image2.jpg", tags: ["사과", "애플망고", "샤인머스캣"], likes: 30),
            FruitItem(id: "4", name: "프루트샵", imageUrl: "https://example.com/image2.jpg", tags: ["사과", "애플망고", "샤인머스캣"], likes: 30),
            FruitItem(id: "5", name: "프룻프룻", imageUrl: "https://example.com/image2.jpg", tags: ["사과", "애플망고", "샤인머스캣"], likes: 30),
            FruitItem(id: "6", name: "대청과일", imageUrl: "https://example.com/image2.jpg", tags: ["사과", "애플망고", "샤인머스캣"], likes: 30),
            FruitItem(id: "7", name: "수플린", imageUrl: "https://example.com/image2.jpg", tags: ["사과", "애플망고", "샤인머스캣"], likes: 30),
            FruitItem(id: "8", name: "수플린", imageUrl: "https://example.com/image2.jpg", tags: ["사과", "애플망고", "샤인머스캣"], likes: 30)
        ]

    var body: some View {
        NavigationView{
            VStack{
                SearchBar(searchText: $searchText)
                    .padding(.top,45)
                    .padding(.bottom,6)
                
                HStack(){
                    CustomButton(title: "최신등록순",
                                 background: Color(UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)),
                                 foregroundColor:.black,
                                 width: 55,
                                 height:30,
                                 size:8.5,
                                 cornerRadius: 13,
                                 icon:Image(systemName:"arrow.up.arrow.down"),
                                 iconWidth:10,
                                 iconHeight:10
                    ){
                        print("정렬버튼 클릭!")
                    }
                    Spacer()
                }
                .padding(.leading,12)
                .padding(.bottom, 10) // 버튼과 그리드 사이 간격 추가

                Spacer()//위로 슉 올리기
                
                ScrollView{
                    LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible())], spacing:14) {
                        ForEach(fruits){
                            fruit in FruitCardView(brand:fruit)
                        }
                    }
                    .padding(.horizontal, 4)
                }
            }
 

        }
    }
}

#Preview {
    CustomerHome()
}
