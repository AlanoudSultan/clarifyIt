//
//  AnalysisView.swift
//  clarifyIt
//
//  Created by Alanoud Abaalkhail on 18/06/1446 AH.
//

import SwiftUI

struct AnalysisView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack{
                
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
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
                Text("The Analysis of the sentence")
                    .font(.system(size: 24, weight: .medium))
                    .multilineTextAlignment(.center)
                    .padding()
                
                
               .padding()
                
                HStack{
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("PurpleMatch"), lineWidth: 4)
                        .frame(width: UIScreen.main.bounds.width - 70, height: 458)

                            .overlay(
                                Text("An engine roaring is dynamic, but an embrace of power suggests warmth or gentleness, which contrasts with the raw roared. ")
                                .font(.system(size: 20, weight: .regular))
                                .frame(width: 290)
                                .foregroundColor(Color.black)
                                .padding([.top, .leading], 30) // Padding to move the text to the top-left
                                , alignment: .topLeading // Align the text to the top-left
                                
                            )
                    
                }
                
                .padding()

                Spacer()
                
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true) // Hide default back button to use custom button
        }
    }
}

#Preview {
    AnalysisView()
}
