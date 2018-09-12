//
//  PeopleViewController.swift
//  StarWars
//
//  Created by Quang Nguyen on 9/10/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class PeopleViewController: UITableViewController {
    var people:[String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        StarWarsModel.getAllPeople(startingFromUrl: "https://swapi.co/api/people",
                                   completionHandler: getPeopleRecursive)
    }
    
    func getPeopleRecursive(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        do {
            // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
            if let jsonResult = try JSONSerialization.jsonObject(
                with: data!,
                options: .mutableContainers
                ) as? NSDictionary {
                
                if let nextUrl = jsonResult.value(forKey: "next") as? NSString {
                    DispatchQueue.main.async { [unowned self] in
                        StarWarsModel.getAllPeople(startingFromUrl: nextUrl as String,
                                                   completionHandler: self.getPeopleRecursive)
                    }
                }
                
                if let results = jsonResult["results"] {
                    let resultsArray = results as! NSArray
                    self.loadPeopleArrWithResults(from: resultsArray)
                }
            }
        } catch let err {
            print(err)
        }
    }
    
    func loadPeopleArrWithResults(from results: NSArray) {
        for person in results {
            if let person = person as? NSDictionary{
                self.people.append(person.value(forKey: "name") as! String)
                DispatchQueue.main.async { [unowned self] in
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(people.count)
    }

}
