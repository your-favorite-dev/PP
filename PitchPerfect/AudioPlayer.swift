//
//  AudioPlayer.swift
//  PitchPerfect
//
//  Created by Romear, Andrew on 8/14/17.
//  Copyright © 2017 AppVile. All rights reserved.
//

import UIKit
import AVFoundation

class AudioPlayer: NSObject {
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    enum ButtonType: Int {
        case slow = 0, fast, highPitch, lowPitch, echo, reverb
    }

}
