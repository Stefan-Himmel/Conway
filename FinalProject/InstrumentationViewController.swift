//
//  FirstViewController.swift
//  Assignment4
//
//  Created by Van Simmons on 6/5/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class InstrumentationViewController: UIViewController {

    var stastisticsReference = StatisticsViewController() //tried to do this to setup listener for StatisticsViewController, as it is not the first view controller
    var rows = 10
    var cols = 10
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var colsField: UITextField!
    @IBOutlet weak var stepper: UIStepper!
    @IBOutlet weak var colsStepper: UIStepper!
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var refreshSlider: UISlider!
    @IBOutlet weak var timedRefresh: UISwitch!
    @IBOutlet weak var timedRefreshLabel: UILabel!
    
    @IBAction func stepperChanged(_ sender: UIStepper) { //for rows
        setTextField(from: sender.value)
    }
    
    @IBAction func colsStepperChanged(_ sender: UIStepper) { //for cols
        setColsField(from: sender.value)
    }

    @IBAction func sliderChanged(_ sender: UISlider) {
        setRefreshLabel(from: Double(sender.value))
    }
    
    @IBAction func timedRefreshOnOff(_ sender: UISwitch) {
        setTimedRefresh(on: timedRefresh.isOn)
    }
    
    @IBAction func editingStarted(_ sender: UITextField) { // for both
        sender.text? = ""
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) { //for rows (different strings)
        sender.resignFirstResponder()
        
        guard let input = sender.text else {
            return
        }
        
        let intInput = Int(input)
        
        if intInput != nil && 10 <= intInput! && intInput! <= 100{
        sender.text? = "Rows: " + "\(String(describing: input))"
            changeSize(rows: intInput!, cols: cols)
        }else{
            sender.text? = "rows: " + "\(String(describing: rows))"
        }

    }
    
    @IBAction func colsFieldChanged(_ sender: UITextField) {
        
        sender.resignFirstResponder()
        
        guard let input = sender.text else {
            return
        }
        
        let intInput = Int(input)
        
        if intInput != nil && 10 <= intInput! && intInput! <= 100{
            sender.text? = "Cols: " + "\(String(describing: input))"
            changeSize(rows: rows, cols: intInput!)
        }else{
            sender.text? = "Cols: " + "\(String(describing: cols))"
        }
    }
    
    
    @IBAction func add(_ sender: Any) {
        let viewControllers = self.childViewControllers
        if let vc = viewControllers[0] as? GamesViewController {
            vc.add()
        }
    }
    
    
    func setTextField(from value: Double) {
        let intValue = Int(value)
        textField.text? = "Rows: \(intValue)"
        
        changeSize(rows: intValue, cols: cols)
    }
    
    func setColsField(from value: Double){
        let intValue = Int(value)
        colsField.text? = "Cols: \(intValue)"
        
        changeSize(rows: rows, cols: intValue)
    }
    
    func setRefreshLabel(from value: Double){
    let stringValue = String(round(10 * value) / 10)
    refreshLabel.text = "Refresh Freq: \(stringValue)"
    changeRefreshFrequency(frequency: value)
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        // fix "..." in labels
        refreshLabel.adjustsFontSizeToFitWidth = true
        timedRefreshLabel.adjustsFontSizeToFitWidth = true
        
        //start text field with stepper value, refreshFrequenct to value of refreshSlider, timed refresh with switch value
        rows = Int(stepper.value)
        setTextField(from: stepper.value)
        cols = Int(colsStepper.value)
        setColsField(from: colsStepper.value)
        setTimedRefresh(on: timedRefresh.isOn)
        changeRefreshFrequency(frequency: Double(refreshSlider.value))
        
        
        //set up listener in Statistics tab
        stastisticsReference.setupListener()
        stastisticsReference.setCells(empty: 0, alive: 0, born: 0, died: 0)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func changeSize(rows: Int, cols: Int) {
        self.rows = rows
        self.cols = cols
        StandardEngine.singleton.sizeChange(rows: rows, cols: cols)
    }
    
    func changeRefreshFrequency(frequency: Double) {
        StandardEngine.singleton.refreshFrequencyChange(frequency: frequency)
    }
    
    func setTimedRefresh(on: Bool){
        StandardEngine.singleton.timedRefreshOnOff(on: on)
    }
    
    
}


extension InstrumentationViewController: UITextFieldDelegate {
    //to get rid of textfield
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
 

