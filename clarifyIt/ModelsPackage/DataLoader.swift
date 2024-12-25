//
//  DataLoader.swift
//  clarifyIt
//
//  Created by Nahed Almutairi on 23/06/1446 AH.
//

import Foundation

class DataLoader: ObservableObject{
    @Published var literature: [Word] = []
    @Published var academic: [Word] = []
    @Published var general: [Word] = []
    
    init(){
        loadData()
    }
    
    func loadData(){
        guard let url = Bundle.main.url(forResource: "words", withExtension: "json")
        else {
            print("json file not found")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(WordsData.self, from: data)

            DispatchQueue.main.async {
                self.literature = decodedData.Literature
                self.academic = decodedData.Academic
                self.general = decodedData.General
            }
        } catch {
            print("Error decoding JSON: \(error)")
        }

    }
}
