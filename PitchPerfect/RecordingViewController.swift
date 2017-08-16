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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toggleButtonDisabled(stopRecordingButton)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func recordVoice(_ sender: Any) {
        toggleButtonDisabled(recordButton)
        toggleButtonEnabled(stopRecordingButton)
        toggleLabel(recordingLabel)
        audioRecorder.recordAudio(self)
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        toggleButtonDisabled(stopRecordingButton)
        toggleButtonEnabled(recordButton)
        toggleLabel(recordingLabel)
        audioRecorder.stopRecord(self)
    }
    
    
    func toggleButtonEnabled(_ button: UIButton){
        button.isEnabled = true;
    }
    func toggleButtonDisabled(_ button: UIButton){
        button.isEnabled = false;
    }
    func toggleLabel(_ label: UILabel){
        if(label.text == "Press Record"){
            label.text = "Press Stop"
        }else{
            label.text = "Press Record"
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

