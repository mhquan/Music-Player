//
//  PlayerView.swift
//  Music Player
//
//  Created by QuanMH on 8/25/17.
//  Copyright © 2017 Quan. All rights reserved.
//

import UIKit

class PlayerView: UIView {

    @IBOutlet weak var imgSongIcon: UIImageView!
    @IBOutlet weak var lblSongname: UILabel!
    @IBOutlet weak var lblSongArtist: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    
    @IBOutlet weak var contentView: UIView!
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    // MARK: - Private Helper Methods
    
    // Performs the initial setup.
    private func setupView() {
        
        Bundle.main.loadNibNamed("PlayerView", owner: self, options: nil)
        contentView.frame = self.bounds
        addSubview(contentView)
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    
    // Loads a XIB file into a view and returns this view.
//    private func viewFromNibForClass() -> UIView {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
//        let view = nib.instantiate(withOwner: self, options: nil).first as! UIView
//        
//        return view
//    }
}
