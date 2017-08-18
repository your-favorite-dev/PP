//
//  RecordingViewController.swift
//  PitchPerfec
//
//  Created by Romear, Andrew on 7/31/17.
//  Copyright © 2017 AppVile. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController {
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    let audioRecorder = AudioRecorder()
    let util = Util()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleRecording(startRecording: false)
        util.changeButtonAspect(buttons: recordButton,stopRecordingButton)
        
    }
    
    @IBAction func recordVoice(_ sender: Any) {
        toggleRecording(startRecording: true)
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        toggleRecording(startRecording: false)
    }
    
    func toggleRecording(startRecording: Bool) {
        recordButton.isEnabled = !startRecording
        stopRecordingButton.isEnabled = startRecording
        recordingLabel.text = startRecording ? "Press Stop" : "Press Record"
        
        if startRecording {
            audioRecorder.recordAudio(self)
        } else {
            audioRecorder.stopRecord(self)
        }
    }

    func segueToPlaySounds(){
        performSegue(withIdentifier: "recordAudio", sender: audioRecorder.recorder.url)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "recordAudio"){
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
            
        }
        
        
    }
    

}

