
//
//  Streak.swift
//  clarifyIt
//
//  Created by Nujud Abdullah on 19/06/1446 AH.
//

import SwiftUI

struct Streak: View {
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button(action: {
                        // Action
                    }) {
                        HStack {
                            Image(systemName: "chevron.backward")
                                .bold()
                            Text("Back")
                        }
                    }
                    .padding(.leading, 20)
                    Spacer()
                }
                .padding(.top, 20)
                
                Spacer()
                
                Text("Your daily Rewards")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 650)
                
                
            }
        }
    }
}

#Preview {
    Streak()
}

