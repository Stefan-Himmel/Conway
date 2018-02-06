//
//  EngineProtocol.swift
//  Final Project
//
//  Created by Stefan Himmel on 7/12/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import Foundation

protocol EngineProtocol {
    
    var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get }
    var refreshTimer : Timer? { get set }
    var rows: Int { get set }
    var cols: Int { get set }
    
    init(rows: Int, cols: Int)
    
    func step() -> GridProtocol
    
    func toggleCell(row: Int, col: Int)
    
    func somethingChanged()
}

extension EngineProtocol { //had to do this to get default values
    var refreshRate: Double { get {return 0} set {} }
    
}
