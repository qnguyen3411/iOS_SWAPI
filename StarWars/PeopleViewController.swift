//
//  PeopleViewController.swift
//  StarWars
//
//  Created by Quang Nguyen on 9/10/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class Person {
    var name:String
    var gender: String
    var birthYear: String
    var mass: String
    var species: String
    
    init(name: String = "", gender: String = "", birthYear: String = "",
            mass: String = "", species: String = "") {
        self.name = name
        self.gender = gender
        self.birthYear = birthYear
        self.mass = mass
        self.species = species
    }
    
    func setSpecies(fromUrl speciesUrl: String) {
        StarWarsModel.getSpecies(fromSpeciesUrl: speciesUrl) { data, response, error in
            do {
                guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary  else { return }
                self.species = jsonResult["name"] as! NSString as String
            } catch let err {
                print(err)
            }
        }
    }
}

class PeopleViewController: UITableViewController {
    
    var people:[Person] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        StarWarsModel.getAllPeople(startingFromUrl: "https://swapi.co/api/people",
                                   completionHandler: populateTable)
    }
    
    func populateTable(_ data: Data?, _ response: URLResponse?, _ error: Error?) {
        do {
            guard let jsonResult = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary  else { return }
            
            // If there is a next page, recursively request for all people on next page
            if let nextUrl = jsonResult["next"] as? NSString {
                StarWarsModel.getAllPeople(startingFromUrl: nextUrl as String,
                                           completionHandler: self.populateTable)
            }
                
            guard let results = jsonResult["results"] else { return }
            let resultsArray = results as! NSArray
            self.loadPeopleArrWithResults(from: resultsArray)
            
            DispatchQueue.main.async { [unowned self] in
                self.tableView.reloadData()
            }
        } catch let err {
            print(err)
        }
    }
    
    func loadPeopleArrWithResults(from results: NSArray) {
        for person in results {
            guard let person = person as? NSDictionary else { continue }
            let newPerson =  Person(name: person["name"] as! String,
                                    gender: person["gender"] as! String,
                                    birthYear: person["birth_year"] as! String,
                                    mass: person["mass"] as! String)
            
            if let speciesUrl = (person["species"] as! NSArray).firstObject as? String {
               newPerson.setSpecies(fromUrl: speciesUrl)
            }
            
            self.people.append(newPerson)
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowPersonSegue", sender: people[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let showVC = segue.destination as? ShowViewController else {
            return
        }
        if let person = sender as? Person{
            showVC.dict["firstLabelText"] = "Name: \(person.name)"
            showVC.dict["secondLabelText"] = "Gender: \(person.gender)"
            showVC.dict["thirdLabelText"] = "Birth Year: \(person.birthYear)"
            showVC.dict["fourthLabelText"] = "Mass: \(person.mass)"
            showVC.dict["fifthLabelText"] = "Species: \(person.species)"
        }
    }

}
