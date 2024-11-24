import SwiftUI

struct CustomStepper: View {
    @Binding var f_count: Int
    var width: CGFloat
    var height: CGFloat
    //@Binding var initialValue: Int
    var strokeColor: Color // stroke 컬러를 전달받을 변수 추가



    var body: some View {
        HStack(spacing: 0) { // 간격을 완전히 없앰
            // Minus Button
            Button(action: {
                if f_count > 0 {
                    f_count -= 1
                    print("Minus button tapped, f_count: \(f_count)")
                }
            }) {
                Image(systemName: "minus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: height * 0.3, height: height * 0.3) // 버튼 크기 조정
                    .foregroundColor(.black)
            }

            // Count Text
            Text("\(f_count)")
                .frame(width: width, height: height)
                .font(.system(size: height * 0.5, weight: .regular)) // 높이에 비례한 폰트 크기
                .multilineTextAlignment(.center)

            // Plus Button
            Button(action: {
                f_count += 1
                print("Plus button tapped, f_count: \(f_count)")
            }) {
                Image(systemName: "plus")
                    .resizable()
                    .scaledToFit()
                    .frame(width: height * 0.3, height: height * 0.3) // 버튼 크기 조정
                    .foregroundColor(.black)
            }
        }
        .padding(8)
        .frame(width: width + height * 2, height: height) // 텍스트와 버튼을 포함하는 크기 설정
        .background(
            RoundedRectangle(cornerRadius: height / 2)
                .stroke(strokeColor, lineWidth: 2)
                .fill(Color.white.opacity(0.7)) // 배경에 하얀색과 투명도 적용
        )
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    StatefulPreviewWrapper(0) { CustomStepper(f_count: $0, width: 80, height: 40,strokeColor: .black) }
}

// StatefulPreviewWrapper: 상태를 관리할 수 있는 래퍼 구조체
struct StatefulPreviewWrapper<Value>: View {
    @State private var value: Value
    private var content: (Binding<Value>) -> AnyView

    init(_ initialValue: Value, @ViewBuilder content: @escaping (Binding<Value>) -> CustomStepper) {
        self._value = State(initialValue: initialValue)
        self.content = { binding in AnyView(content(binding)) }
    }

    var body: some View {
        content($value)
    }
}
