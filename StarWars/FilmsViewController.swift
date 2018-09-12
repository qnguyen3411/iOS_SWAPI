//
//  FilmsViewController.swift
//  StarWars
//
//  Created by Quang Nguyen on 9/11/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class FilmsViewController: UITableViewController {
    var films:[String] = []
    override func viewDidLoad() {
        StarWarsModel.getAllFilms(){ data, response, error in
            do {
                // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                if let jsonResult = try JSONSerialization.jsonObject(
                    with: data!,
                    options: .mutableContainers
                    ) as? NSDictionary {
                    
                    if let results = jsonResult["results"] {
                        let resultsArray = results as! NSArray
                        for film in resultsArray {
                            if let film = film as? NSDictionary{
                                self.films.append(film.value(forKey: "title") as! String)
                                DispatchQueue.main.async { [unowned self] in
                                    self.tableView.reloadData()
                                }
                            }
                        }
                    }
                }
            } catch let err {
                print(err)
            }
        }
        
        super.viewDidLoad()
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
        return films.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilmCell", for: indexPath)
        cell.textLabel?.text = films[indexPath.row]
        return cell
    }

}
