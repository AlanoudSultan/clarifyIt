

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @State private var name = ""
    @State private var selectedLanguage = ""
    
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    @AppStorage("userName") private var userName: String = ""
    @AppStorage("userLanguage") private var userLanguage: String = ""
    
    var body: some View {
        ZStack {
            NavigationView {
                if showSplash {
                    Splash()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                showSplash = false
                            }
                        }
                } else {
                    if !hasLaunchedBefore {
                        VStack {
                            Text("What's your name?")
                                .font(.system(size: 24))
                                .fontWeight(.semibold)
                                .foregroundColor(.splashT)
                                .padding(.trailing, 150)
                                .padding(5)
                            
                            TextField(" Write your name ", text: $name)
                                .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                                .padding(.horizontal, 20)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color.purple3, lineWidth: 0.5)
                                )
                                .keyboardType(.default)
                            Spacer().frame(height: 15)
                            
                            Text("Choose your learning language")
                                .font(.system(size: 24))
                                .fontWeight(.semibold)
                                .foregroundColor(.splashT)
                                .padding(.trailing, 10)
                                .padding(5)
                            
                            VStack(spacing: 15) {
                                Button(action: {
                                    selectedLanguage = "English"
                                }) {
                                    Text("English 🇺🇸")
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.trailing, 230)
                                        .padding()
                                        .background(selectedLanguage == "English" ? Color.purple3.opacity(0.2) : Color.clear)
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.purple3, lineWidth: 0.5)
                                        )
                                }
                                .padding(.horizontal, 10)
                                
                                Button(action: {
                                    selectedLanguage = "Arabic"
                                }) {
                                    Text("Arabic 🇸🇦")
                                        .foregroundColor(.primary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.trailing, 230)
                                        .padding()
                                        .background(selectedLanguage == "Arabic" ? Color.purple3.opacity(0.2) : Color.clear)
                                        .cornerRadius(15)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color.purple3, lineWidth: 0.5)
                                        )
                                }
                                .padding(.horizontal, 10)
                            }
                            .padding(.bottom, 200)
                            
                            Button(action: {
                                userName = name
                                userLanguage = selectedLanguage
                                hasLaunchedBefore = true
                            }) {
                                Text("Get Started")
                                    .frame(width: UIScreen.main.bounds.width - 60, height: 50)
                                    .font(.custom("SFProText-Medium", size: 24))
                                    .foregroundColor(.white)
                                    .background(Color.splashT)
                                    .cornerRadius(12)
                                    .padding(.top, 100)
                            }
                        }
                        .onAppear {
                            if name.isEmpty && selectedLanguage.isEmpty {
                                name = userName
                                selectedLanguage = userLanguage
                            }
                        }
                    } else {
                        MainView()
                            .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
