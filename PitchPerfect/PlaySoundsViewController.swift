//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Romear, Andrew on 8/11/17.
//  Copyright © 2017 AppVile. All rights reserved.
//

import UIKit

class PlaySoundsViewController: UIViewController {
    @IBOutlet weak var slowButton: UIButton!
    @IBOutlet weak var fastButton: UIButton!
    @IBOutlet weak var highPitchButton: UIButton!
    @IBOutlet weak var lowPitchButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    var audioPlayer = AudioPlayer()
    
    struct AudioProperties {
        static let SlowRate: Float = 0.5
        static let FastRate: Float = 1.5
        static let HighPitch: Float = 1000
        static let LowPitch: Float = -1000
    }
  
    
    @IBAction func playSoundForButton(_ sender: UIButton){
        switch(AudioPlayer.ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: AudioProperties.SlowRate)
        case .fast:
            playSound(rate: AudioProperties.FastRate)
        case .highPitch:
            playSound(pitch: AudioProperties.HighPitch)
        case .lowPitch:
            playSound(pitch: AudioProperties.LowPitch)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction func stopButtonPressed(_ sender: AnyObject){
        stopAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }

}
