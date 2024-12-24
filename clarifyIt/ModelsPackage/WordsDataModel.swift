//
//  WordsDataModel.swift
//  clarifyIt
//
//  Created by Nahed Almutairi on 22/06/1446 AH.
//

import Foundation

struct WordsData: Codable {
    let Literature: [Word]
    let Academic: [Word]
    let General: [Word]
}
