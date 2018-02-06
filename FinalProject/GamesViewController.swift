//
//  FruitViewControllerTableViewController.swift
//  lecture10
//
//  Created by Stefan Himmel on 7/19/17.
//  Copyright © 2017 Stefan. All rights reserved.
//

import UIKit

class GamesViewController: UITableViewController {
    var sectionHeaders = ["empty"]
    var data: [[GridDataObj]] = [[]]
    
    func add() {
        var newSection = data[0]
        let newGridData = GridDataObj(title: "Unnamed Configuration", contents: [[]])
        newSection.append(newGridData)
        data[0] = newSection
        
        tableView.reloadData()
        let indexPath = IndexPath(item: data[0].count - 1, section: 0)
        
        tableView.selectRow(at: indexPath, animated: false, scrollPosition: UITableViewScrollPosition.none)
    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()

        setupListener() // for saves from SaveViewController
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        // Make a network call to pull down the json file from the web using a known URL
        if let gridsUrl = URL(string: "https://dl.dropboxusercontent.com/u/7544475/S65g.json?dl=1") {
            let dataTask = URLSession.shared.dataTask(with: gridsUrl) {
                (data, response, error) in
            
                if let error = error{
                    print(error)
                } else {
                    //parsing JSON
                    self.setData(data: data!)
                }

            }
            dataTask.resume()
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return data.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gameCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title

        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? { //gets the header sections
        return sectionHeaders[section]
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) { // supports deleting
        if editingStyle == .delete {
            var newData = data[indexPath.section]
            newData.remove(at: indexPath.row)
            data[indexPath.section] = newData
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destination = segue.destination as? EditorViewController { //check for certain segue destination
            if let indexPath = tableView.indexPathForSelectedRow {
                let gameTitle = data[indexPath.section][indexPath.row].title
                destination.gameTitle = gameTitle
                
                contentsToGrid(contents: data[indexPath.section][indexPath.row].contents)
                StandardEngine.singleton.title = data[indexPath.section][indexPath.row].title
                
                destination.completion = { (newTitle, newGrid) in
                    self.data[indexPath.section][indexPath.row].title = newTitle
                    self.data[indexPath.section][indexPath.row].contents = self.gridToContents(grid: newGrid)
                    StandardEngine.singleton.title = newTitle
                    StandardEngine.singleton.newGrid(grid: newGrid, rows: newGrid.size.rows, cols: newGrid.size.cols)
                    self.tableView.reloadData()
                    destination.dismiss(animated: true)
                }
            }
        }
        
    }
    
    func setData(data: Data){
        //parsing JSON
        
        let jsonObject: Array<Dictionary<String,Any>>?
        
        do {
            jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Array<Dictionary<String,Any>>
        } catch {
            print("JSON Parsing failure: \(error)")
            return
        }
        
        jsonObject?.forEach{ // turns data into array of GridDataObjs
            item in
            let title = item["title"] as? String
            let contents = item["contents"] as? Array<Array<Int>>
            let tempObj = GridDataObj(title: title! , contents: contents!)
            self.data[0].append(tempObj)
        }
        
        self.data[0].sort{ //sorts data
            $0.title < $1.title
        }
        
        self.sectionHeaders = ["saved"]

        DispatchQueue.main.async { //run on main thread
            self.tableView.reloadData()
        }
    }
    
    func contentsToGrid(contents: [[Int]]){
        
        if contents[0] == [] { //if new addition create 10X10 empty grid
            StandardEngine.singleton.newGrid(grid: Grid(10,10), rows: 10, cols: 10)
            return
        }
        
        var minSize = 0
        contents.forEach{ //gets minSize for newGrid
            item in
            
            if item[0] > minSize {
                minSize = item[0]
            }
            if item[1] > minSize {
                minSize = item[1]
            }
            
        }
        
        var newGrid = Grid(minSize+10, minSize+10)
        
        contents.forEach{
            item in newGrid[item[0], item[1]] = .alive
        }
        
        StandardEngine.singleton.newGrid(grid: newGrid, rows: minSize+10 , cols: minSize+10)
    }
    
    func gridToContents(grid: GridProtocol) -> Array<Array<Int>> {
        // turns a GridProtocol into the same type of contents array we got from the JSON parsing
        var newContents: Array<Array<Int>> = []
        var empty = true
        for i in 0 ... grid.size.rows-1 { 
            for j in 0 ... grid.size.cols-1 {
                if grid[i,j].isAlive{
                    empty = false
                    newContents.append([i,j])
                }
            }
        }
        if empty{
            newContents = [[]]
        }
        return newContents
    }
    
    func setupListener() {
        let notificationSelector = #selector(storeSave(notification:))
        NotificationCenter.default.addObserver(self, selector: notificationSelector, name: NSNotification.Name(rawValue: "save"), object: nil)
    }
    
    
    func storeSave(notification: Notification) {
        guard let saveTitle = notification.userInfo?["title"] as? String,
            let oldTitle = notification.userInfo?["oldTitle"] as? String,
            let saveContents = notification.userInfo?["contents"] as? Array<Array<Int>> else {
            return
        }
        
        var newSection = data[0]
        let newGridData = GridDataObj(title: saveTitle, contents: saveContents)
        
        for i in 0 ..< newSection.count{ //had to do for loop because immutable objects
            if newSection[i].title == oldTitle{ //overwrite case
                newSection[i] = newGridData
                data[0] = newSection
                tableView.reloadData()
                return
            }
        }

        //new entry case
        newSection.append(newGridData)
        data[0] = newSection
        
        tableView.reloadData()
    }
}


