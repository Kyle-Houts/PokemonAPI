//
//  ViewController.swift
//  PokemonAPI
//
//  Created by Kyle Houts on 10/23/18.
//  Copyright © 2018 Kyle Houts. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage



class ViewController: UIViewController {
    
    let baseURL = "https://pokeapi.co/api/v2/pokemon/"
    

    
    @IBOutlet weak var pokemonTextField: UITextField!
    
    @IBOutlet weak var speciesTextField: UITextField!
    
    @IBOutlet weak var abilitiesTextView: UITextView!
    
    @IBOutlet weak var statsTextView: UITextView!
    
    @IBOutlet weak var pokemonImage: UIImageView!
    
    @IBOutlet weak var movesTextView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func submitButtonTapped(_ sender: Any) {
        
        guard let pokemonNameOrID = pokemonTextField.text, pokemonNameOrID != "" else {
            return
        }
        
        
        // URL that we will use for our request
        let requestURL = baseURL + pokemonNameOrID.lowercased().replacingOccurrences(of: " ", with: "+")
        
        // Make our request
        let request = Alamofire.request(requestURL)
        
        // Carry out the request
        request.responseJSON { response in
            switch response.result {
            case .success(let value):
                
                let json = JSON(value)
                
                if let speciesName = json["species"]["name"].string {
                    self.speciesTextField.text = speciesName
                }
                
                if let abilitiesJSON = json["abilities"].array {
                    var abilitiesString = ""
                    for ability in abilitiesJSON {
                        if let abilityName = ability["ability"]["name"].string {
                            
                            abilitiesString += abilityName + "\n"
                            
                        }
                    }
                    self.abilitiesTextView.text = abilitiesString
                }
                
                if let movesJSON = json["moves"].array {
                    var movesString = ""
                    for moves in movesJSON {
                        if let movesName = moves["move"]["name"].string {
                            movesString += movesName + "\n"
                        }
                    }
                    self.movesTextView.text = movesString
                }
                
                
                
                if let statsJSON = json["stats"].array {
                    var statsString = ""
                    for stats in statsJSON {
                        if let statNames = stats["stat"]["name"].string {
                            statsString += statNames + "\n"
                        }
                    }
                    self.statsTextView.text = statsString
                }

               // This will pull out from front default sprite URL if possible
                if let spriteURL = json["sprites"]["front_default"].string {
                    if let url = URL(string: spriteURL) {
                        // Load this into the image view
                        self.pokemonImage.sd_setImage(with: url, completed: nil)
                    }
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
                
            }
        }
    }
}

