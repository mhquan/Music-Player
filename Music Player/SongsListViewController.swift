//
//  FirstViewController.swift
//  Music Player
//
//  Created by QuanMH on 8/21/17.
//  Copyright © 2017 Quan. All rights reserved.
//

import UIKit
import AVFoundation

var audioPlayer = AVAudioPlayer()
var songsDisplayName:[String] = []
var songsDisplayNameFilterd:[String] = []
var songsRealName:[String] = []
var thisSong = 0
var audioStuffed = false

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var shouldShowSearchResults = false
    @IBOutlet weak var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gettingSongNames()
    }

    func gettingSongNames() {
        let folderURL = URL(fileURLWithPath:Bundle.main.resourcePath!)
        do {
            let songPath = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
            
            for song in songPath{
                var mySong = song.absoluteString
                if mySong.contains(".mp3") {
                    let findString = mySong.components(separatedBy: "/")
                    mySong = findString[findString.count-1]
                    mySong = mySong.replacingOccurrences(of: ".mp3", with: "")
                    songsRealName.append(mySong)
                    mySong = mySong.replacingOccurrences(of: "%20", with: " ")
                    mySong = mySong.replacingOccurrences(of: "-", with: " ")
                    songsDisplayName.append(mySong)
                }
            }
            myTableView.reloadData()
        }
        catch{
            print ("ERROR")
        }
    }
    
    @IBAction func moveToPlayer(_ sender: Any) {
        performSegue(withIdentifier: "player", sender: nil)
    }
    
    @IBAction func play(_ sender: Any) {
    }
    //MARK: set up table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if shouldShowSearchResults {
            return songsDisplayNameFilterd.count
        }
        else {
            return songsDisplayName.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")

        if shouldShowSearchResults {
            cell.textLabel?.text = songsDisplayNameFilterd[indexPath.row]
        }
        else {
            cell.textLabel?.text = songsDisplayName[indexPath.row]
        }
 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let audioPath = Bundle.main.path(forResource: songsRealName[indexPath.row], ofType: ".mp3")
            UserDefaults.standard.set(audioPath, forKey: "thisSong")
//            audioPlayer.play()
            thisSong = indexPath.row
       
        performSegue(withIdentifier: "player", sender: nil)
    }

}
