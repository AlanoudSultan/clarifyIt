

//
//  ContentView.swift
//  clarifyIt
//
//  Created by Alanoud Abaalkhail on 14/06/1446 AH.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    var body: some View {
       // ZStack{
            if showSplash {
                Splash()
                    .onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { showSplash = false } }
            } else {
                VStack {
                    Image(systemName: "globe")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                    Text("hiii, world!")
                }
            }
      //  }
        
     //   .padding()
    }
}

#Preview {
    ContentView()
}
