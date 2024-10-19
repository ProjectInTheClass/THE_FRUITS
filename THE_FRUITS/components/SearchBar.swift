import SwiftUI

// 공통 서치바 컴포넌트
struct SearchBar: View {
    @Binding var searchText: String  // 검색 텍스트를 바인딩으로 받아서 외부에서 관리할 수 있게 함
    
    var placeholder: String = "검색어를 입력하세요"  // 기본 플레이스홀더
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(UIColor.systemGray2))  // 돋보기 아이콘 색상
            
            TextField(placeholder, text: $searchText)
                .padding(6)
                .background(Color(UIColor.systemGray6))  // 서치바 배경색
                .cornerRadius(20)
                .foregroundColor(.gray)  // 텍스트 색상
        }
        .frame(width: 330, height: 45)  // 서치바의 너비와 높이를 조절
        .padding(.horizontal)  // 양옆 여백 추가
        .background(Color(UIColor.systemGray6))  // 서치바 배경색
        .cornerRadius(20)
    }
}
