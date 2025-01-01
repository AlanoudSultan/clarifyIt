//
//  clarifyItApp.swift
//  clarifyIt
//
//  Created by Alanoud Abaalkhail on 14/06/1446 AH.
//

import SwiftUI

@main
struct clarifyItApp: App {
    @AppStorage("hasLaunchedBefore") private var hasLaunchedBefore: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if hasLaunchedBefore {
                MainView(selectedCategory: "")
                        } else {
                            ContentView()
                        }
//            ContentView(DataModel: DataModel())
          //  ContentView()
            
        }.modelContainer(for: [DataModel.self])
    }
}
