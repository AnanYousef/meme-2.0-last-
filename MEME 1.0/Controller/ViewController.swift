//
//  ViewController.swift
//  MEME 1.0
//
//  Created by Anan Yousef on 08/12/2020.
//

import UIKit
import Foundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var CameraButton: UIBarButtonItem!
    @IBOutlet weak var ImagePickerView: UIImageView!
    @IBOutlet weak var TopText: UITextField!
    @IBOutlet weak var BottomText: UITextField!
    @IBOutlet weak var Share: UIBarButtonItem!
    
    let textDelegate = TextClearDelegate()
    var memedImage: UIImage!
    var meme : Meme!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTextField(textField: TopText, text: "Tap to Edit")
        initializeTextField(textField: BottomText, text: "Tap to Edit")
        
        
        
        Share.isEnabled = false
 
    }
    
    func initializeTextField(textField: UITextField, text: String) {
        textField.delegate = textDelegate
        textField.text = text
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        subscribeToKeyboardNotification()
        CameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotification()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
        
    }
    
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return memedImage
    }
    
    func saveMemedImage(memedImage: UIImage) {
        
        let meme = Meme(topText: TopText.text!, bottomText: BottomText.text!, originalImage: ImagePickerView.image!, memedImage: memedImage)
        self.meme = meme
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
       
    }
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -3.0
    ]
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if BottomText.isFirstResponder {
        view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    

    @IBAction func PickAnImage(_ sender: Any) {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = .photoLibrary
        present(ImagePicker, animated: true, completion: nil)
        Share.isEnabled = true


    }
    
    @IBAction func PickImageFormCamera(_ sender: Any) {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = .camera
        present(ImagePicker, animated: true, completion: nil)
        Share.isEnabled = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
        ImagePickerView.image = image
        dismiss(animated: true, completion: nil)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)

        
            }
    }
    @IBAction func sharebutton(_ sender: UIBarButtonItem) {
        let memeToShare = generateMemedImage()
            let sharingActivity = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
            sharingActivity.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) in
                
                if completed {
                    self.saveMemedImage(memedImage: memeToShare)
                    
                }
            }
            present(sharingActivity, animated: true, completion: nil)
    }
    
}


