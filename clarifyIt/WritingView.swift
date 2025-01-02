import SwiftUI

struct WritingView: View {
    var word: String // Variable to hold the passed word
    @State private var sentence: String = "" // User input sentence
    @State private var analysisResult: String? = nil
    @State private var isAnalysisMode: Bool = false
    @State private var showAlert: Bool = false // To control alert visibility
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @State private var isActive = false

    var body: some View {
        VStack {
            // Back Button
            HStack {
                if !isAnalysisMode {
                Button(action: {
                    presentationMode.wrappedValue.dismiss() // Dismiss to the previous view
                }) {
                    
                }}
                
                Spacer()
            }
            .padding()

            // Title Text
            Text(isAnalysisMode ? "The Analysis of the Sentence" : "Put the Word in a Sentence")
                .font(.system(size: 24, weight: .medium))
                .multilineTextAlignment(.center)
                .padding()

            // Word Text
            if !isAnalysisMode {
                Text(word)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color("PurpleMatch"))
                    .multilineTextAlignment(.center)
                    .padding()
            }

            // Input area or analysis result
            if isAnalysisMode {
                ScrollView {
                    Text(analysisResult ?? "No analysis available.")
                        .font(.system(size: 20, weight: .regular))
                        .foregroundColor(Color.black)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("PurpleMatch"), lineWidth: 4)
                        )
                        .padding()
                }
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("purple 3"))
                    .frame(width: UIScreen.main.bounds.width - 70, height: 376)
                    .background(Color.purple3.opacity(0.03))
                    .overlay(
                        TextField("Write Here...", text: $sentence)
                            .padding(.bottom , 280)
                            .padding()
                            .foregroundColor(.black)
                    )
                    .padding()
            }

            // Buttons
            if isAnalysisMode {
                HStack(spacing: 20) {
                    // Try Again Button
                    Button(action: {
                        // Action for Try Again
                        isAnalysisMode = false
                        sentence = ""
                    }) {
                        Text("Try Again")
                            .font(.custom("SF Pro Display", size: 27))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 180, height: 70)
                            .background(Color("PurpleMatch"))
                            .cornerRadius(15)
                    }
                    
                    // Done Button
                    NavigationLink(destination: MainView(), isActive: $isActive) {
                        Button(action: {
                            dismiss()
                            isActive = true
                        }, label: {
                            Text("Done")
                                .font(.custom("SF Pro Display", size: 27))
                                .fontWeight(.medium)
                                .foregroundColor(Color("PurpleMatch"))
                                .padding()
                                .frame(width: 180, height: 70)
                                .background(.white)
                                .cornerRadius(15)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 15)
                                        .stroke(Color("PurpleMatch"), lineWidth: 2)
                                )
                        })
                    }
                }
//                    NavigationLink(destination: MainView()) {
                        
//                        Text("Done")
//                            .font(.custom("SF Pro Display", size: 27))
//                            .fontWeight(.medium)
//                            .foregroundColor(Color("PurpleMatch"))
//                            .padding()
//                            .frame(width: 180, height: 70)
//                            .background(.white)
//                            .cornerRadius(15)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 15)
//                                    .stroke(Color("PurpleMatch"), lineWidth: 2)
//                                )
                           
//                    }
                
                .padding(.bottom)

            } else {
                Button(action: {
                    if sentence.lowercased().contains(word.lowercased()) {
                        checkSentence()
                    } else {
                        showAlert = true // Show alert if word is not in the sentence
                    }
                }) {
                    Text("Check")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: UIScreen.main.bounds.width - 70, minHeight: 66)
                        .background(Color("PurpleMatch"))
                        .cornerRadius(12)
                }
                .padding()
            }
        }
        .background(Color.white)
        .navigationBarTitleDisplayMode(.inline)
        
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Word Not Found"),
                message: Text("Your sentence must include the word '\(word)'"),
                dismissButton: .default(Text("OK"))
            )
        }
        .navigationBarBackButtonHidden(true)
    }

    private func checkSentence() {
        let apiService = APIService()
        let prompt = """
        Analyze the following sentence: "\(sentence)"
        - Does the sentence use the word "\(word)" correctly?
        - If there are mistakes, explain them and suggest corrections.
        - Provide an improved version of the sentence, if needed.
        - do not use bold font
        """

        
        apiService.fetchWordDetails(word: prompt) { result in
            DispatchQueue.main.async {
                if let result = result {
                    processAnalysisResult(result)
                } else {
                    analysisResult = "An error occurred. Please try again."
                }
            }
        }
    }

    private func processAnalysisResult(_ result: String) {
        // Clean and format the API response
        var cleanedResult = result
        let unwantedHeaders = [
               "Analysis of.*?:",
               "Was correct.*?:",
               "Mistake.*?:",
               "Corrected.*?:",
           ] // Headers to remove
        
        for header in unwantedHeaders {
            cleanedResult = cleanedResult.replacingOccurrences(of: header, with: "")
        }
        
        analysisResult = cleanedResult.trimmingCharacters(in: .whitespacesAndNewlines)
        isAnalysisMode = true
    }
}

#Preview {
    WritingView(word: "Example")
}
