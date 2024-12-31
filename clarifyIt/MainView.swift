//
//  ContentView.swift
//  clarifyIt
//
//  Created by Alanoud Abaalkhail on 14/06/1446 AH.
//


import SwiftUI
import SwiftData

struct MainView: View {
    
    //@Query var dataModel: [DataModel]
    @Query(sort:\ DataModel.name) var dataModel: [DataModel]
    
    
    @State private var isSheetPresented = false
    
    var body: some View {
        NavigationView {

            VStack( spacing: 10) {
                VStack (alignment: .trailing) {
                    ZStack(alignment: .topTrailing){
                        
                        // Gear icon
                        NavigationLink(destination: SettingsView(user: dataModel.first ??  DataModel(name: "", selectedLanguage: "", understandingLevel: ""))) {
                            Button(action: {
                                
                                self.isSheetPresented = true
                            },label: {
                                Image(systemName: "gearshape.2.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.purple1)
                                    .padding()
                                    .background(Circle().fill(Color.gray1).frame(width: 45, height: 45))
                                    .padding(10)
                            })
                            
                        }
                        .sheet(isPresented: $isSheetPresented) {
                            SettingsView(user: dataModel.first ?? DataModel(name: "", selectedLanguage: "", understandingLevel: ""))
                        }
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 8) {
//                            MARK: Edit double couts like this \(
                            Text("Hi (datModel.first!.name) 👋")
                                .font(.custom("SF Pro Text", size: 24)).fontWeight(.semibold)
                            
                            Text("Nice to see you again, let’s learn!")
                                .font(.custom("SF Pro Text", size: 16))
                                .fontWeight(.semibold)
                        }
                        Spacer()
                        
                    }
                    .padding(.horizontal)
                }
                
                // Progress Section
                HStack {
                    NavigationLink(destination: Streak()) {
                        VStack {
                            // "See all" button in top-right
                            
                            Text("See all")
                                .font(.custom("SF Pro Text", size: 12))
                                .fontWeight(.semibold)
                                .foregroundColor(.purple1)
                                .padding(.leading, 300)
                                .padding(.top,10)
                            
                            // Content with Divider
                            HStack(alignment: .center, spacing: 20) {
                                Text("100 🔥")
                                    .font(.custom("SF Pro Text", size: 32))
                                
                                Divider()
                                    .frame(width: 1, height: 71)
                                    .background(Color.purple1)
                                    .padding(.bottom, 10)
                                
                                Text("🥉")
                                    .font(.custom("SF Pro Text", size: 40))
                            }
                        }
                        .padding(.bottom)
                    }
                    
                }
                .padding(.horizontal, 15)
                .background(Color.gray1).cornerRadius(12)
                
                Spacer()
                
                // What do you want to learn today?
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("What do you want to learn today?") .font(.custom("SF Pro Text", size: 20))
                        .fontWeight(.medium)
                    ScrollView(.horizontal){
                        HStack(spacing: 20) {
                            LearnCategoryView(emoji: "📚", title: "Academic")
                            LearnCategoryView(emoji: "📜", title: "Literature")
                            LearnCategoryView(emoji: "📰", title: "General")
                            Circle()
                                .fill(Color.gray1)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.purple1)
                                        .font(.system(size: 20))
                                )
                        }
                    }
                }
                .padding(.horizontal)
                Spacer()
                
                // Add Your Word Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Do you want to learn specific term?")
                        .font(.custom("SF Pro Text", size: 20))
                        .fontWeight(.medium)
                    
                    NavigationLink(destination: AddWordView()) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.gray1)
                                .frame(height: 66)
                            Text("Add your word")
                                .font(.custom("SF Pro Text", size: 24))
                                .fontWeight(.semibold)
                                .foregroundColor(.accent)
                        }
                    }.padding(10)
                }
                .padding(.horizontal)
                Spacer()
                
                // Practice More Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Let’s practice more")
                        .font(.custom("SF Pro Text", size: 20))
                        .fontWeight(.medium)
                    
                    
                    HStack {
                        NavigationLink(destination: DailyQuizView()){
                            Image(systemName: "pencil.and.list.clipboard")
                                .font(.system(size: 24)).foregroundColor(.purple1)
                            VStack(alignment: .leading) {
                                Text("Daily Quiz")
                                    .font(.custom("SF Pro Text", size: 24))
                                    .fontWeight(.regular)
                                    .foregroundColor(.black1)
                                
                                Text("sentences & matching")
                                    .font(.custom("SF Pro Text", size: 12))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray3)
                            }
                            Spacer()
                            
                            Circle()
                                .fill(Color.gray7)
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.purple1)
                                        .font(.system(size: 20))
                                )
                        }
                    }
                    .padding(.horizontal)
                    .frame(width: 350, height: 102)
                    .background(Color.gray1)
                    .cornerRadius(12)
                    
                    
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding(.horizontal, 5)
            .padding(.top)
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
}

struct LearnCategoryView: View {
    var emoji: String
    var title: String
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(Color.gray1)
                    .frame(width: 86, height: 86)
                
                Text(emoji)
                    .font(.custom("SF Pro Text", size: 32))
            }
            Text(title)
                .font(.custom("SF Pro Text", size: 14))
        }
    }
}



#Preview {
    MainView()
}
