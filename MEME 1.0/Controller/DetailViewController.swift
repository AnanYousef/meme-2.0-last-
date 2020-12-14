//
//  DetailViewController.swift
//  MEME 1.0
//
//  Created by Anan Yousef on 14/12/2020.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    var memeToPresent: Meme!
    
    @IBOutlet weak var memeImageView: UIImageView!
        



    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        memeImageView.image = memeToPresent.memedImage
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
