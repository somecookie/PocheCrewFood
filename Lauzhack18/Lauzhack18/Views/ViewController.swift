//
//  ViewController.swift
//  Lauzhack18
//
//  Created by Lionel Pellier on 24/11/2018.
//  Copyright © 2018 Lionel Pellier. All rights reserved.
//

import UIKit
import Moya

class MyViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    var image = UIImage()
    let provider = MoyaProvider<ImageAPI>()
    let stubProvider = MoyaProvider<ImageAPI>(stubClosure: MoyaProvider.immediatelyStub)
    
    private var state: State = .standby {
        didSet {
            switch state {
            case .standby:
                debugPrint("standby")
            case .ready:
                debugPrint("ready")
            case .loading:
                debugPrint("loading")
            case .error:
                debugPrint("error")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        state = .standby
        
        imagePicker.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "recipes" {
            guard case .ready(let recipes) = state else {return}
            
            let destination = segue.destination as! RecipesTableViewController
            destination.recipes = recipes
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = pickedImage
            debugPrint(image)
            self.provider.request(.image(image)){ [weak self] userResult in
                guard let self = self else { return }
                
                switch userResult{
                case .success(let recipesResponse):
                    do{
                        debugPrint("came here")
                        let recipes = try recipesResponse.map([Recipe].self)
                        debugPrint("came here 2")
                        self.state = .ready(recipes)
                        debugPrint("came here 3")
                        self.performSegue(withIdentifier: "recipes", sender: self)
                    } catch{
                        self.state = .error
                    }
                case .failure:
                    self.state = .error
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePicture(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .camera
        
        present(imagePicker, animated: true, completion: nil)
    }
}

extension MyViewController {
    enum State {
        case loading
        case ready([Recipe])
        case error
        case standby
    }
}
