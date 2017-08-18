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
    let audioPlayer = AudioPlayer()
    let util = Util()
    
    struct AudioProperties {
        static let slowRate: Float = 0.5
        static let fastRate: Float = 1.5
        static let highPitch: Float = 1000
        static let lowPitch: Float = -1000
    }
  
    
    @IBAction func playSoundForButton(_ sender: UIButton){
        switch(AudioPlayer.ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: AudioProperties.slowRate)
        case .fast:
            playSound(rate: AudioProperties.fastRate)
        case .highPitch:
            playSound(pitch: AudioProperties.highPitch)
        case .lowPitch:
            playSound(pitch: AudioProperties.lowPitch)
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
        util.changeButtonAspect(buttons: slowButton, fastButton,
                                highPitchButton, lowPitchButton,
                                echoButton, reverbButton,stopButton)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
    

}
