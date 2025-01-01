//
//
//import SwiftUI
//
//struct Streak: View {
//    @State private var wordsLearned = 2
//    private let totalWords = 5
//    @State private var streak: Int = 0
//    @State private var lastUsedDate: Date?
//    //  Array to represent each day in the streak
//    @State private var streakDays: [Bool] = [false, false, false, false]
//
//    //  Load streak data on initialization
//    init() {
//        if let savedStreak = UserDefaults.standard.object(forKey: "userStreak") as? Int {
//            streak = savedStreak
//        }
//        if let savedLastUsedDate = UserDefaults.standard.object(forKey: "lastUsedDate") as? Date {
//            lastUsedDate = savedLastUsedDate
//        }
//        if let savedStreakDays = UserDefaults.standard.object(forKey: "streakDays") as? [Bool] {
//            streakDays = savedStreakDays
//        }
//    }
//    
//    var body: some View {
//        NavigationView {
//            ZStack {
//                VStack {
//                    HStack {
////                        NavigationLink(destination: MainView()) {                        }
////                        .padding(.leading, 20)
////                        Spacer()
//                    }
//                    .padding(.top, 20)
//                    
//                    Text("Your daily Rewards")
//                        .font(.largeTitle)
//                        .fontWeight(.semibold)
//                        .padding(50)
//                    
//                    // First GroupBox: Streak days with fading fire emoji and day text
//                    ZStack {
//                        GroupBox {
//                            Spacer()
//                            
//                            HStack {
//                                ForEach(0..<streakDays.count, id: \.self) { dayIndex in
//                                    VStack {
//                                        Text("🔥")
//                                            .font(.title)
//                                            .opacity(streakDays[dayIndex] ? 1.0 : 0.3)
//                                        Text("Day \(dayIndex + 1)")
//                                            .opacity(streakDays[dayIndex] ? 1.0 : 0.3)
//                                    }
//                                    .padding()
//                                }
//                            }
//                            
//                            Divider()
//                                .padding(.vertical, 10)
//                            
//                            Text("Keep learning so your streak won’t reset!")
//                                .padding(.top, 10)
//                        }
//                        .frame(maxWidth: .infinity)
//                        .fixedSize(horizontal: false, vertical: true)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.bottom, 15)
//                    
//                    ZStack {
//                        GroupBox {
//                            Spacer()
//                            
//                            VStack {
//                                HStack {
//                                    VStack {
//                                        Text("🥉")
//                                            .font(.system(size: 60, weight: .regular))
//                                            .padding(5)
//                                        Text("You need to achieve 5 words to gain the next medal")
//                                        Divider()
//                                    }
//                                }
//                                
//                                ProgressView(value: Double(wordsLearned), total: Double(totalWords))
//                                    .progressViewStyle(LinearProgressViewStyle())
//                                    .padding()
//                                    .accentColor(.purple)
//                                
//                                Text("\(wordsLearned) / \(totalWords) words learned")
//                                    .font(.subheadline)
//                                    .padding(.top, 5)
//                            }
//                            
//                        }
//                        .frame(maxWidth: .infinity)
//                        .fixedSize(horizontal: false, vertical: true) //
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.bottom, 80)
//                }
//            }
//            .onAppear {
//                checkStreak()
//            }
//        }
//    }
//    
//    // Function to check if the user has a streak and update it
//    func checkStreak() {
//        let currentDate = Date()
//        
//        if let lastUsedDate = lastUsedDate {
//            // Compare last used date and current date
//            let calendar = Calendar.current
//            if calendar.isDateInYesterday(currentDate) {
//                // User used the app yesterday, continue streak
//                streak += 1
//                streakDays = updateStreakDays()
//            } else if !calendar.isDate(currentDate, inSameDayAs: lastUsedDate) {
//                // Streak reset (no activity today or yesterday)
//                streak = 1
//                streakDays = updateStreakDays()
//            }
//        } else {
//            // First time user
//            streak = 1
//            streakDays = updateStreakDays()
//        }
//        
//        // Update last used date to today
//        self.lastUsedDate = currentDate
//        UserDefaults.standard.set(streak, forKey: "userStreak")
//        UserDefaults.standard.set(currentDate, forKey: "lastUsedDate")
//        UserDefaults.standard.set(streakDays, forKey: "streakDays")
//    }
//    
//    // Function to update streak days array
//    func updateStreakDays() -> [Bool] {
//        var updatedDays = [Bool](repeating: false, count: 4)
//        
//        // Mark the last streak days as true (up to 4 days max)
//        for i in 0..<streak {
//            if i < updatedDays.count {
//                updatedDays[i] = true
//            }
//        }
//        
//        return updatedDays
//    }
//    
//    // Function to simulate the user marking words as learned
//    func updateStreak() {
//        wordsLearned += 1
//        checkStreak()
//    }
//}
//
//
//#Preview {
//    Streak()
//}
