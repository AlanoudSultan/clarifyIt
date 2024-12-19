

//
//  Splash.swift
//  clarifyIt
//
//  Created by Nujud Abdullah on 16/06/1446 AH.
//

import SwiftUI

struct Splash: View {
    @State private var isActive = false
    @State private var scale: CGFloat = 1.0
    private let duration: Double = 2.0
    
    var body: some View {

            ZStack{
                LinearGradient(gradient: .init(colors: [Color.splashT, Color.splashB]), startPoint: .center, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack{
                    
                    Text("ClarifyIt")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.purpleSplash)
                        .padding(-20)
                    
                    Image("ClarifyIt")
                        .resizable()
                        .frame(width: 350, height: 350)
                        .scaleEffect(scale)
                        .onAppear{
                            withAnimation(.easeIn(duration: 1.5)) {
                                scale = 1.2} }
                    
                    Text("Feel free to ask and learn")
                        .font(.title)
                        .fontWeight(.regular)
                        .foregroundColor(.white)
                        .font(.system(size: 24))
                }
        }
    }
}
#Preview {
    Splash()
}
