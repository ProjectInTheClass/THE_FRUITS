//
//  CartToolbar.swift
//  THE_FRUITS
//
//  Created by 김진주 on 12/4/24.
//

import SwiftUI


struct CartToolbar: View {
    @Binding var navigateToCart: Bool
    var body: some View {
        HStack{
            Spacer()
            Button(action:{
                navigateToCart=true
            })
            {
                Image(systemName: "cart")
                    .font(.title3)
                    .foregroundColor(.black)
            }
        }
        
    }
}


