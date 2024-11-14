//
//  Stepper.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/22/24.
//

import SwiftUI

struct CustomStepper: View {
    @Binding var f_count : Int

    var body: some View {
        HStack{
            Button(action:{
                if f_count>0{
                    f_count-=1
                    print("Minus button tapped, f_count: \(f_count)")
                }
            }){
                Image(systemName: "minus")
                    .frame(width:44,height:44)
                    .foregroundColor(.black)
                
            }
            Text("\(f_count)")
                .frame(width:50,alignment: .center)
                .font(.system(size:20,weight:.regular))
            
            Button(action:{
                    f_count+=1
                print("Plus button tapped, f_count: \(f_count)")
            }){
                Image(systemName: "plus")
                    .frame(width:44,height:44)
                    .foregroundStyle(.black)
            }
        }
        .frame(width:115,height:8)
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.black,lineWidth: 2)
        )
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    StatefulPreviewWrapper(0) { CustomStepper(f_count: $0) }
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
