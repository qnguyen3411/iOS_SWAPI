//
//  FilmsViewController.swift
//  StarWars
//
//  Created by Quang Nguyen on 9/11/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class Film {
    var title:String
    var releaseDate: String
    var director: String
    var openingCrawl: String
    
    init(title:String, releaseDate:String, director:String, openingCrawl:String){
        self.title = title
        self.releaseDate = releaseDate
        self.director = director
        self.openingCrawl = openingCrawl
    }
}


class FilmsViewController: UITableViewController {
    
    var films:[Film] = []
    
    override func viewDidLoad() {
        StarWarsModel.getAllFilms(){ data, response, error in
            do {
                // try converting the JSON object to "Foundation Types" (NSDictionary, NSArray, NSString, etc.)
                guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary  else {
                    return
                }
                guard let filmsQueryResult = jsonResult["results"] as? NSArray else {
                    return
                }
                for film in filmsQueryResult {
                    guard let film = film as? NSDictionary else {
                        continue
                    }
                    self.films.append(
                        Film(title: film["title"] as! String,
                             releaseDate: film["release_date"] as! String,
                             director: film["director"] as! String,
                             openingCrawl: film["opening_crawl"] as! String)
                    )
                }
                DispatchQueue.main.async { [unowned self] in
                    self.tableView.reloadData()
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
        cell.textLabel?.text = films[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowFilmSegue", sender: films[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let showVC = segue.destination as? ShowViewController else {
            return
        }
        if let film = sender as? Film{
            showVC.dict["firstLabelText"] = "Title: \(film.title)"
            showVC.dict["secondLabelText"] = "Release Date: \(film.releaseDate)"
            showVC.dict["thirdLabelText"] = "Director: \(film.director)"
            showVC.dict["fourthLabelText"] = "\(film.openingCrawl)"
        }
    }

}
