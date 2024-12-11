//
//  SellerAddBrand.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 10/31/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct SellerAddBrand: View{
    var body: some View{
        VStack{
            Spacer()
            Text("사업자 등록증이 있으신가요?")
                .font(.title)
                .bold()
                .padding()
            
            Spacer().frame(height: 30)
            
            NavigationLink(destination: SellerInsertBusinessNum().navigationBarBackButtonHidden(true)){
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.black)
                    .frame(width: 350, height: 60)
                    .overlay(
                        Text("예")
                            .foregroundColor(.white)
                    )
            }
            
            Spacer().frame(height: 20)
            
            NavigationLink(destination: SellerTutorial().navigationBarBackButtonHidden(true)){
                RoundedRectangle(cornerRadius: 50)
                    .stroke(Color.black, lineWidth: 1)
                    .frame(width: 350, height: 60)
                    .overlay(
                        Text("아니오")
                            .foregroundColor(.black)
                    )
            }
            Spacer()
        }
    }
}

struct SellerInsertBusinessNum: View{
    @State private var businessNum: String = ""
    @State private var selectedTab = 0
        
    var body: some View{
            VStack{
                BackArrowButton(title: "")
                Spacer()
                Text("사업자 등록번호를 입력해주세요!")
                    .font(.system(size: 25))
                    .bold()
                    .padding()
                
                HStack{
                    TextField("사업자 등록번호", text: $businessNum)
                        .padding()
                        .frame(width: 300)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .stroke(Color.gray, lineWidth: 1) // Border for the rounded rectangle
                        )
                        //.padding() // Padding around the TextField
                        .textFieldStyle(PlainTextFieldStyle())
                    
                    /*NavigationLink(destination: SellerRootView(selectedTab: $selectedTab).navigationBarBackButtonHidden(true)) {
                        Image(systemName: "arrow.right") // Arrow icon
                            .font(.title2) // Adjust size as needed
                            .foregroundColor(.black) // Color of the icon
                            .frame(width: 40, height: 40)
                    }*/
                    NavigationLink(destination: SellerBrandInfo(businessNum: $businessNum)){
                        Image(systemName: "arrow.right") // Arrow icon
                            .font(.title2) // Adjust size as needed
                            .foregroundColor(.black) // Color of the icon
                            .frame(width: 40, height: 40)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding()
                Spacer()
            }
            .padding()
    }
}

struct SellerBrandInfo: View{
    @EnvironmentObject var firestoreManager: FireStoreManager
    
    @State private var brandName: String = ""
    @State private var brandLogo: String = ""
    @State private var brandSlogan: String = ""
    @State private var brandThumbnail: String = ""
    @State private var brandInfo: String = ""
    @State private var brandFruits: [String] = ["", "", ""]
    @State private var brandBank: String = ""
    @State private var brandAccount: String = ""
    @State private var brandAddress: String = ""
    @State private var brandPhone: String = ""
    @State private var brandNotification: String = ""
    @State private var brandPurchaseNotice: String = ""
    @State private var brandReturnPolicy: String = ""
    
    @State private var brandLogoImageData: Data? = nil
    @State private var brandThumbnailImageData: Data? = nil
    
    @State private var selectedTab = 0
    @State private var isBankListPresented = false // bottom sheet for bank
    
    // for modal sheet
    @State private var isModalPresented = false
    @State private var shouldNavigate = false
    
    @State private var isBrandNameDuplicate = false
    @State private var showDuplicateAlert = false
    
    @Binding var businessNum: String
    
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
                            if isBrandNameDuplicate {
                                brandName = ""
                            }
                            isBrandNameDuplicate = false
                        })
                    )
                }
                
                // brand logo & thubmnail image
                HStack(spacing: 50) {
                    /*VStack {
                        Text("브랜드 로고 이미지")
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            )
                    }*/
                    
                    /*VStack {
                        Text("브랜드 배경 이미지")
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 100, height: 100)
                            .overlay(
                                Image(systemName: "plus")
                                    .font(.largeTitle)
                                    .foregroundColor(.gray)
                            )
                    }*/
                    UploadImageField(title: "브랜드 로고 이미지", imageUrl: $brandLogo, imageData: $brandLogoImageData, id: "logo")
                    UploadImageField(title: "브랜드 배경 이미지", imageUrl: $brandThumbnail, imageData: $brandThumbnailImageData, id: "thumbnail")
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                VStack(alignment: .leading) {
                    Text("브랜드 슬로건")
                    TextField("브랜드 슬로건을 써주세요!", text: $brandSlogan)
                        .padding()
                        .frame(height: 100)
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                }
                
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
                
                //InputField(title: "대표과일 등록", placeholder: "대표과일을 3개 등록해주세요.")
                
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
                
                Button(action: {
                    Task {
                        await saveBrand()
                        isModalPresented = true // 모달창 표시
                    }
                }) {
                    Text("등록하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert("등록되었습니다.", isPresented: $isModalPresented, actions: {
                    Button("확인", role: .cancel) { isModalPresented = false; shouldNavigate = true }
                })
                
                /*Text("등록하기")
                 .frame(maxWidth: .infinity)
                 .padding()
                 .background(Color("darkGreen"))
                 .foregroundColor(.white)
                 .cornerRadius(10)*/
                
                NavigationLink(
                    destination: SellerRootView(selectedTab: $selectedTab).navigationBarBackButtonHidden(true),
                    isActive: $shouldNavigate,
                    label: { EmptyView() }
                )
            }
            .padding()
        }
        .sheet(isPresented: $isBankListPresented) { // bottom sheet with bank list
            BankListView(selectedBank: $brandBank)
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
                        // Brand name exists
                        isBrandNameDuplicate = true
                        showDuplicateAlert = true
                    } else {
                        // Brand name does not exist
                        isBrandNameDuplicate = false
                        showDuplicateAlert = true
                    }
                }
            }
    }
    
    func saveBrand() async {
        // Upload logo if selected
        do{
            if let logoData = brandLogoImageData {
                brandLogo = try await uploadImage(imageData: logoData, path: "images/logos/\(UUID().uuidString).jpg")
            }
            
            // Upload thumbnail if selected
            if let thumbnailData = brandThumbnailImageData {
                brandThumbnail = try await uploadImage(imageData: thumbnailData, path: "images/thumbnails/\(UUID().uuidString).jpg")
            }
            let brandModel = BrandModel(
                brandid: "0",
                sellerid: FireStoreManager().sellerid,
                info: brandInfo,
                name: brandName,
                logo: brandLogo,
                thumbnail: brandThumbnail,
                slogan: brandSlogan,
                likes: 0,
                orders: [],
                createdAt: Timestamp(date: Date()),
                productid: [],
                account: brandAccount,
                bank: brandBank,
                deliverycost: 0,
                sigtype: brandFruits,
                phone: brandPhone,
                address: brandAddress,
                businessnum: businessNum,
                notification: brandNotification,
                purchase_notice: brandPurchaseNotice,
                return_policy: brandReturnPolicy
            )
            
            try await firestoreManager.addBrand(brand: brandModel)
            isModalPresented = true
            
        } catch {
            // Handle error (you can print the error or show an alert)
            print("Error saving brand: \(error)")
        }
    }
}

func uploadImage(imageData: Data, path: String) async throws -> String {
    let storageRef = Storage.storage().reference().child(path)
    
    _ = try await storageRef.putDataAsync(imageData)
    let downloadURL = try await storageRef.downloadURL()
    print("uploaded image!")
    return downloadURL.absoluteString
    
}

struct BankListView: View {
    @Binding var selectedBank: String
    @Environment(\.presentationMode) var presentationMode
    
    let banks = [
        "카카오뱅크",
        "국민은행",
        "기업은행",
        "농협은행",
        "신한은행",
        "산업은행",
        "우리은행",
        "한국씨티은행",
        "하나은행",
        "SC제일은행",
        "경남은행",
        "광주은행",
        "대구은행",
        "도이치은행",
        "뱅크오브아메리카",
        "부산은행",
        "산립조합중앙회",
        "저축은행"
    ]
    
    var body: some View {
        VStack {
            Text("은행 선택")
                .font(.headline)
                .padding()
            
            List(banks, id: \.self) { bank in
                HStack {
                    Text(bank)
                    Spacer()
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    selectedBank = bank // Update selected bank
                    print("Chosen bank: \(selectedBank)")
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

struct InputField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    init(title: String, placeholder: String, text: Binding<String> = .constant("")) {
        self.title = title
        self.placeholder = placeholder
        self._text = text
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
            TextField(placeholder, text: $text)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
        }
    }
}

#Preview {
    SellerAddBrand()
        .environmentObject(FireStoreManager())
}
