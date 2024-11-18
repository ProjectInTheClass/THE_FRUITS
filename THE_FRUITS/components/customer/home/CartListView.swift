import SwiftUI

struct CartListView: View {
    @EnvironmentObject var products: ObservableProducts

    var body: some View {
        VStack {
            Text("장바구니")
                .font(.title)
                .padding()

            ScrollView {
                VStack(spacing: 16) {
                    ForEach(Array(products.items.enumerated()), id: \.1.id) { index, item in
                        CartItemView(
                            itemName: $products.items[index].name,
                            price: $products.items[index].price,
                            f_count: $products.items[index].f_count
                            
                        )
                    }
                }
                .padding()
            }

            Button(action: {
                print("구매하기")
            }) {
                Text("바로 구매하기")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("darkGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
        }
        .presentationDetents([.fraction(0.4), .large])
    }
}
