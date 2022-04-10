//
//  ViewController.swift
//  TicTacToe
//
//  Created by gliao on 2020-03-24.
//  Copyright © 2020 COMP2601. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let db = DBHelper() //Should I also have this in the DrawView.swift class?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func addRowToGames(p1stepsX: [Int], p1stepsY: [Int], p2stepsX: [Int], p2stepsY: [Int], outcome: String){
        self.db.insert(p1stepsX: p1stepsX, p1stepsY: p1stepsY, p2stepsX: p2stepsX, p2stepsY: p2stepsY, outcome: outcome)
    }
    
    //TODO: have a function for clicking a button that opens an alert with all the database data
    @IBAction func displayData(_ sender: UIButton){
        print("displayData button clicked")
        //TODO: call the read() function here?
        let list = self.db.read()
        var message = ""
        for index in 0..<list.count{
            message += "Id: "
            message += String(list[index].id)
            message += "\nPlayer 1 steps (X): ["
            for step in 0..<list[index].p1stepsX!.count{
                message += String(list[index].p1stepsX![step])
                if step != list[index].p1stepsX!.count - 1 {
                    message += ", "
                }
            }
            message += "]\nPlayer 1 steps (Y): ["
            for step in 0..<list[index].p1stepsY!.count{
                message += String(list[index].p1stepsY![step])
                if step != list[index].p1stepsY!.count - 1 {
                    message += ", "
                }
            }
            message += "]\nPlayer 2 steps (X): ["
            for step in 0..<list[index].p2stepsX!.count{
                message += String(list[index].p2stepsX![step])
                if step != list[index].p2stepsX!.count - 1 {
                    message += ", "
                }
            }
            message += "]\nPlayer 2 steps (Y): ["
            for step in 0..<list[index].p2stepsY!.count{
                message += String(list[index].p2stepsY![step])
                if step != list[index].p2stepsY!.count - 1 {
                    message += ", "
                }
            }
            message += "]\nOutcome:"
            message += list[index].outcome!
            message += "\n\n"
        }
        
        showMessage(title: "Database Data", message: message)
    }
    
    func showMessage(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

