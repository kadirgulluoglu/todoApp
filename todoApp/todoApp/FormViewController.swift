//
//  FormViewController.swift
//  todoApp
//
//  Created by AyzaSoft on 6.03.2023.
//

import UIKit
import CoreData

class FormViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var sizeTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var selectedName = ""
    var selectedId : UUID?

    override func viewDidLoad() {
        
        if(selectedName != ""){
            if (selectedId?.uuidString) != nil{
                
            }
        }
        else {
            sizeTextField.text = ""
            priceTextField.text = ""
            nameTextField.text = ""
        }
        
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        
        imageView.isUserInteractionEnabled = true
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onTapImage))
        imageView.addGestureRecognizer(imageGestureRecognizer)
        
        
    }
    
    @objc func onTapImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true,completion: nil)
        
        
        
    }
    
    @objc func closeKeyboard(){
        view.endEditing(true)
    }
    

    @IBAction func onClickSaveButton(_ sender: Any) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let todo = NSEntityDescription.insertNewObject(forEntityName: "Todo", into: context)
        
        todo.setValue(nameTextField.text!, forKey: "name")
        todo.setValue(sizeTextField.text!, forKey: "size")
        todo.setValue(UUID(), forKey: "id")
        
        if let price = Int(priceTextField.text!){
            todo.setValue(price, forKey: "price")
        }
        todo.setValue(imageView.image!.jpegData(compressionQuality: 0.5), forKey: "image")
        do{
            try context.save()
            print("Kaydedildi")
        }
        catch{
            print("hata var")
        }
        
        NotificationCenter.default.post(name:NSNotification.Name("veriGirildi"),object: nil)
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
}
