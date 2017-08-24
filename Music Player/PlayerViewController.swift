//
//  PlayerViewController.swift
//  Music Player
//
//  Created by QuanMH on 8/22/17.
//  Copyright © 2017 Quan. All rights reserved.
//

import UIKit
import AVFoundation
import CircularSlider

class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTime: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        registerForKeyboardNotifications()
        setupTapGesture()
        */
//        playMusic()
        setupCircularSlider()
        
    }
    /*
    func playMusic() {
        do {
            let audioPath = UserDefaults.standard.object(forKey: "thisSong")
            print(audioPath!)
            try audioPlayer = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath! as! String) as URL)
            audioPlayer.play()
            audioStuffed = true
        } catch {
            print ("ERROR")
        }
    }
    */
    
    //MARK: set up table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return albums[section].songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = albums[indexPath.section].songs[indexPath.row].songTitle
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let audioPath = Bundle.main.path(forResource: songsRealName[indexPath.row], ofType: ".mp3")
        UserDefaults.standard.set(audioPath, forKey: "thisSong")
//        playMusic()
    }
    
    

    // MARK: - methods
    fileprivate func setupCircularSlider() {
        circularSlider.delegate = self
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.updateSliderProgress), userInfo: nil, repeats: true)
    }
    
    /*
    fileprivate func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    // MARK: - keyboard handler
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    @objc fileprivate func keyboardWillShow(_ notification: Notification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }

    @objc fileprivate func keyboardWillHide(_ notification: Notification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }

    fileprivate func adjustInsetForKeyboardShow(_ show: Bool, notification: Notification) {
        guard let value = (notification as NSNotification).userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        let adjustmentHeight = (keyboardFrame.height + 150) * (show ? 1 : -1)
        scrollView.contentInset.bottom += adjustmentHeight
        scrollView.scrollIndicatorInsets.bottom += adjustmentHeight
    }

    @objc fileprivate func hideKeyboard() {
        view.endEditing(true)
    }
    */
    func updateSliderProgress() {
        let progress = audioPlayer.currentTime
        circularSlider.setValue(Float(progress), animated: true)
        lblTime.text = getHoursMinutesSecondsFrom(seconds: progress)

    }
    
    func getHoursMinutesSecondsFrom(seconds: Double) -> String {
        let secs = Int(seconds)
//        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "m:ss"
        let date: Date? = dateFormatter.date(from: "\(minutes)" + " : " + "\(seconds)")
        return dateFormatter.string(from: date!)
    }

    @IBAction func btnRepeat(_ sender: Any) {
        print("1")
    }
    @IBAction func btnShuffle(_ sender: Any) {
                print("1")
    }
    @IBAction func btnPrevious(_ sender: Any) {
                print("1")
    }
    @IBAction func btnNext(_ sender: Any) {
                print("1")
    }
    @IBAction func btnPlay(_ sender: Any) {
        playDidPress()
    }
    
}
func playDidPress() {
    if audioPlayer.isPlaying == false {
        audioPlayer.play()
    } else if audioPlayer.isPlaying {
        audioPlayer.pause()
    }
    
}
extension PlayerViewController: CircularSliderDelegate {
    func circularSlider(_ circularSlider: CircularSlider, valueForValue value: Float) -> Float {

        let asset = AVURLAsset(url: URL(fileURLWithPath: UserDefaults.standard.object(forKey: "url") as! String))
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = Float(Double(CMTimeGetSeconds(asset.duration)))
//        audioPlayer.currentTime = TimeInterval(circularSlider.value)
        return floorf(value)
    }
}
