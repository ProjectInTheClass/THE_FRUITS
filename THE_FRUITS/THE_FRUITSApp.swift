//
//  THE_FRUITSApp.swift
//  THE_FRUITS
//
//  Created by 김진주 on 10/13/24.
//
import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct THE_FRUITSApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject private var firestoreManager = FireStoreManager()
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            OnBoarding()
            //CustomerRootView()
                .environmentObject(firestoreManager)
            
        }
    }
}
