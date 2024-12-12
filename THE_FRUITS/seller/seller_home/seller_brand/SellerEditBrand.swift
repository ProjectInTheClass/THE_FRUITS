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
    @Environment(\.dismiss) var dismiss
    
    @State private var brandName: String = ""
    @State private var brandLogo: String = ""
    @State private var brandThumbnail: String = ""
    @State private var brandInfo: String = ""
    @State private var brandFruits: [String] = ["", "", ""]
    @State private var brandBank: String = ""
    @State private var brandAccount: String = ""
    @State private var brandAddress: String = ""
    @State private var brandSlogan: String = ""
    @State private var brandNotification: String = ""
    @State private var brandReturnPolicy: String = ""
    @State private var brandPurchaseNotice: String = ""
    
    @State private var brandLogoData: Data? = nil
    @State private var brandThumbnailData: Data? = nil
    
    @State private var selectedTab = 0
    @State private var isBankListPresented = false // bottom sheet for bank
    
    @State private var isBrandNameDuplicate = false
    @State private var showDuplicateAlert = false
    @State private var isUpdated = false
    
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
                HStack(spacing: 50) {
                    UploadImageField(title: "브랜드 로고 이미지", imageUrl: $brandLogo, imageData: $brandLogoData, id: "logo")
                    UploadImageField(title: "브랜드 배경 이미지", imageUrl: $brandThumbnail, imageData: $brandThumbnailData, id: "thumbnail")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                // brand info
                VStack(alignment: .leading) {
                    Text("브랜드 슬로건")
                    TextField("브랜드 슬로건을 써주세요!", text: $brandSlogan)
                        .padding()
                        .frame(height: 100)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
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
                
                VStack(alignment: .leading) {
                    Text("상품고시정보")
                    TextField("상품고시정보를 입력해주세요!", text: $brandNotification)
                        .padding()
                        .frame(height: 100)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                VStack(alignment: .leading) {
                    Text("교환/반품/환불 안내 사항")
                    TextField("교환/반품/환불 안내 사항을 써주세요!", text: $brandReturnPolicy)
                        .padding()
                        .frame(height: 100)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                VStack(alignment: .leading) {
                    Text("구매 시 주의사항")
                    TextField("구매 시 주의사항을 써주세요!", text: $brandPurchaseNotice)
                        .padding()
                        .frame(height: 100)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                
                Spacer()
                
                /*Button(action: {
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
                }*/
                
                if isUpdated {
                    ProgressView("Updating...")
                }
                Button(action: {
                    Task {
                        await updateBrandInFirebase()
                        //isUpdated = true
                    }
                }) {
                    Text("수정하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                /*.navigationDestination(isPresented: $isUpdated) {
                    SellerBrandMainPage(brand: brand)
                        .navigationBarBackButtonHidden(true)
                }*/
            }
            .padding()
        }
        /*.sheet(isPresented: $isBankListPresented) { // bottom sheet with bank list
            BankListView(selectedBank: $brandBank)
        }*/
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
            brandSlogan = brand.slogan
            brandPurchaseNotice = brand.purchase_notice
            brandReturnPolicy = brand.return_policy
            brandNotification = brand.notification
            
        } catch {
            print("Error loading brand data: \(error)")
        }
    }
    
    func updateBrandInFirebase() async {
        isUpdated = true
        defer { isUpdated = false }
        Task {
            do {
                print("in update brand in firebase")
                
                // Delete existing logo if a new logo is being uploaded
                if let newLogoData = brandLogoData, !brandLogo.isEmpty {
                    try await deleteImageFromFirebaseStorage(urlString: brand.logo)
                }
                            
                            // Delete existing thumbnail if a new thumbnail is being uploaded
                if let newThumbnailData = brandThumbnailData, !brandThumbnail.isEmpty {
                    try await deleteImageFromFirebaseStorage(urlString: brand.thumbnail)
                }
                
                if let newLogoData = brandLogoData {
                    print("Uploading new logo...")
                    let uploadedLogo = try await uploadImageIfNeeded(data: newLogoData, path: "images/logos/\(UUID().uuidString).jpg")
                    brandLogo = uploadedLogo as? String ?? ""
                    print("Logo uploaded: \(brandLogo)")
                }
                
                if let newThumbnailData = brandThumbnailData {
                    print("Uploading new thumbnail...")
                    let uploadedThumbnail = try await uploadImageIfNeeded(data: newThumbnailData, path: "images/thumbnails/\(UUID().uuidString).jpg")
                    brandThumbnail = uploadedThumbnail as? String ?? ""
                }
                
                print("pass images")
                
                /*let logoURL = try await uploadImageToFirebase(imageData: brandLogoData, fieldName: "logo")
                 let thumbnailURL = try await uploadImageToFirebase(imageData: brandThumbnailData, fieldName: "thumbnail")*/
                
                // Step 2: Update Firestore with the new image URLs and brand data
                let updatedBrand = BrandEditModel(
                    brandid: brand.brandid,
                    name: brandName,
                    logo: brandLogo,
                    thumbnail: brandThumbnail,
                    info: brandInfo,
                    sigtype: brandFruits,
                    bank: brandBank,
                    account: brandAccount,
                    address: brandAddress,
                    slogan: brandSlogan,
                    notification: brandNotification,
                    purchase_notice:brandPurchaseNotice,
                    return_policy: brandReturnPolicy
                )
                
                brand.name = brandName
                brand.thumbnail = brandThumbnail
                brand.logo = brandLogo
                brand.info = brandInfo
                brand.sigtype = brandFruits
                brand.bank = brandBank
                brand.account = brandAccount
                brand.address = brandAddress
                brand.slogan = brandSlogan
                brand.notification = brandNotification
                brand.purchase_notice = brandPurchaseNotice
                brand.return_policy = brandReturnPolicy
                
                
                try await firestoreManager.updateBrand(brand: updatedBrand)
                print("Brand updated successfully")
                dismiss()
                
            } catch {
                print("Error updating brand: \(error)")
            }
        }
    }
}

func uploadImageIfNeeded(data: Data?, path: String) async throws -> String? {
    guard let imageData = data else { return nil }
    return try await uploadImage(imageData: imageData, path: path)
}

func deleteImageFromFirebaseStorage(urlString: String) async throws {
    guard let url = URL(string: urlString) else {
        print("Invalid URL for image deletion")
        return
    }
    
    // Extract the file path from the download URL
    let storage = Storage.storage()
    let storageRef = storage.reference(forURL: urlString)
    
    do {
        try await storageRef.delete()
        print("Successfully deleted image: \(urlString)")
    } catch {
        print("Error deleting image: \(error)")
    }
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
                        Group {
                            if let data = imageData, let uiImage = UIImage(data: data) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } else if let url = URL(string: imageUrl) {
                                AsyncImage(url: url) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    Image(systemName: "plus")
                                        .font(.largeTitle)
                                        .foregroundColor(.gray)
                                }
                            } else {
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            }
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
                }
                .onChange(of: selectedItem) { newItem in
                    Task {
                        do {
                            if let data = try await newItem?.loadTransferable(type: Data.self) {
                                self.imageData = data
                                print("input - Image selected, size: \(data.count) bytes")
                            }
                        } catch {
                            print("Error loading image: \(error.localizedDescription)") // Debugging error message
                        }
                    }
                }
            }
        }
    }
    
}
