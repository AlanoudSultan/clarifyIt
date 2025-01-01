//
//  DataModel.swift
//  clarifyIt
//
//  Created by Ghadah Alhagbani on 22/06/1446 AH.
//

import SwiftData
import SwiftUI


//class DataModel: ObservableObject {
//    
//    @Published var name: String = ""
//    @Published var selectedLanguage: String = ""
//    //[String: [String]] = [:]
//}
@Model

class DataModel {
    
    var name: String = ""
    var selectedLanguage: String = ""
    var understandingLevel: String = ""
//    var selectedCatgory: String? = nil

    init(name: String, selectedLanguage: String, understandingLevel: String) {
        self.name = name
        self.selectedLanguage = selectedLanguage
        self.understandingLevel = understandingLevel
//        self.selectedCatgory = selectedCatgory
    }
    
    //[String: [String]] = [:]
    
    //
    
    // Factory method for dummy data
}
