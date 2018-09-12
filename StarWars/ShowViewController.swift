//
//  ShowViewController.swift
//  StarWars
//
//  Created by Quang Nguyen on 9/11/18.
//  Copyright © 2018 Quang Nguyen. All rights reserved.
//

import UIKit

class ShowViewController: UIViewController {
    
    @IBOutlet weak var firstLabel: UILabel!
    
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    var dict = [
        "firstLabelText" : "",
        "secondLabelText" : "",
        "thirdLabelText" : "",
        "fourthLabelText" : "",
        "fifthLabelText" : ""
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstLabel.text = dict["firstLabelText"]
        secondLabel.text = dict["secondLabelText"]
        thirdLabel.text = dict["thirdLabelText"]
        fourthLabel.text = dict["fourthLabelText"]
        fifthLabel.text = dict["fifthLabelText"]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
