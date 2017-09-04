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
import UICircularProgressRing
import MediaPlayer

class PlayerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var currentSong = MyAudioPlayer.sharedPlayer.thisSong
    var songList: [SongInfo]?
    let albumsQuery = MPMediaQuery()
    var songQuery: SongQuery = SongQuery()
    var songListName: [String]?
    var timer: Timer!


    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var lblSongTitle: UILabel!
    @IBOutlet weak var imgPlayPause: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
//
        
//        let x = Int(round(sliderProgress.value)) // x is Int
        
        
//
        songListName = MyAudioPlayer.sharedPlayer.songListName
        songList = MyAudioPlayer.sharedPlayer.songList
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.updateSliderProgress), userInfo: nil, repeats: true)

    }

    override func viewWillAppear(_ animated: Bool) {
        setupCircularSlider()
        updatePlaybutton()
        lblSongTitle.text = currentSong?.songTitle

        
    }
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
    }
    //MARK: set up table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList!.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = songList?[indexPath.row].songTitle
        cell.textLabel?.textColor = UIColor.white
        cell.becomeFirstResponder()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentSong = songList?[indexPath.row]
        MyAudioPlayer.sharedPlayer.songPosition = indexPath.row
        print(currentSong ?? "current song nil table")
        MyAudioPlayer.sharedPlayer.thisSong = currentSong
        MyAudioPlayer.sharedPlayer.play()
        lblSongTitle.text = currentSong?.songTitle
        setupCircularSlider()
    }

    // MARK: - setupCircularSlider
    fileprivate func setupCircularSlider() {
        circularSlider.delegate = self
//        MyAudioPlayer.sharedPlayer.audioPlayer.play(atTime: TimeInterval(circularSlider.value))
//        MyAudioPlayer.sharedPlayer.audioPlayer.currentTime = TimeInterval(circularSlider.value)
        
        
        currentSong = MyAudioPlayer.sharedPlayer.thisSong
        if currentSong?.songId != nil {
            let item: MPMediaItem = songQuery.getItem(songId: (currentSong?.songId)!)
            let url = item.value(forProperty: MPMediaItemPropertyAssetURL)
            let asset = AVURLAsset(url: url as! URL)
            circularSlider.minimumValue = 0
            circularSlider.maximumValue = Float(Double(CMTimeGetSeconds(asset.duration)))

        } else {
            print("current song nil")
        }
    }

    func updateSliderProgress() {

        if currentSong?.songTitle != nil {
            let progress = MyAudioPlayer.sharedPlayer.audioPlayer.currentTime
//            circularSlider.setValue(Float(progress), animated: true)
            lblTime.text = getHoursMinutesSecondsFrom(seconds: progress)
        }
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

    func updatePlaybutton() {
        if MyAudioPlayer.sharedPlayer.thisSong != nil {
            print("audio player khac nil")
            if MyAudioPlayer.sharedPlayer.audioPlayer.isPlaying == true {
                imgPlayPause.setImage(UIImage.init(named: "pause"), for: UIControlState.normal)
            } else {
                imgPlayPause.setImage(UIImage.init(named: "play"), for: UIControlState.normal)
            }
        } else {
            print("audio player = nil")
            imgPlayPause.setImage(UIImage.init(named: "play"), for: UIControlState.normal)
        }

    }
    
    func playNextSong() {
        if MyAudioPlayer.sharedPlayer.audioPlayer.currentTime == MyAudioPlayer.sharedPlayer.audioPlayer.duration {
            MyAudioPlayer.sharedPlayer.next()
        }
    }

    @IBAction func btnRepeat(_ sender: Any) {
        print("btnRepeat")
    }
    @IBAction func btnShuffle(_ sender: Any) {
        print("btnShuffle")
    }
    @IBAction func btnPrevious(_ sender: Any) {
        MyAudioPlayer.sharedPlayer.previous()
        lblSongTitle.text = MyAudioPlayer.sharedPlayer.thisSong?.songTitle

    }

    @IBAction func btnNext(_ sender: Any) {
        MyAudioPlayer.sharedPlayer.next()
        lblSongTitle.text = MyAudioPlayer.sharedPlayer.thisSong?.songTitle
    }
    @IBAction func btnPlay(_ sender: Any) {
        if MyAudioPlayer.sharedPlayer.thisSong != nil {
            MyAudioPlayer.sharedPlayer.playAndPause()
            updatePlaybutton()
        } else {
            print("song = nil")
        }
    }

    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PlayerViewController: CircularSliderDelegate {
    func circularSlider(_ circularSlider: CircularSlider, valueForValue value: Float) -> Float {
//        MyAudioPlayer.sharedPlayer.audioPlayer.play(atTime: TimeInterval(circularSlider.value))
        if MyAudioPlayer.sharedPlayer.thisSong != nil {
            MyAudioPlayer.sharedPlayer.audioPlayer.currentTime = TimeInterval(circularSlider.value)
            print(circularSlider.isExclusiveTouch)
            playNextSong()
        }
            return floorf(value)
    }
}
