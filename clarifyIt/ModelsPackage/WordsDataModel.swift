//
//  WordsDataModel.swift
//  clarifyIt
//
//  Created by Nahed Almutairi on 22/06/1446 AH.
//

import Foundation

struct WordsData: Codable {
    let literature: [Word]
    let academic: [Word]
    let general: [Word]
}
