//
//  ProductRow.swift
//  THE_FRUITS
//
//  Created by 김진주 on 12/5/24.
//

import SwiftUI

struct ProductRow: View {
    @ObservedObject var product: ProductItem

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: product.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 170, height: 170)
                    .cornerRadius(8)
            } placeholder: {
                Color.gray.opacity(0.2)
                    .frame(width: 170, height: 170)
                    .cornerRadius(8)
            }

            VStack(alignment: .leading) {
                Text(product.name)
                    .font(.headline)
                Text("\(product.price)원")
                    .font(.subheadline)
                    .foregroundColor(.black)
                CustomStepper(f_count: $product.f_count, width: 110, height: 22, strokeColor: Color("darkGreen"))
            }
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

