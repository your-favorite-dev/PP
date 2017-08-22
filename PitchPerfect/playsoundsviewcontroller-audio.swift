//
//  PlaySoundsViewController+Audio.swift
//  PitchPerfect
//
//  Copyright © 2016 Udacity. All rights reserved.
//

import UIKit
import AVFoundation

// MARK: - PlaySoundsViewController: AVAudioPlayerDelegate

extension PlaySoundsViewController: AVAudioPlayerDelegate {
    
    // MARK: PlayingState (raw values correspond to sender tags)
    
    enum PlayingState { case playing, notPlaying }
    
    // MARK: Audio Functions
    
    func setupAudio() {
        // initialize (recording) audio file
        do {
            audioPlayer.audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
        } catch {
            util.showAlert(Alerts.AudioFileError, message: String(describing: error), controller: self)
        }
    }
    
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        // initialize audio engine components
        audioPlayer.audioEngine = AVAudioEngine()
        
        // node for playing audio

        audioPlayer.audioPlayerNode = AVAudioPlayerNode()
        audioPlayer.audioEngine.attach(audioPlayer.audioPlayerNode)
        
        
        
        // node for adjusting rate/pitch
        let changeRatePitchNode = AVAudioUnitTimePitch()
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioPlayer.audioEngine.attach(changeRatePitchNode)
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho1)
        audioPlayer.audioEngine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.cathedral)
        reverbNode.wetDryMix = 50
        audioPlayer.audioEngine.attach(reverbNode)
        
        // connect nodes
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayer.audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioPlayer.audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayer.audioPlayerNode, changeRatePitchNode, echoNode, audioPlayer.audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayer.audioPlayerNode, changeRatePitchNode, reverbNode, audioPlayer.audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayer.audioPlayerNode, changeRatePitchNode, audioPlayer.audioEngine.outputNode)
        }
        
        // schedule to play and start the engine!
        audioPlayer.audioPlayerNode.stop()
        audioPlayer.audioPlayerNode.scheduleFile(audioPlayer.audioFile, at: nil) {
            
            var delayInSeconds: Double = 0
            
            if let lastRenderTime = self.audioPlayer.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayer.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                
                if let rate = rate {
                    delayInSeconds = Double(self.audioPlayer.audioFile.length - playerTime.sampleTime) / Double(self.audioPlayer.audioFile.processingFormat.sampleRate) / Double(rate)
                } else {
                    delayInSeconds = Double(self.audioPlayer.audioFile.length - playerTime.sampleTime) / Double(self.audioPlayer.audioFile.processingFormat.sampleRate)
                }
            }
            
            // schedule a stop timer for when audio finishes playing
            self.audioPlayer.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(PlaySoundsViewController.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.audioPlayer.stopTimer!, forMode: RunLoopMode.defaultRunLoopMode)
        }
        
        do {
            try audioPlayer.audioEngine.start()
        } catch {
            util.showAlert(Alerts.AudioEngineError, message: String(describing: error), controller: self)
            return
        }
        
        // play the recording!
        audioPlayer.audioPlayerNode.play()
    }
    
    func stopAudio() {
        
        if let audioPlayerNode = audioPlayer.audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let stopTimer = audioPlayer.stopTimer {
            stopTimer.invalidate()
        }
        
        configureUI(.notPlaying)
        
        if let audioEngine = audioPlayer.audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    // MARK: Connect List of Audio Nodes
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioPlayer.audioEngine.connect(nodes[x], to: nodes[x+1], format: audioPlayer.audioFile.processingFormat)
        }
    }
    
    // MARK: UI Functions
    
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            setPlayButtonsEnabled(false)
            stopButton.isEnabled = true
        case .notPlaying:
            setPlayButtonsEnabled(true)
            stopButton.isEnabled = false
        }
    }
    
    func setPlayButtonsEnabled(_ enabled: Bool) {
        slowButton.isEnabled = enabled
        highPitchButton.isEnabled = enabled
        fastButton.isEnabled = enabled
        lowPitchButton.isEnabled = enabled
        echoButton.isEnabled = enabled
        reverbButton.isEnabled = enabled
    }
    
    
}
