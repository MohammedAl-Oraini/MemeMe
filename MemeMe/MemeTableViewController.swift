//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Mohammad Al-Oraini on 24/07/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    //MARK:- the shared model instant
    
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    //MARK:- life cycle of the app
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
    }
    
    //MARK:- Table view delgate methods


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath)
        let meme = self.memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data from the selected item
        detailController.meme = memes[indexPath.row]
        
        // Present the view controller using navigation
        navigationController!.pushViewController(detailController, animated: true)
    }

}
