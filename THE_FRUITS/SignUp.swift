//
//  SignUp.swift
//  THE_FRUITS
//
//  Created by Bada Hong on 12/12/24.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpCustomer: View {
    @State private var name = ""
    @State private var password = ""
    @State private var username = ""
    @State private var phone = ""
    @State private var address = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var password_ck = ""
    
    @State private var isUsernameDuplicate = false
    @State private var showDuplicateAlert = false
    
    @State private var navigateToLogin = false
    
    @State private var isModalPresented = false
    @State private var shouldNavigate = false
    @State private var allowed = false
    @State private var isForDup = false
    
    @Environment(\.dismiss) var dismiss
    
    let db = Firestore.firestore()
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                Text("회원가입")
                    .font(.title)
                Text("메일")
                HStack {
                    TextField("메일을 입력해주세요", text: $username)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
                    Button(action: {
                        checkMailRedundancy() // check name's redundancy
                    }) {
                        Text("중복확인")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color("darkGreen"))
                            .cornerRadius(8)
                    }
                }
                
                if showDuplicateAlert {
                    Text(errorMessage)
                        .foregroundColor(isUsernameDuplicate ? .red : .darkGreen)
                        .font(.caption)
                        .padding(.top, -10)
                }
                
                Text("비밀번호")
                SecureField("비밀번호를 6자 이상 입력해주세요", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .textContentType(.password)
                
                Text("비밀번호 확인")
                SecureField("비밀번호를 다시 입력해주세요", text: $password_ck)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .textContentType(.password)
                
                if password != password_ck {
                    Text("비밀번호가 일치하지 않습니다.")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, -10)
                }
                
                Text("이름")
                TextField("이름을 입력해주세요", text: $name)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                Text("전화번호")
                TextField("휴대폰 번호를 입력해주세요 ('-' 제외)", text: $phone)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                Text("주소")
                TextField("정확한 주소를 입력해주세요", text: $address)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                Button(action: {
                    checkMailRedundancy()  // Ensure mail is checked
                    
                    if username.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty || address.isEmpty {
                        errorMessage = "모든 필드를 입력해주세요."
                        allowed = false
                        //showError = true
                        isModalPresented = true
                        return
                    }
                    
                    if password.count < 6 {
                        errorMessage = "비밀번호는 6자 이상이어야 합니다."
                        allowed = false
                        //showError = true
                        isModalPresented = true
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if !isUsernameDuplicate {
                            signUp()
                            errorMessage = "등록되었습니다."
                            allowed = true
                            isModalPresented = true
                            dismiss()
                        }
                    }
                    
                    //signUp()
                    //isModalPresented = true // 모달창 표시
                }) {
                    Text("회원가입 하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(errorMessage, isPresented: $isModalPresented, actions: {
                    Button("확인", role: .cancel) {
                        if allowed{
                            isModalPresented = false;
                            isForDup = false;
                            shouldNavigate = true
                        }else{
                            isModalPresented = false;
                            isForDup = false;
                            shouldNavigate = false
                        }
                    }
                })
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
    
    func signUp() {
        if isUsernameDuplicate {
            errorMessage = "중복된 메일입니다. 다른 메일을 입력해주세요."
            showError = true
            return
        }
        
        Auth.auth().createUser(withEmail: username, password: password) { result, error in
            if let error = error {
                //self.showError = true
                //self.errorMessage = "회원가입 실패: \(error.localizedDescription)"
                return
            }
            
            guard let user = result?.user else { return }
            let uid = user.uid
            
            // Save user details to Firestore
            let customerData: [String: Any] = [
                "customerid": uid,
                "username": username,
                "name": name,
                "password": password,
                "phone": phone,
                "address": address,
                "orders": [],
                "likebrand": []
            ]
            
            db.collection("customer").document(uid).setData(customerData) { error in
                if let error = error {
                    self.showError = true
                    self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    return
                } else {
                    print("User successfully saved.")
                    // Navigate to appropriate screen
                }
                
                // Create Cart Subcollection
                let cartRef = db.collection("customer").document(uid).collection("cart").document()
                let cartid = cartRef.documentID
                let cartData: [String: Any] = [
                    "brandid": "",
                    "cartid": cartid,  // Use Firestore-generated cart ID
                    "orderprodid": [] // Initialize as an empty array
                ]
                
                db.collection("customer").document(uid).updateData(["cartid": cartid])
                
                cartRef.setData(cartData) { error in
                    if let error = error {
                        self.showError = true
                        self.errorMessage = "장바구니 생성 실패: \(error.localizedDescription)"
                    } else {
                        print("회원가입 성공 및 장바구니 생성 완료")
                        isModalPresented = true
                    }
                }
            }
        }
    }
    
    func checkMailRedundancy() {
        let db = Firestore.firestore()
        
        // Query the `brand` collection where `name` equals the user's input
        db.collection("customer").whereField("username", isEqualTo: username)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    errorMessage = "중복 확인 오류: \(error.localizedDescription)"
                    showError = true
                } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                    isUsernameDuplicate = true
                    errorMessage = "이미 사용 중인 메일입니다."
                    showDuplicateAlert = true
                } else {
                    isUsernameDuplicate = false
                    errorMessage = "사용 가능한 메일입니다."
                    showDuplicateAlert = true
                }
            }
        isForDup = true
    }
}


struct SignUpSeller: View {
    @State private var name = ""
    @State private var password = ""
    @State private var username = ""
    @State private var phone = ""
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var password_ck = ""
    
    @State private var isUsernameDuplicate = false
    @State private var showDuplicateAlert = false
    
    @State private var navigateToLogin = false
    
    @State private var isModalPresented = false
    @State private var shouldNavigate = false
    @State private var allowed = false
    @State private var isForDup = false
    
    @Environment(\.dismiss) var dismiss
    
    let db = Firestore.firestore()
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 20) {
                Text("회원가입")
                    .font(.title)
                Text("메일")
                HStack {
                    TextField("메일을 입력해주세요", text: $username)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    
                    Button(action: {
                        checkMailRedundancy() // check name's redundancy
                    }) {
                        Text("중복확인")
                            .foregroundColor(.white)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color("darkGreen"))
                            .cornerRadius(8)
                    }
                }
                
                if showDuplicateAlert {
                    Text(errorMessage)
                        .foregroundColor(isUsernameDuplicate ? .red : .darkGreen)
                        .font(.caption)
                        .padding(.top, -10)
                }
                
                Text("비밀번호")
                SecureField("비밀번호를 6자 이상 입력해주세요", text: $password)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .textContentType(.password)
                
                Text("비밀번호 확인")
                SecureField("비밀번호를 다시 입력해주세요", text: $password_ck)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                    .textContentType(.password)
                
                if password != password_ck {
                    Text("비밀번호가 일치하지 않습니다.")
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, -10)
                }
                
                Text("이름")
                TextField("이름을 입력해주세요", text: $name)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                Text("전화번호")
                TextField("휴대폰 번호를 입력해주세요 ('-' 제외)", text: $phone)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 1))
                
                Button(action: {
                    checkMailRedundancy()  // Ensure mail is checked
                    
                    if username.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty {
                        errorMessage = "모든 필드를 입력해주세요."
                        allowed = false
                        //showError = true
                        isModalPresented = true
                        return
                    }
                    
                    if password.count < 6 {
                        errorMessage = "비밀번호는 6자 이상이어야 합니다."
                        allowed = false
                        //showError = true
                        isModalPresented = true
                        return
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        if !isUsernameDuplicate {
                            signUp()
                            errorMessage = "등록되었습니다."
                            allowed = true
                            isModalPresented = true
                            dismiss()
                        }
                    }
                    
                    //signUp()
                    //isModalPresented = true // 모달창 표시
                }) {
                    Text("회원가입 하기")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("darkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .alert(errorMessage, isPresented: $isModalPresented, actions: {
                    Button("확인", role: .cancel) {
                        if allowed{
                            isModalPresented = false;
                            isForDup = false;
                            shouldNavigate = true
                        }else{
                            isModalPresented = false;
                            isForDup = false;
                            shouldNavigate = false
                        }
                    }
                })
                
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
    }
    
    func signUp() {
        if isUsernameDuplicate {
            errorMessage = "중복된 메일입니다. 다른 메일을 입력해주세요."
            showError = true
            return
        }
        
        Auth.auth().createUser(withEmail: username, password: password) { result, error in
            if let error = error {
                //self.showError = true
                //self.errorMessage = "회원가입 실패: \(error.localizedDescription)"
                return
            }
            
            guard let user = result?.user else { return }
            let uid = user.uid
            
            // Save user details to Firestore
            let sellerData: [String: Any] = [
                "sellerid": uid,
                "username": username,
                "name": name,
                "password": password,
                "phone": phone,
                "brands": []
            ]
            
            db.collection("seller").document(uid).setData(sellerData) { error in
                if let error = error {
                    self.showError = true
                    self.errorMessage = "Failed to save user data: \(error.localizedDescription)"
                    return
                } else {
                    print("User successfully saved.")
                    isModalPresented = true
                    // Navigate to appropriate screen
                }
            }
        }
    }
    
    func checkMailRedundancy() {
        let db = Firestore.firestore()
        
        // Query the `brand` collection where `name` equals the user's input
        db.collection("seller").whereField("username", isEqualTo: username)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    errorMessage = "중복 확인 오류: \(error.localizedDescription)"
                    showError = true
                } else if let documents = querySnapshot?.documents, !documents.isEmpty {
                    isUsernameDuplicate = true
                    errorMessage = "이미 사용 중인 메일입니다."
                    showDuplicateAlert = true
                } else {
                    isUsernameDuplicate = false
                    errorMessage = "사용 가능한 메일입니다."
                    showDuplicateAlert = true
                }
            }
        isForDup = true
    }
}
