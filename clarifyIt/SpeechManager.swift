//
//  SpeechManager.swift
//  clarifyIt
//
//  Created by Nahed Almutairi on 29/06/1446 AH.
//

import AVFoundation
import SwiftUI

class SpeechManager: NSObject, AVSpeechSynthesizerDelegate {
    @Binding var isSpeakerFull: Bool // Tracks whether the speaker is speaking

    init(isSpeakerFull: Binding<Bool>) {
        _isSpeakerFull = isSpeakerFull
    }

    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        isSpeakerFull = false
    }
}
