//
//  GBC.swift
//  GBCDeltaCore
//
//  Created by Riley Testut on 4/11/17.
//  Copyright © 2017 Riley Testut. All rights reserved.
//

import Foundation
import AVFoundation

import DeltaCore
import DeltaTypes
@_exported import GBCSwift
@_exported import GBCBridge

public struct GBC: DeltaCoreProtocol {
    public static let core = GBC()
    
    public var name: String { "GBCDeltaCore" }
    public var identifier: String { "com.rileytestut.GBCDeltaCore" }
    
    public var gameType: GameType { .gbc }
    public var gameInputType: Input.Type { GBCGameInput.self }
    public var gameSaveFileExtension: String { "sav" }
    
    public let audioFormat = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: 35112 * 60, channels: 2, interleaved: true)!
    public let videoFormat = VideoFormat(format: .bitmap(.bgra8), dimensions: CGSize(width: 160, height: 144))
    
    public var supportedCheatFormats: Set<CheatFormat> {
        let gameGenieFormat = CheatFormat(name: NSLocalizedString("Game Genie", comment: ""), format: "XXX-YYY-ZZZ", type: .gameGenie)
        let gameSharkFormat = CheatFormat(name: NSLocalizedString("GameShark", comment: ""), format: "XXXXXXXX", type: .gameShark)
        return [gameGenieFormat, gameSharkFormat]
    }
    
    public var emulatorBridge: EmulatorBridging { GBCEmulatorBridge.shared as! EmulatorBridging }
    
    private init() {}
}

extension GBCGameInput: Input {
    public var type: InputType {
        return .game(.gbc)
    }
}
