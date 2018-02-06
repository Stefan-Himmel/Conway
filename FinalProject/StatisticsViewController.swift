//
//  StatisticsViewController.swift
//  Assignment4
//
//  Created by Anne Himmel on 7/16/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

//Notes: my cumulative cell counts consider cell toggling as a generation

class StatisticsViewController: UIViewController {

    var numAlive: Int = 0
    var numEmpty: Int = 0
    var numBorn: Int = 0
    var numDied: Int = 1 { didSet {
            setLabels()
        }
    }
    var oldSize: Int = 10
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var aliveLabel: UILabel!
    @IBOutlet weak var bornLabel: UILabel!
    @IBOutlet weak var diedLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBAction func resetPressed(_ sender: UIButton) {
        resetCounts()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupListener()
        StandardEngine.singleton.somethingChanged() //get initial statistics

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func resetCounts(){
        setCells(empty: 0, alive: 0, born: 0, died: 0)
    }
    
    func setCells(empty: Int, alive: Int, born: Int, died: Int){
        numEmpty = empty
        numAlive = alive
        numBorn = born
        numDied = died
        setLabels()
    }
    
    func setLabels(){
        
        emptyLabel?.text = "Empty: \(String(numEmpty))"
        aliveLabel?.text = "Alive: \(String(numAlive))"
        bornLabel?.text = "Born: \(String(numBorn))"
        diedLabel?.text = "Died: \(String(numDied))"
    }
    
    
    func setupListener() {
        let notificationSelector = #selector(actOnNotification(notification:))
        NotificationCenter.default.addObserver(self, selector: notificationSelector, name: NSNotification.Name(rawValue: "newGrid"), object: nil)
        
        let resetSelector = #selector(resetter(notification:))
                NotificationCenter.default.addObserver(self, selector: resetSelector, name: NSNotification.Name(rawValue: "reset"), object: nil)
    }

    
    func resetter(notification: Notification){
        resetCounts()
    }
    
    func actOnNotification(notification: Notification) {
        guard let newGrid = notification.userInfo?["infoGrid"] as? GridProtocol else {
            return
        }
        
        if newGrid.size.rows != oldSize {
            //reset count if grid size changes
            resetCounts()
            oldSize = newGrid.size.rows
        }
        
        var tempAlive = numAlive
        var tempEmpty = numEmpty
        var tempBorn = numBorn
        var tempDied = numDied
   
        for i in 0 ... newGrid.size.rows-1 { //no map functions for grid protocol so I needed to use loops (not that bad)
            for j in 0 ... newGrid.size.cols-1 {
                switch newGrid[i,j]{
                case .alive: tempAlive += 1
                case .empty: tempEmpty += 1
                case .born: tempBorn += 1
                case .died: tempDied += 1
                }
            }
        }
        setCells(empty: tempEmpty, alive: tempAlive, born: tempBorn, died: tempDied)
    }

}
