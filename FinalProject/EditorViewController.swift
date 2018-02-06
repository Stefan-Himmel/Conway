//
//  EditorViewController.swift
//  lecture10
//
//  Created by Stefan Himmel on 7/19/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

import UIKit

class EditorViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBAction func textFieldChanged(_ sender: UITextField) {
        titleTextField.resignFirstResponder()
    }
    @IBOutlet weak var gridView: GridView!
    
    var gameGrid: GridProtocol?
    var gameTitle: String?
    
    var completion: ((String, GridProtocol) -> Void)?
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        if let gameTitle = titleTextField.text, let completion = completion {
            completion(gameTitle, gridView.currentGrid)
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField!.text = gameTitle
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension EditorViewController: UITextFieldDelegate {
    //to get rid of textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
