//
//  GridDataObj.swift
//  FinalProject
//
//  Created by Stefan Himmel on 7/24/17.
//  Copyright © 2017 Harvard University. All rights reserved.
//

import Foundation

/// Failable initializer (that needs an initializer with the default functionality


struct GridDataObj {

    var title: String
    var contents: Array<Array<Int>>
    
    init(title: String, contents: Array<Array<Int>>) {
        self.title = title
        self.contents = contents
    }
}
 
