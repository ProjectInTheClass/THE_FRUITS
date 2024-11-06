//
//  SellerFixBrand.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/6/24.
//

import SwiftUI

// should contain already uploaded info
struct SellerEditBrand: View{
    @State private var brandName: String = ""
    @State private var brandLogo: String = ""
    @State private var brandThumbnail: String = ""
    @State private var brandInfo: String = ""
    @State private var brandFruits: [String] = []
    @State private var brandBank: String = ""
    @State private var brandAccount: String = ""
    @State private var brandAddress: String = ""
    
    @State private var selectedTab = 0
    @State private var isBankListPresented = false // bottom sheet for bank
    
    var body: some View{
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // brand name
                Text("브랜드 이름")
                HStack {
                    TextField("브랜드 입력", text: $brandName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
                    Button(action: {
                        checkBrandNameRedundancy() // check name's redundancy
                    }) {
                        Text("중복 확인")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color("darkGreen"))
                            .cornerRadius(8)
                    }
                }
                
                // brand logo & thubmnail image
                HStack(spacing: 50) {
                    VStack {
                        Text("브랜드 로고 이미지")
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            )
                    }
                    
                    VStack {
                        Text("브랜드 배경 이미지")
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                // brand info
                VStack(alignment: .leading) {
                    Text("브랜드 소개")
                    TextField("브랜드를 소개해주세요!", text: $brandInfo)
                        .padding()
                        .frame(height: 100)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                
                InputField(title: "대표과일 등록", placeholder: "대표과일을 3개 등록해주세요.")
                
                Group{
                    Text("거래 은행 등록")
                    ZStack { // to make it clickable for the whole space of textfield
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .background(Color.white)
                            .onTapGesture {
                                isBankListPresented = true
                            }
                        TextField("은행을 선택해주세요.", text: $brandBank)
                            .disabled(true) // disable direct input
                            .padding()
                            .foregroundColor(.black)
                    }
                    .frame(height: 40)
                }
                .sheet(isPresented: $isBankListPresented) { // bottom sheet with bank list
                    BankListView(selectedBank: $brandBank)
                        .presentationDetents([.medium])
                        .presentationDragIndicator(.visible)
                }
                
                InputField(title: "거래 계좌 등록", placeholder: "계좌번호를 입력해주세요.", text: $brandAccount)
                InputField(title: "주소 입력", placeholder: "발송지 주소를 입력해주세요.", text: $brandAddress)
                
                Spacer()
                
                NavigationLink(destination: SellerRootView(selectedTab: $selectedTab).navigationBarBackButtonHidden(true)) {
                    Text("수정하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .sheet(isPresented: $isBankListPresented) { // bottom sheet with bank list
            BankListView(selectedBank: $brandBank)
        }
    }
    
    func checkBrandNameRedundancy() {
        // checking for brand name redundancy
        
    }
}

#Preview {
    SellerEditBrand()
}
