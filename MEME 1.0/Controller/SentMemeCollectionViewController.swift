//
//  SentMemeCollectionViewController.swift
//  MEME 1.0
//
//  Created by Anan Yousef on 14/12/2020.
//

import Foundation
import UIKit

private let reuseIdentifier = "SentMemeCollectionViewCell"

class SentMemeCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK - Life Cycle
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        // refresh the collection view to show current meme data
        collectionView!.reloadData()
    }

    // MARK: - UICollectionView Data Source Methods

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        // set the placeholder view if there is no meme data to show
        if appDelegate.memes.count == 0 {
            setEmptyView(title: "No Memes Stored", message: "Tap '+' to create a new meme!")
        } else {
            restoreCollectionView()
        }
        return appDelegate.memes.count
    }

    // displays an empty placeholder view
    func setEmptyView(title: String, message: String) {

        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
        let titleLabel = UILabel()
        let messageLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        messageLabel.textColor = .darkGray
        messageLabel.font = UIFont(name: "HelveticaNeue-Regular", size: 10)
        emptyView.addSubview(titleLabel)
        emptyView.addSubview(messageLabel)

        // set constraints for empty view
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor, constant: 10).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor, constant: -10).isActive = true
        titleLabel.text = title
        messageLabel.text = message
        titleLabel.numberOfLines = 0
        messageLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        messageLabel.textAlignment = .center
        
        collectionView.backgroundView = emptyView
        navigationItem.leftBarButtonItem = nil
    }
   
    // restores collection view if meme data exists
    func restoreCollectionView() {
       
        collectionView.backgroundView = nil
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // dequeue a reusable cell and get the meme object at the specified index path
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme: Meme = appDelegate.memes[(indexPath as NSIndexPath).row]
    
        // set the image
        cell.memeImage.image = meme.memedImage
        
        // create border around cell image and added background color
        cell.memeImage.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        cell.memeImage.layer.masksToBounds = true
        cell.memeImage.contentMode = .scaleAspectFit
        cell.memeImage.layer.borderWidth = 1
        cell.memeImage.layer.backgroundColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        
        return cell
    }

    // MARK: - UICollectionView Delegate Methods
        
        override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as!
            DetailViewController
            
            // populate the view controller with data from the selected item
            detailController.memeToPresent = appDelegate.memes[(indexPath as NSIndexPath).row]
            
            // present the view controller using navigation
            self.navigationController!.pushViewController(detailController, animated: true)
        }
        
        // MARK: - UICollectionView Delegate Flow Layout Methods

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let cellWidth = (self.view.frame.width - 3.0) / 3.0
            let cellHeight = (self.view.frame.width - 3.0) / 3.0

            return CGSize(width: cellWidth, height: cellHeight)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

            // 1.5 pixels of line spacing
            return 1.5
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

            // 1.5 pixels of interitem spacing
            return 1.5
        }
}
