//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Mohammad Al-Oraini on 24/07/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class MemeCollectionViewController: UICollectionViewController {
    
    //MARK:- the shared model instant
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    //MARK:- IBOutlet of the app
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    //MARK:- life cycle of the app

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
    }
    
    //MARK:- setting up the UI
    
    func setupFlowLayout() {
        let space:CGFloat = 3.0
        let widthDimension = (view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (view.frame.size.height - (2 * space)) / 3.0
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
    }
    
    //MARK:- Collection view delegate methods


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        let meme = self.memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
    
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        
        // Grab the DetailVC from Storyboard
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
        
    }

}
