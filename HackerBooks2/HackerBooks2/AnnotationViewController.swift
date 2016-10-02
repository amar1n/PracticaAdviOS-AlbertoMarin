//
//  AnnotationViewController.swift
//  HackerBooks2
//
//  Created by Alberto Marín García on 2/10/16.
//  Copyright © 2016 Alberto Marín García. All rights reserved.
//

import UIKit
import Social

class AnnotationViewController: UIViewController {
    
    var model : Annotation
    var isNew : Bool
    var deleteCurrentAnnotation : Bool
    
    //MARK: - Inits
    init(model: Annotation, isNew: Bool) {
        self.model = model
        self.isNew = isNew
        self.deleteCurrentAnnotation = false
        super.init(nibName: nil, bundle: nil)
        title = "Nota"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var modificationDateView: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var addressView: UILabel!
    
    //MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let df = DateFormatter()
        df.dateStyle = .medium
        modificationDateView.text = df.string(from: model.modificationDate as! Date)
        self.textView.text = self.model.text
        var img = self.model.photo?.image
        if img == nil {
            img = UIImage(imageLiteralResourceName: "noImage.png")
        }
        self.photoView.image = img;
        self.addressView.text = self.model.location?.address
        
        var buttons = [UIBarButtonItem]()
        if (self.isNew) {
            // Mostramos el botón de cancelar
            let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AnnotationViewController.cancel))
            buttons.append(cancel)
        }
        // Añadimos un botón de compartir la nota en las redes sociales
        let share = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AnnotationViewController.share(sender:)))
        buttons.append(share)
        navigationItem.rightBarButtonItems = buttons
        
        startObservingKeyboard()
        
        setupInputAccessoryView()
        
        // Añadimos un gestureRecognizer a la foto
        let tap = UITapGestureRecognizer(target: self, action: #selector(AnnotationViewController.displayDetailPhoto(sender:)))
        self.photoView.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if deleteCurrentAnnotation {
            self.model.managedObjectContext?.delete(model)
        } else {
            self.model.text = self.textView.text
            self.model.photo?.image = self.photoView.image
        }
    }
    
    //MARK: - Utils
    func cancel() {
        print("...................Hola Su")
        deleteCurrentAnnotation = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func share(sender: UIButton!) {
        if isNew {
            if (self.textView.text?.isEmpty == false) || (self.photoView.image != nil) {
                let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                let txt = (self.textView.text?.isEmpty == false ? self.textView.text : "Hello Facebook!!!")
                composeSheet?.setInitialText(txt)
                if let img = self.photoView.image {
                    composeSheet?.add(img)
                }
                
                present(composeSheet!, animated: true, completion: nil)
            }
        } else {
            if (self.model.text?.isEmpty == false) || (self.model.photo?.image != nil) {
                let composeSheet = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                let txt = (self.model.text?.isEmpty == false ? self.model.text : "Hello Facebook!!!")
                composeSheet?.setInitialText(txt)
                if let img = model.photo?.image {
                    composeSheet?.add(img)
                }
                
                present(composeSheet!, animated: true, completion: nil)
            }
        }
    }
    
    func arrayOfItems() -> [Any] {
        var items : [Any] = []
        
        if let txt = model.text {
            items.append(txt)
        }
        if let img = model.photo?.image {
            items.append(img)
        }
        
        return items
    }
    
    
    func displayDetailPhoto(sender: UIButton!) {
        if self.model.photo == nil {
            self.model.photo = Photo(annotation: model, context: model.managedObjectContext!)
        }
        
        let pVC = PhotoViewController(model: self.model)
        self.navigationController?.pushViewController(pVC, animated: true)
    }
    
    //MARK: - Keyboard
    func startObservingKeyboard() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(AnnotationViewController.notifyThatKeyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(AnnotationViewController.notifyThatKeyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func stopObservingKeyboard() {
        let nc = NotificationCenter.default
        nc.removeObserver(self)
    }
    
    func notifyThatKeyboardWillAppear(_ notification: NSNotification) {
        if self.textView.isFirstResponder {
            // Extraer la duración de la animación
            guard let userInfo = notification.userInfo,
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
                    print("No userInfo found in notification")
                    return
            }
            
            // Cambiar las propiedades de la caja de texto
            UIView.animate(withDuration: TimeInterval(0),
                           delay: TimeInterval(0.0),
                           options: UIViewAnimationOptions(rawValue: UInt(0)),
                           animations: {
                            self.textView.frame = CGRect(x: self.modificationDateView.frame.origin.x,
                                                         y: self.modificationDateView.frame.origin.y,
                                                         width: self.textView.frame.size.width,
                                                         height: self.textView.frame.size.height)
                }, completion: nil)
            
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                self.textView.alpha = 0.8
            })
            self.view.bringSubview(toFront: self.textView)
        }
        
    }
    
    func notifyThatKeyboardWillDisappear(_ notification: NSNotification) {
        if self.textView.isFirstResponder {
            // Extraer la duración de la animación
            guard let userInfo = notification.userInfo,
                let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber else {
                    print("No userInfo found in notification")
                    return
            }
            
            // Cambiar las propiedades de la caja de texto
            UIView.animate(withDuration: TimeInterval(duration),
                           delay: TimeInterval(0.0),
                           options: UIViewAnimationOptions(rawValue: UInt(0)),
                           animations: {
                            self.textView.frame = CGRect(x: 0,
                                                         y: 320,
                                                         width: self.textView.frame.size.width,
                                                         height: self.textView.frame.size.height)
                }, completion: nil)
            
            UIView.animate(withDuration: TimeInterval(duration), animations: {
                self.textView.alpha = 1
            })
        }
    }
    
    func setupInputAccessoryView() {
        // Creamos una barra
        let textBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        
        // Añadimos botones
        let sep = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AnnotationViewController.dismisKeyboard(sender:)))
        textBar.items = [sep, done]
        
        // La asignamos como accessoryInputView
        self.textView.inputAccessoryView = textBar
    }
    
    func dismisKeyboard(sender: UIButton!) {
        self.view.endEditing(true)
    }
}
