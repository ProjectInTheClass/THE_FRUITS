//
//  SellerFixBrand.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 11/6/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import PhotosUI

// should contain already uploaded info
struct SellerEditBrand: View{
    @State var brand: BrandModel
    @EnvironmentObject var firestoreManager: FireStoreManager
    
    @State private var brandName: String = ""
    @State private var brandLogo: String = ""
    @State private var brandThumbnail: String = ""
    @State private var brandInfo: String = ""
    @State private var brandFruits: [String] = ["", "", ""]
    @State private var brandBank: String = ""
    @State private var brandAccount: String = ""
    @State private var brandAddress: String = ""
    
    @State private var brandLogoData: Data? = nil
    @State private var brandThumbnailData: Data? = nil
    
    @State private var selectedTab = 0
    @State private var isBankListPresented = false // bottom sheet for bank
    
    @State private var isBrandNameDuplicate = false
    @State private var showDuplicateAlert = false
    
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
                .alert(isPresented: $showDuplicateAlert) {
                    Alert(
                        title: Text(isBrandNameDuplicate ? "중복된 브랜드 이름" : "사용 가능한 브랜드 이름"),
                        message: Text(isBrandNameDuplicate ? "\(brandName)은 이미 등록된 브랜드 이름입니다." : "\(brandName)은 사용 가능합니다."),
                        dismissButton: .default(Text("확인"), action: {
                            if isBrandNameDuplicate{
                                brandName = ""
                            }
                            isBrandNameDuplicate = false
                        })
                    )
                }
                
                // brand logo & thubmnail image
                /*HStack(spacing: 50) {
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
                 .frame(maxWidth: .infinity, alignment: .center)*/
                
                HStack(spacing: 50) {
                    UploadImageField(title: "브랜드 로고 이미지", imageUrl: $brandLogo, imageData: $brandLogoData, id: brand.brandid)
                    UploadImageField(title: "브랜드 배경 이미지", imageUrl: $brandThumbnail, imageData: $brandThumbnailData, id: brand.brandid)
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
                
                VStack(alignment: .leading){
                    Text("대표과일 등록")
                    Text("대표과일을 3개 등록해주세요. (ex. 사과 오렌지)")
                        .font(.caption)
                    HStack{
                        ForEach(0..<3, id: \.self) { index in
                            TextField("과일 \(index + 1)", text: $brandFruits[index])
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                        }
                    }
                }
                
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
                
                Button(action: {
                    updateBrandInFirebase()
                    // Navigate after the action
                    selectedTab = 1 // Set the tab you want to navigate to, if applicable
                }) {
                    NavigationLink(
                        destination: SellerBrandMainPage(brand: brand)
                            .navigationBarBackButtonHidden(true)
                    ) {
                        Text("수정하기")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("darkGreen"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .sheet(isPresented: $isBankListPresented) { // bottom sheet with bank list
            BankListView(selectedBank: $brandBank)
        }
        .onAppear {
            Task {
                await loadBrandData()
            }
        }
    }
    
    func checkBrandNameRedundancy() {
        let db = Firestore.firestore()
        
        // Query the `brand` collection where `name` equals the user's input
        db.collection("brand").whereField("name", isEqualTo: brandName)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    print("Error checking brand name: \(error)")
                } else {
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        if brand.name != brandName{
                            // Brand name exists
                            isBrandNameDuplicate = true
                            showDuplicateAlert = true
                        }
                    } else {
                        // Brand name does not exist
                        isBrandNameDuplicate = false
                        showDuplicateAlert = true
                    }
                }
            }
    }
    
    func loadBrandData() async {
        do {
            let brand: BrandEditModel = try await firestoreManager.fetchBrandDetails(brandId: brand.brandid)
            brandName = brand.name
            brandLogo = brand.logo
            brandThumbnail = brand.thumbnail
            brandFruits = brand.sigtype
            brandInfo = brand.info
            brandBank = brand.bank
            brandAccount = brand.account
            brandAddress = brand.address
        } catch {
            print("Error loading brand data: \(error)")
        }
    }
    
    func updateBrandInFirebase() {
        Task {
            do {
                // Step 1: Upload images first
                let logoURL = try await uploadImageToFirebase(imageData: brandLogoData, fieldName: "logo")
                let thumbnailURL = try await uploadImageToFirebase(imageData: brandThumbnailData, fieldName: "thumbnail")
                
                // Step 2: Update Firestore with the new image URLs and brand data
                let updatedBrand = BrandEditModel(
                    brandid: brand.brandid,
                    name: brandName,
                    logo: logoURL,
                    thumbnail: thumbnailURL,
                    info: brandInfo,
                    sigtype: brandFruits,
                    bank: brandBank,
                    account: brandAccount,
                    address: brandAddress
                )
                
                try await firestoreManager.updateBrand(brand: updatedBrand)
                print("Brand updated successfully")
                
            } catch {
                print("Error updating brand: \(error)")
            }
        }
    }
}

func uploadImageToFirebase(imageData: Data?, fieldName: String) async throws -> String {
    guard let imageData = imageData else { throw NSError(domain: "No image data", code: 1) }

    let storageRef = Storage.storage().reference().child("images/\(UUID().uuidString).jpg")
    let _ = try await storageRef.putDataAsync(imageData)
    let downloadURL = try await storageRef.downloadURL()
    return downloadURL.absoluteString
}

struct UploadImageField: View {
    let title: String
    @Binding var imageUrl: String
    @Binding var imageData: Data?
    @State private var selectedItem: PhotosPickerItem? = nil
    @State var id: String
    
    var body: some View {
        VStack {
            Text(title)
            ZStack{
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 100, height: 100)
                    .overlay(
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "plus")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                        }
                    )
                    .clipped()
                
                PhotosPicker(selection: $selectedItem, matching: .images) {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 100, height: 100)
                        .background(Color.white).opacity(0.3)
                        .overlay(
                            Image(systemName: "plus")
                                .font(.system(size: 60))
                                .foregroundColor(Color.black)
                        )
                    /*Text("이미지 선택")
                        .foregroundColor(.black)
                        .font(.caption)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(Color.lightGray)
                        .cornerRadius(8)*/
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            self.imageData = data
                        }
                    }
                }
            }
        }
    }
    
}
