//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Alsuhaibani on 07/11/2018.
//  Copyright © 2018 Alsuhaibani. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate{

    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
       stopRecordingButton.isEnabled = false
    }
    var audioRecorder: AVAudioRecorder!
    
    @IBAction func recordAudio(_ sender: Any) {
        recordButton.isEnabled = false
        stopRecordingButton.isEnabled = true
        recordingLable.text = "Recording in Progress 🎤"
        // For AVFoundation
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        let session = AVAudioSession.sharedInstance()
        // The source of this line is below: Our group at Stack ( Udacity & misk ) 
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    @IBAction func stopRecording(_ sender: Any) {
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
       recordingLable.text = "Click to Recording"
        // For AVFoundation
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Erorr 🙁")
        }
        
    }
    
}

