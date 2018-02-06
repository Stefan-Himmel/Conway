//
//  StandardEngine.swift
//  Assignment4
//
//  Created by Stefan Himmel on 7/12/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import UIKit

class StandardEngine: EngineProtocol {
    var delegate: EngineDelegate?
    var refreshRate: Double = 10
    var refreshTimer : Timer?
    var timerOn: Bool = false { didSet {
        somethingChanged()
        }
    }
    var rows: Int = 10
    var cols: Int = 10 { didSet {
        //somethingChanged()
        }
    }
    var grid: GridProtocol
    var title: String
    
    //       |||   THE SINGLETON  |||
    static var singleton: StandardEngine = {
        // Instatiate
        let tmpSingleton = StandardEngine(rows: 10, cols: 10)
        
        //configure
        tmpSingleton.refreshRate = 10
        tmpSingleton.refreshTimer = nil
        tmpSingleton.timerOn = false

        return tmpSingleton
    }()
    
    //       |||  INITIALIZER  |||
    internal required init(rows: Int, cols: Int){
        self.rows = rows
        self.cols = cols
        print("initializer grid call")
        grid = Grid(rows, cols)
        title = "Unnamed Configuration"
        
        
    }
    
    ///     ||| ENGINE FUNCTIONS |||
    
    func sizeChange(rows: Int, cols: Int) {
        StandardEngine.singleton.rows = rows
        StandardEngine.singleton.cols = cols
        StandardEngine.singleton.grid = Grid(rows, cols)
    }
    
    func newGrid(grid: GridProtocol, rows: Int, cols: Int){
        StandardEngine.singleton.grid = grid
        StandardEngine.singleton.rows = rows
        StandardEngine.singleton.cols = cols
    }
    
    func refreshFrequencyChange(frequency: Double){
        StandardEngine.singleton.refreshRate = frequency
        somethingChanged()
    }
    
    func timedRefreshOnOff(on: Bool){
        if on {
            timerOn = true
            StandardEngine.singleton.refreshTimer = Timer()
        }else {
            timerOn = false
            StandardEngine.singleton.refreshTimer = nil
        }
    }
    
    
    func step() -> GridProtocol {
        grid = grid.next()
        somethingChanged()
        return grid
    }
    
    func stepVoid() {
        grid = grid.next()
        somethingChanged()
    }
    
    func somethingChanged(){
    // Whenever the grid is created or changed, notify the delegate with the delegate method and publish the grid object using an NSNotification.
        
        delegate?.engineDidUpdate(engine: self)
        
        let mySpecialNotificationKey = "newGrid"
        
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: mySpecialNotificationKey),
            object: grid,
            userInfo: ["infoGrid": grid, "refreshFrequency": refreshRate, "timerOn": timerOn])
        
        return
    }
    
    func reset(){
        grid = Grid(rows,cols)
        
        delegate?.engineDidUpdate(engine: self)
        
        let mySpecialNotificationKey = "reset"
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: mySpecialNotificationKey),
                                        object: nil,
                                        userInfo: nil)
        
        return
        
    }
    
    func toggleCell(row: Int, col: Int) {
        let oldState = grid[row,col]
        let newState = oldState.toggle(value: oldState)
        grid[row, col] = newState
        somethingChanged()
    }
    
}

