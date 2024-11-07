//
//  BackTest.swift
//  THE_FRUITS
//
//  Created by 김진주 on 11/5/24.
//

import SwiftUI

struct BackTest: View {
    @StateObject private var firestoreManager=FireStoreManager()
    var body: some View {
        VStack(alignment:.leading,spacing:10){
            Text("Name: \(firestoreManager.name)")
            Text("Username: \(firestoreManager.username)")
            Text("Password: \(firestoreManager.password)")
        }
        .onAppear{
            firestoreManager.fetchData()
        }
        .padding()
        .font(.headline)
    }
}

#Preview {
    BackTest()
}
