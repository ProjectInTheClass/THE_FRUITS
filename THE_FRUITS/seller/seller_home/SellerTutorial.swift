//
//  Untitled.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI

struct SellerTutorial: View{
    let images = [
        "s1", "s2", "s3",
        "s4", "s5", "s6",
        "s7", "s8", "s9",
        "s10"
    ]
    
    @State private var currentPage = 0
    
    var body: some View{
        VStack{
            Spacer()
            HStack{
                //BackArrowButton(title: "")
                Spacer()
                Button(action: {
                    // Open the Hometax application
                    if let hometaxURL = URL(string: "hometax://") {
                        if UIApplication.shared.canOpenURL(hometaxURL) {
                            // Open the Hometax app
                            UIApplication.shared.open(hometaxURL, options: [:], completionHandler: nil)
                        } else if let appStoreURL = URL(string: "https://apps.apple.com/kr/app/%EA%B5%AD%EC%84%B8%EC%B2%AD-%ED%99%88%ED%83%9D%EC%8A%A4-%EC%86%90%ED%83%9D%EC%8A%A4/id495157796?l=en-GB") {
                            // If Hometax is not installed, open the App Store
                            UIApplication.shared.open(appStoreURL, options: [:], completionHandler: nil)
                        }
                    }
                }) {
                    Text("홈택스로 바로가기")
                        .font(.headline)
                        .padding() // Add some padding inside the button
                        .frame(width: 200, height: 40) // Set a fixed size for the button
                        .background(Color.lightGreen) // Background color
                        .foregroundColor(.white) // Text color
                        .cornerRadius(15) // Rounded corners
                        .multilineTextAlignment(.center) // Center the text in the button
                }
            }
            Spacer()
            Text("사업자 번호 등록 가이드")
                .font(.title2)
                .bold()
                .padding(.leading)
            Spacer().frame(height: 20)
            
            TabView(selection: $currentPage) {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFit()
                    //.clipped()
                        .tag(index) // Tag for tracking the current page
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic)) // Use page tab style
            .frame(width: 350, height: 600)
            
            HStack(spacing: 5) {
                ForEach(0..<images.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentPage ? Color.black : Color.gray) // Black for current page, gray for others
                        .frame(width: 10, height: 10) // Size of the bullet
                }
            }
            .padding(.top, 10) // Padding for the indicator
            Spacer()
            
            NavigationLink(destination: SellerInsertBusinessNum()){
                HStack{
                    Spacer()
                    Text("사업자 번호 입력하기")
                        .font(.title2)
                        .foregroundColor(.black)
                    Image(systemName: "arrow.right")
                        .font(.title2)
                        .foregroundColor(.black)
                }
            }
            .padding(.top, 20)
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    SellerTutorial()
}
