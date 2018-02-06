//
//  SaveViewController.swift
//  FinalProject
//
//  Created by Stefan Himmel on 7/27/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class SaveViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    var oldTitle: String = StandardEngine.singleton.title
    var myTitle: String = StandardEngine.singleton.title
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        guard let input = sender.text else {
            return
        }
        
        if input == "" { // don't except empty
            titleTextField.text = myTitle
        }else{
            myTitle = input
        }
        titleTextField.resignFirstResponder()
    }
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func save(_ sender: UIBarButtonItem) {
        print("save View Controller is sending a notification")

        //converts grid to coordinates
        let contents = gridToContents(grid: StandardEngine.singleton.grid)
        
        let mySpecialNotificationKey = "save"
        //StandardEngine.singleton.title = myTitle
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: mySpecialNotificationKey),
                                        object: nil,
                                        userInfo: ["title":  myTitle, "oldTitle": oldTitle, "contents": contents ])
        StandardEngine.singleton.title = myTitle
        navigationController?.popToRootViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField!.text = myTitle
        
        
        navigationController?.setNavigationBarHidden(false, animated: true)

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gridToContents(grid: GridProtocol) -> Array<Array<Int>> {
        // HOW TO GET CONTENTS FROM A GRID? (ALL POSITIONS OF LIVING CELLS)
        //grid.lazyPositions
        var newContents: Array<Array<Int>> = []
        for i in 0 ... grid.size.rows-1 {
            for j in 0 ... grid.size.cols-1 {
                if grid[i,j].isAlive{
                    newContents.append([i,j])
                }
            }
        }
        return newContents
    }

}

extension SaveViewController: UITextFieldDelegate {
    //to get rid of textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
