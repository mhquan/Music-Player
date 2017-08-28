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
import MediaPlayer

class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var songID = NSNumber()



    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var lblTime: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        SongListViewController().getSongs()
        /*
        registerForKeyboardNotifications()
        setupTapGesture()
        */
//        playMusic()
        setupCircularSlider()
        /*
        let item: MPMediaItem = SongQuery().getItem(songId: songID)
        let url: URL = item.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
        print(url)
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.play()

        */

    }
    //MARK: set up table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if shouldShowSearchResults {
            return albums[section].songs.count
        }
            else {
                return albums[section].songs.count
        }
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = albums[indexPath.section].songs[indexPath.row].songTitle

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songId: NSNumber = albums[indexPath.section].songs[indexPath.row].songId
        let item: MPMediaItem = songQuery.getItem(songId: songId)
        let url: URL = item.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
        print(url)
        audioPlayer = try! AVAudioPlayer(contentsOf: url)
        audioPlayer.play()
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

    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
extension PlayerViewController: CircularSliderDelegate {
    func circularSlider(_ circularSlider: CircularSlider, valueForValue value: Float) -> Float {

//        let asset = AVURLAsset(url: URL(fileURLWithPath: UserDefaults.standard.object(forKey: "url") as! String))
        let item: MPMediaItem = songQuery.getItem(songId: songID)
        let url = item.value(forProperty: MPMediaItemPropertyAssetURL)
        let asset = AVURLAsset(url: url as! URL)
        circularSlider.minimumValue = 0
        circularSlider.maximumValue = Float(Double(CMTimeGetSeconds(asset.duration)))
//        audioPlayer.currentTime = TimeInterval(circularSlider.value)
        return floorf(value)
    }
}
