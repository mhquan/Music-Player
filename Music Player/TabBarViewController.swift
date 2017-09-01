//
//  TabBarViewController.swift
//  Music Player
//
//  Created by QuanMH on 8/25/17.
//  Copyright © 2017 Quan. All rights reserved.
//

import UIKit
import MediaPlayer

class TabBarViewController: UITabBarController {
    var songID = NSNumber()
    var playView = PlayerView()
    var songQuery: SongQuery = SongQuery()
    var audioPlayer = MyAudioPlayer.sharedPlayer.audioPlayer
    var timer: Timer?
      override func viewDidLoad() {
        super.viewDidLoad()

        print("audioPlayer")
        print("audioPlayer")
        print("audioPlayer")
        print("audioPlayer")
        
        playView = PlayerView(frame: CGRect(x: 0, y: view.frame.size.height - PLAYER_CONTTROLLER_HEIGHT - self.tabBar.frame.size.height, width: view.frame.size.width, height: PLAYER_CONTTROLLER_HEIGHT))

        view.addSubview(playView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector (self.checkAction(sender:)))
        playView.addGestureRecognizer(gesture)
    }
 
    func checkAction(sender: UITapGestureRecognizer) {
        print(MyAudioPlayer.sharedPlayer.thisSong?.songId ?? 00)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
//        self.present(vc, animated: true, completion: nil)
        self.show(vc, sender: Any?.self)
    }

    override func viewWillAppear(_ animated: Bool) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(TabBarViewController.updateProgressView), userInfo: nil, repeats: true)

        songID = (MyAudioPlayer.sharedPlayer.thisSong?.songId) ?? 0
        if songID != 0 {
            let currentSong = SongQuery().getItem(songId: songID)
            playView.lblSongname.text = currentSong.title
            playView.lblSongArtist.text = currentSong.artist
            if let imageSound: MPMediaItemArtwork = currentSong.value(forProperty: MPMediaItemPropertyArtwork) as? MPMediaItemArtwork {
                playView.imgSongIcon.image = imageSound.image(at: CGSize(width: 40, height: 40))
            } else {
                playView.imgSongIcon.image = UIImage(named: "note")
            }
        } else {
            print("current song nil")
        }
    }

    func updateProgressView() {
        if MyAudioPlayer.sharedPlayer.thisSong?.songId != nil {
            let item: MPMediaItem = songQuery.getItem(songId: (MyAudioPlayer.sharedPlayer.thisSong?.songId)!)
            let url = item.value(forProperty: MPMediaItemPropertyAssetURL)
            let asset = AVURLAsset(url: url as! URL)
            print(asset.duration)
            if MyAudioPlayer.sharedPlayer.thisSong != nil {
            print(MyAudioPlayer.sharedPlayer.audioPlayer.currentTime)
            print(MyAudioPlayer.sharedPlayer.audioPlayer.duration)
            print(MyAudioPlayer.sharedPlayer.audioPlayer.currentTime/MyAudioPlayer.sharedPlayer.audioPlayer.duration*100)
            playView.progressView.setProgress(Float(MyAudioPlayer.sharedPlayer.audioPlayer.currentTime/MyAudioPlayer.sharedPlayer.audioPlayer.duration), animated: true)
            }
        }
    }
}
