//
//  BrandButton.swift
//  THE_FRUITS
//
//  Created by 박지은 on 12/5/24.
//
import SwiftUI

struct BrandButton: View {
    var brand: BrandModel? // 외부에서 주입받는 브랜드 데이터
    @State private var navigateToBrandHome: Bool = false // 네비게이션 상태 관리
    @State private var brandLikes: Int = 0 // 기본값 설정

    var body: some View {
        VStack {
            if let brand {
                // 숨겨진 NavigationLink
                NavigationLink(
                    destination: BrandHome(brand: brand, storeLikes: $brandLikes), // Binding 전달
                    isActive: $navigateToBrandHome // 상태에 따라 네비게이션 실행
                ) {
                    EmptyView() // NavigationLink를 숨기기 위해 사용
                }
                .hidden()

                // 버튼
                CustomButton(
                    title: "\(brand.name)",
                    background: Color("darkGreen"),
                    foregroundColor: .white,
                    width: 80,
                    height: 33,
                    size: 14,
                    cornerRadius: 3,
                    action: {
                        print("\(brand.name) clicked")
                        navigateToBrandHome = true // 버튼 클릭 시 네비게이션 활성화
                    }
                )
            } else {
                Text("Loading brand name...")
            }
        }
        .onAppear {
            if let brand = brand {
                brandLikes = brand.likes // 브랜드 좋아요 수 초기화
            }
        }
    }
}
