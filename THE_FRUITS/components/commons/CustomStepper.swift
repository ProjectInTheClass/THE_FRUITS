//
//  Stepper.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/22/24.
//

import SwiftUI

struct CustomStepper: View {
    @State private var f_count = 1
    var body: some View {
        HStack{
            Button(action:{
                if f_count>0{
                    f_count-=1
                }
            }){
                Image(systemName: "minus")
                    .frame(width:44,height:44)
                    .foregroundColor(.black)
            }
            Text("\(f_count)")
                .frame(width:50,alignment: .center)
                .font(.system(size:24,weight:.medium))
            
            Button(action:{
                    f_count+=1
            }){
                Image(systemName: "plus")
                    .frame(width:44,height:44)
                    .foregroundStyle(.black)
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black,lineWidth: 2)
        )
        .accessibilityElement(children: .combine)
            }
}

#Preview {
    CustomStepper()
}
