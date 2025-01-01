import SwiftUI
import SwiftData

struct MainView: View {
    @State private var progress = 0.0  // Initial progress set to 0%
    @State private var totalWords = 10 // Total words to learn
    @State private var wordsLearned: Int = 0
    
    @Query(sort:\ DataModel.name) var dataModel: [DataModel]
    
    @State private var isSheetPresented = false
    
    struct LearnCategoryView: View {
        var emoji: String
        var title: String
        
        var body: some View {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.gray1)
                        .frame(width: 137, height: 138)
                        .cornerRadius(12)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        Text(emoji)
                            .font(.custom("SF Pro Text", size: 40))
                        
                        Text(title)
                            .font(.custom("SF Pro Text", size: 16))
                            .fontWeight(.semibold)
                            .foregroundColor(.accent)
                    }
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical){
                VStack (spacing: 0) {
                    ZStack(alignment: .topTrailing) {
                        // Gear icon
                        NavigationLink(destination: SettingsView(user: dataModel.first ?? DataModel(name: "", selectedLanguage: "", understandingLevel: ""))) {
                            Button(action: {
                                self.isSheetPresented = true
                            }, label: {
                                Image(systemName: "gearshape.2.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(.purple1)
                                    .padding()
                                    .background(Circle().fill(Color.gray1).frame(width: 45, height: 45))
                                    .padding(10)
                            })
                        }
                        Spacer()
                            .padding(.leading)
                            .sheet(isPresented: $isSheetPresented) {
                                SettingsView(user: dataModel.first ?? DataModel(name: "", selectedLanguage: "", understandingLevel: ""))
                            }
                    }
                    
                    VStack(spacing: 30) {
                        // Progress Section
                        HStack {
                            VStack(alignment: .leading, spacing: 0) {
                                Image("happy")
                                    .resizable()
                                    .frame(width: 138, height: 134)
                                    .cornerRadius(12)
                                    .padding(.leading, 8)
                            }
                            Spacer()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Hi Rama 👋")
                                    .font(.custom("SF Pro Text", size: 24))
                                    .fontWeight(.regular)
                                
                                Text("You’re doing great! \n Keep learning")
                                    .multilineTextAlignment(.leading)
                                    .font(.custom("SF Pro Text", size: 14))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray8)
                                
                                ProgressView(value: progress, total: 1) // Normalized progress (0 to 1)
                                    .progressViewStyle(LinearProgressViewStyle())
                                
                                Text("You have learned \(wordsLearned) words")
                                    .multilineTextAlignment(.leading)
                                    .font(.custom("SF Pro Text", size: 14))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.gray8)
                            }
                            .padding(.horizontal, 10)
                        }
                        .padding(.horizontal, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.purple5.opacity(0.12))
                                .frame(width: 350, height: 138)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.purple1, lineWidth: 0.5)
                                )
                        )
                        .onChange(of: progress) { newProgress in
                            // Dynamically update words learned based on progress
                            wordsLearned = Int(newProgress * Double(totalWords))
                            print("Updated progress in MainView: \(newProgress)")  // Debugging
                        }
                    
                        // Word of the Day Section
                        NavigationLink(destination: WordOfTheDayView(progress: $progress)) {  // Pass progress here
                            VStack(alignment: .leading, spacing: 20) {
                                Text("What do you want to learn today?")
                                    .font(.custom("SF Pro Text", size: 20))
                                    .fontWeight(.medium)
                                    .foregroundColor(.black1)
                                
                                ScrollView(.horizontal) {
                                    HStack(spacing: 16) {
                                        LearnCategoryView(emoji: "📚", title: "Academic Words")
                                        LearnCategoryView(emoji: "📜", title: "Literature Words")
                                        LearnCategoryView(emoji: "📰", title: "General Words")
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                        
                        // Add Your Word Section
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Do you want to learn specific term?")
                                .font(.custom("SF Pro Text", size: 20))
                                .fontWeight(.medium)
                                .foregroundColor(.black1)
                            
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
                        VStack(alignment: .leading, spacing: 20) {
                            Text("Let’s practice more")
                                .font(.custom("SF Pro Text", size: 20))
                                .fontWeight(.medium)
                            
                            HStack {
                                NavigationLink(destination: DailyQuizView()) {
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
                }
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}
