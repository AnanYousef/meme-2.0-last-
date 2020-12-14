//
//  SentMemeTableViewController.swift
//  MEME 1.0
//
//  Created by Anan Yousef on 14/12/2020.
//

import Foundation
import UIKit

class SentMemeTableViewController: UITableViewController {
    
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
           
        super.viewDidLoad()
        
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        tableView!.reloadData()
    }

    // MARK: - UITableView Data Source Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // set the placeholder view if there is no meme data to show
        if appDelegate.memes.count == 0 {
            setEmptyView(title: "No Memes Stored", message: "Tap '+' to create a new meme!")
        } else {
            restoreTableView()
        }
        return appDelegate.memes.count
    }
    
    // displays an empty placeholder view
    func setEmptyView(title: String, message: String) {
        
        let emptyView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
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
 
        tableView.backgroundView = emptyView
        tableView.separatorStyle = .none
        navigationItem.leftBarButtonItem = nil
    }
    
    func restoreTableView() {
        
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
        navigationItem.leftBarButtonItem = editButtonItem
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // dequeue a reusable cell and get the meme object at the specified index path
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemeTableViewCell", for: indexPath) as! SentMemeTableViewCell
        let meme: Meme = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        // set the image and label
        
        cell.memeImage.image = meme.memedImage
        cell.memeLabel.text = meme.topText
        cell.textLabel?.text = meme.bottomText
        
        // create border around cell image and added background color
        cell.memeImage.layer.borderColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        cell.memeImage.layer.masksToBounds = true
        cell.memeImage.contentMode = .scaleAspectFit
        cell.memeImage.layer.borderWidth = 1
        cell.memeImage.layer.backgroundColor = UIColor(white: 0.0, alpha: 1.0).cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            appDelegate.memes.remove(at: (indexPath as NSIndexPath).row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - UITableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detailController = self.storyboard!.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        
        // populate the view controller with data from the selected item
        detailController.memeToPresent = appDelegate.memes[(indexPath as NSIndexPath).row]
        
        // present the view controller using navigation
        self.navigationController!.pushViewController(detailController, animated: true)
    }

}
    

