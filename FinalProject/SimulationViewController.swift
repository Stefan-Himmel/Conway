//
//  SimulationViewController.swift
//  Assignment4
//
//  Created by Stefan Himmel on 7/13/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class SimulationViewController: UIViewController {
    
    

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var stepButton: UIButton!
    @IBOutlet weak var gridView: GridView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var stepping = false
    
    /// Buttons
    @IBAction func stepPressed(_ sender: UIButton) {
        if StandardEngine.singleton.timerOn { //auto stepping on
            if stepping{
                turnOffTimer()
            } else {
                stepping = true
                self.createTimerWithBlock()
                sender.setTitle("Stop", for: .normal)
            }
            
        }else{ //auto stepping off
        gridView.currentGrid = StandardEngine.singleton.step()
        gridView.setNeedsDisplay()
        }
    }
    
    @IBAction func resetPressed(_ sender: UIButton) {
        StandardEngine.singleton.reset()
        gridView.currentGrid = StandardEngine.singleton.grid
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.adjustsFontSizeToFitWidth = true
        //set up View Controller as Engine Delegate
        StandardEngine.singleton.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        gridView.delegate = self // for toggling
        gridView.currentGrid = StandardEngine.singleton.grid
        gridView.setNeedsDisplay()
        titleLabel.text = StandardEngine.singleton.title
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        turnOffTimer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// model communication
    func toggleModel(row: Int, col: Int){
        StandardEngine.singleton.toggleCell(row: row, col: col)
    }
    
    /// timer functions
    func createTimerWithBlock() {
        StandardEngine.singleton.refreshTimer = Timer.scheduledTimer(withTimeInterval: StandardEngine.singleton.refreshRate,
                                            repeats: true)
        {   timer in
            
            StandardEngine.singleton.refreshTimer = timer
            StandardEngine.singleton.stepVoid()
            self.gridView.currentGrid = StandardEngine.singleton.grid
        }
    }
    
    func turnOffTimer() {
        StandardEngine.singleton.refreshTimer?.invalidate()
        StandardEngine.singleton.refreshTimer = nil
        stepButton.setTitle("Step", for: .normal)
        stepping = false
    }
}

extension SimulationViewController: EngineDelegate {
    // to get SimulationViewController to conform to Engine Delegate
    func engineDidUpdate(engine: EngineProtocol) {
    }
}

