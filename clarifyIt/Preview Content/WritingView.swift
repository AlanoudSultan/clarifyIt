//
//  WritingView.swift
//  clarifyIt
//
//  Created by Alanoud Abaalkhail on 18/06/1446 AH.
//

import SwiftUI

struct WritingView: View {
    var body: some View {
        NavigationView{
            VStack{
                
                HStack {
                    Button(action: {
                        // Handle the back action
                        print("Back button tapped")
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .heavy))
                            .foregroundColor(Color("PurpleMatch"))
                        
                        Text("Back")
                            .font(.system(size: 24, weight: .regular)) // Bold text
                        .foregroundColor(Color("PurpleMatch"))
                    }
                    
                    Spacer()
                                        
                }
                
               .padding()
         
                
                // Title Text
                Text("Put the word in a sentence")
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding()
                
                // Word Text
                Text("Embrace")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(Color("PurpleMatch"))
                    .multilineTextAlignment(.center)
                    .padding()
                
                HStack{
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("purple 3"))
                            .frame(width: UIScreen.main.bounds.width - 70, height: 376)
                            .background(Color.purple3.opacity(0.03))
                    
                            .overlay(
                                Text("Write Here..")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color.gray3)
                                .padding([.top, .leading], 30) // Padding to move the text to the top-left
                                , alignment: .topLeading // Align the text to the top-left
                                
                            )
                    
                }
                
                .padding()

                
                
                // Check Button
                Button(action: {
                    // Action when "Check" is pressed
                    print("Check button tapped")
                }) {
                    Text("Check")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: UIScreen.main.bounds.width - 70 , minHeight: 66)
                        .background(Color("PurpleMatch"))
                        .cornerRadius(12)
                }
                .padding()

            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide default back button to use custom button
        }
    }
}

#Preview {
    WritingView()
}
