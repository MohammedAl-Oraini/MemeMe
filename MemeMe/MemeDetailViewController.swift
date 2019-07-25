//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Mohammad Al-Oraini on 25/07/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    //MARK:- the selected meme and its image outlet
    
    var meme: Meme!
    
    @IBOutlet weak var imageView: UIImageView!

    //MARK:- life cycle of the app
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
    }

}
