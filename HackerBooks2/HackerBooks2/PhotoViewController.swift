//
//  PhotoViewController.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 2/10/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController {
    
    let model : Annotation
    
    //MARK: - IBOutlet
    @IBOutlet weak var photoView: UIImageView!
    
    //MARK: - IBAction
    @IBAction func takePhoto(_ sender: AnyObject) {
        // Crear una instancia de UIImagePicker
        let picker = UIImagePickerController()
        
        // Configurarlo
        if UIImagePickerController.isCameraDeviceAvailable(.rear) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        
        picker.delegate = self
        
        // Mostrarlo de forma modal
        self.present(picker, animated: true, completion: nil)
    }
    
    //MARK: - Inits
    init(model: Annotation) {
        self.model = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Syncing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        syncModelView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        syncViewModel()
    }
    
    //MARK: - Syncing
    func syncModelView() {
        title = model.text
        photoView.image = model.photo?.image
    }
    
    func syncViewModel() {
        model.photo?.image = photoView.image
    }
}

//MARK: - Delegates
extension PhotoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // Redimensionarla al tamaño de la pantalla
        // deberes (está en el online)
        model.photo?.image = info[UIImagePickerControllerOriginalImage] as! UIImage?
        
        // Quitamos de enmedio al picker
        self.dismiss(animated: true) {
        }
    }
}
