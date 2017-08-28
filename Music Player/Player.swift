//
//  Player.swift
//  Music Player
//
//  Created by QuanMH on 8/28/17.
//  Copyright © 2017 Quan. All rights reserved.
//

import Foundation
import MediaPlayer
import AVFoundation

var songsDisplayName: [String] = []
var songsDisplayNameFilterd: [String] = []
var songsRealName: [String] = []
var thisSong: NSNumber = 0
var audioStuffed = false
let audioInfo = MPNowPlayingInfoCenter.default()
var mediaPicker: MPMediaPickerController?
var myMusicPlayer: MPMusicPlayerController?
let masterVolumeSlider: MPVolumeView = MPVolumeView()
let shouldShowSearchResults = false
var albums: [AlbumInfo] = []
var songQuery: SongQuery = SongQuery()
var audioPlayer = AVAudioPlayer()
var songID = NSNumber()

func playDidPress() {
    if audioPlayer.isPlaying == false {
        audioPlayer.play()
    } else if audioPlayer.isPlaying {
        audioPlayer.pause()
    }
}
func playMusic() {
    audioPlayer.stop()
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

class MyAudioPlayer: NSObject, AVAudioPlayerDelegate {
    private static let sharedPlayer: MyAudioPlayer = {
        return MyAudioPlayer()
    }()
    
    private var container = [String : AVAudioPlayer]()
    
    static func playFile(name: URL, type: String) {
        var player: AVAudioPlayer?
        let key = String(describing: name)+type
        for (file, thePlayer) in sharedPlayer.container {
            if file == key {
                player = thePlayer
                break
            }
        }
        
        if player == nil, let resource = Bundle.main.path(forResource: String(describing: name), ofType:type) {
            do {
                player = try AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: resource) as URL, fileTypeHint: AVFileTypeMPEGLayer3)
            } catch {
                // error
            }
        }
        if let thePlayer = player {
            if thePlayer.isPlaying {
                // already playing
            } else {
                thePlayer.delegate = sharedPlayer
                sharedPlayer.container[key] = thePlayer
                thePlayer.play()
            }
        }
    }
}
