//
//  AudioRecorder.swift
//  PitchPerfect
//
//  Created by Romear, Andrew on 8/11/17.
//  Copyright © 2017 AppVile. All rights reserved.
//

import Foundation
import AVFoundation


class AudioRecorder: NSObject, AVAudioRecorderDelegate {
    var recorder: AVAudioRecorder!
    var recorderController: RecordingViewController!
    

    
    func recordAudio(_ sender: AnyObject) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
        
        try! recorder = AVAudioRecorder(url: filePath!, settings: [:])
        recorder.delegate = self
        recorder.isMeteringEnabled = true
        recorder.prepareToRecord()
        recorder.record()
    }
    
    func stopRecord(_ sender: RecordingViewController){
        if(recorder != nil){
            recorder.delegate = self
            recorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
            recorderController = sender
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            recorderController.segueToPlaySounds()
        }else {
            print("recording not successful")
        }
    }
    

    
}
