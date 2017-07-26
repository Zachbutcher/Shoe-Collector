//
//  CreateGameViewController.swift
//  Shoe Collector
//
//  Created by Zach Butcher on 7/24/17.
//  Copyright © 2017 Zach Butcher. All rights reserved.
//

import UIKit

class CreateGameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var shoe : Shoes? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        imagePicker.delegate = self
        
        if shoe == nil{
            deleteButton.isHidden = true
        }
        if shoe != nil {
            imagePreview.image = UIImage(data: shoe!.image! as Data)
            titleTextField.text = shoe?.name
            addButton.setTitle("Update", for: .normal)
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion:nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        //imagePreview.contentMode = .scaleAspectFit //3
        imagePreview.image = chosenImage //4
        dismiss(animated:true, completion: nil) //5
    }
    
    @IBAction func takePhoto(_ sender: Any) {
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion:nil)
    }
    
    @IBAction func addShoes(_ sender: UIButton) {
        
        if shoe == nil {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let newShoes = Shoes(context: context)
            newShoes.name = titleTextField.text
            newShoes.image = UIImagePNGRepresentation(imagePreview.image!)! as NSData
        }
        if shoe != nil{
            shoe!.name = titleTextField.text
            shoe!.image = UIImagePNGRepresentation(imagePreview.image!)! as NSData
        }
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    @IBAction func deleteShoe(_ sender: Any) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        context.delete(shoe!)
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
