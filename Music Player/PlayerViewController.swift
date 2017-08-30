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
    var currentSong: SongInfo? = MyAudioPlayer.sharedPlayer.thisSong
    var songList: [AlbumInfo] = []
    let albumsQuery = MPMediaQuery()
    var songQuery: SongQuery = SongQuery()


    @IBOutlet weak var circularSlider: CircularSlider!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var lblSongTitle: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        getSongs()
        setupCircularSlider()
        lblSongTitle.text = currentSong?.songTitle
    }

    func getSongs() {
        MPMediaLibrary.requestAuthorization { (status) in
            self.songList = self.songQuery.get(songCategory: "Song")
            self.myTableView?.reloadData()
        }
    }

    //MARK: set up table view
    func numberOfSections(in tableView: UITableView) -> Int {
        return songList.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songList[section].songs.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = songList[indexPath.section].songs[indexPath.row].songTitle
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let songId: NSNumber = songList[indexPath.section].songs[indexPath.row].songId
        MyAudioPlayer.sharedPlayer.thisSong?.songId = songId
        MyAudioPlayer.sharedPlayer.play()
    }

    // MARK: - setupCircularSlider
    fileprivate func setupCircularSlider() {
        circularSlider.delegate = self
        print(circularSlider.value)
        if currentSong?.songId != nil {
            let item: MPMediaItem = songQuery.getItem(songId: (currentSong?.songId)!)
            let url = item.value(forProperty: MPMediaItemPropertyAssetURL)
            let asset = AVURLAsset(url: url as! URL)
            circularSlider.minimumValue = 0
            circularSlider.maximumValue = Float(Double(CMTimeGetSeconds(asset.duration)))
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(PlayerViewController.updateSliderProgress), userInfo: nil, repeats: true)
        }
    }

    func updateSliderProgress() {
        let progress = MyAudioPlayer.sharedPlayer.audioPlayer.currentTime
//        print(MyAudioPlayer().audioPlayer.currentTime)
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
        print("btnRepeat")
    }
    @IBAction func btnShuffle(_ sender: Any) {
        print("btnShuffle")
    }
    @IBAction func btnPrevious(_ sender: Any) {
        print("btnPrevious")
    }
    @IBAction func btnNext(_ sender: Any) {
        print("btnNext")
    }
    @IBAction func btnPlay(_ sender: Any) {
        MyAudioPlayer.sharedPlayer.play()
    }

    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

}
extension PlayerViewController: CircularSliderDelegate {
    func circularSlider(_ circularSlider: CircularSlider, valueForValue value: Float) -> Float {


//        MyAudioPlayer().audioPlayer.currentTime = TimeInterval(circularSlider.value)

        return floorf(value)
    }
}
