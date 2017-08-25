//
//  TabBarViewController.swift
//  Music Player
//
//  Created by QuanMH on 8/25/17.
//  Copyright © 2017 Quan. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let playViewPosition = UIScreen.main.bounds.size.height - CGFloat(PLAYER_CONTTROLLER_HEIGHT)
        let playView: PlayerView = PlayerView(frame: CGRect(x: 0, y: view.frame.size.height - PLAYER_CONTTROLLER_HEIGHT - self.tabBar.frame.size.height, width: view.frame.size.width, height: PLAYER_CONTTROLLER_HEIGHT))
        view.addSubview(playView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

