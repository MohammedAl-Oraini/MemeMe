//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Mohammad Al-Oraini on 16/07/2019.
//  Copyright © 2019 Mohammad Al-Oraini. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    //MARK:- IBOutlets of the app

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    //MARK:- The memeTextAttributes that will be uesed in the app
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -5.0
        
    ]
    
    //MARK:- defining the defult state of the app
    
    let defult = Meme(topText: "TOP", bottomText: "BOTTOM", originalImage: nil, memedImage: nil)
    
    //MARK:- seting up the UI
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        shareButton.isEnabled = imagePickerView.image != nil
    }
    
    func setupUI() {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        setupTextField(topTextField, text: "TOP")
        setupTextField(bottomTextField, text: "BOTTOM")
    }
    
    func setupTextField(_ textField:UITextField, text: String) {
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        textField.text = text
    }
    

    //MARK:- IBActions of the app

    @IBAction func pickAnImageFromAlbum(_ sender: UIBarButtonItem) {
        presentPickerViewController(source: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: UIBarButtonItem) {
        presentPickerViewController(source: .camera)
    }
    
    
    @IBAction func shareButtonWasTapped(_ sender: UIBarButtonItem) {
        
        let memeImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        controller.completionWithItemsHandler = { (activity, completed, items, error) in
            if completed {
                self.save()
            }
        }
        present(controller, animated: true)
        
    }
    
    @IBAction func cancelButtonWasTapped(_ sender: UIBarButtonItem) {
        topTextField.text = defult.topText
        bottomTextField.text = defult.bottomText
        imagePickerView.image = defult.originalImage
        shareButton.isEnabled = false
    }
    
    //MARK:- handling the keyboard placment
    
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    

    
    //MARK:- generateing the meme image
    
    func generateMemedImage() -> UIImage {
        
        // to make the image clean
        navigationBar.isHidden = true
        toolBar.isHidden = true
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // to unhide the bars after the generation
        navigationBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    
    //MARK:- saveing the meme in an arry of Meme
    
    func save() {
        guard let image = imagePickerView.image else {
            return
        }
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: image, memedImage: generateMemedImage())
        memes.append(meme)
    }
}

//MARK:- Adding the UIImagePickerControllerDelegate and UINavigationControllerDelegate and thier methods

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- handling the picked image
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {

        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        present(imagePicker, animated: true, completion: nil)
    }
    
}

//MARK:- Adding the UITextFieldDelegate and its methods

extension MemeEditorViewController: UITextFieldDelegate {
    
    //MARK:- handling the textFields
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // need this so the fram only shift with bottom text field
        if textField == bottomTextField {
            subscribeToKeyboardNotifications()
        }
        // so the user does not need to delete the defult text
        if textField.text == "TOP" || textField.text == "BOTTOM" {
            textField.text = ""
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        // to prevent memory leaks
        if textField == bottomTextField {
            unsubscribeFromKeyboardNotifications()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
}
