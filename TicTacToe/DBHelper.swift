//
//  DBHelper.swift
//  TicTacToe
//
//  Created by Victor Yang on 2022-04-10.
//  Copyright © 2022 COMP2601. All rights reserved.
//

import Foundation
import SQLite3

class DBHelper{
    var db : OpaquePointer?
    var path : String = "gamesDb.sqlite" //path of the SQLite database
    init(){
        self.db = createDB()
        self.createTable()
    }
    
    //function for creating the database
    func createDB() -> OpaquePointer? {
        print("Creating Database")
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathExtension(path)
        
        var db : OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        }else {
            print("Database has been created with path \(path)")
            return db
        }
    }
    
    //function for creating the table in the database
    func createTable()  {
        print("Creating table if not exists")
        let query = "CREATE TABLE IF NOT EXISTS games(id INTEGER PRIMARY KEY AUTOINCREMENT, p1stepsX TEXT, p1stepsY TEXT, p2stepsX TEXT, p2stepsY TEXT, outcome TEXT)" //I changed arrays to 'TEXT' from 'BLOBs'
        var createTable : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &createTable, nil) == SQLITE_OK {
            if sqlite3_step(createTable) == SQLITE_DONE { //table has been created
                print("Table creation success")
            } else {
                print("Table creation fail")
            }
        } else {
            print("Prepration fail")
        }
    }
    
    //function for inserting a new game into the database table 'games'
    func insert(p1stepsX: [Int], p1stepsY: [Int], p2stepsX: [Int], p2stepsY: [Int], outcome: String){
        print("Inserting new game into the games table")
        let query = "INSERT INTO games (id, p1stepsX, p1stepsY, p2stepsX, p2stepsY, outcome) VALUES (?, ?, ?, ?, ?, ?)"
        
        var statement : OpaquePointer? = nil
        
        var isEmpty = false
        if read().isEmpty{
            isEmpty = true
        }
                
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            if isEmpty {
                sqlite3_bind_int(statement, 1, 1)
            }
            
            let data1 = try! JSONEncoder().encode(p1stepsX)
            let listString1 = String(data: data1, encoding: .utf8)
            sqlite3_bind_text(statement, 2, (listString1! as NSString).utf8String, -1, nil)
            
            let data2 = try! JSONEncoder().encode(p1stepsY)
            let listString2 = String(data: data2, encoding: .utf8)
            sqlite3_bind_text(statement, 3, (listString2! as NSString).utf8String, -1, nil)
            
            let data3 = try! JSONEncoder().encode(p2stepsX)
            let listString3 = String(data: data3, encoding: .utf8)
            sqlite3_bind_text(statement, 4, (listString3! as NSString).utf8String, -1, nil)
            
            let data4 = try! JSONEncoder().encode(p2stepsY)
            let listString4 = String(data: data4, encoding: .utf8)
            sqlite3_bind_text(statement, 5, (listString4! as NSString).utf8String, -1, nil)
            
            sqlite3_bind_text(statement, 6, (outcome as NSString).utf8String, -1, nil)
            
            if sqlite3_step(statement) == SQLITE_DONE {
                print("Data inserted success")
            }else {
                print("Data is not inserted in table")
            }
        } else {
            print("Query is not as per requirement")
        }
    }
    
    //function for querying all data in the database
    func read() -> [Game]{
        var list = [Game]()
        print("Select all games from the games table")
        
        let query = "SELECT * FROM games;"
        var statement : OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &statement, nil) == SQLITE_OK{
            while sqlite3_step(statement) == SQLITE_ROW { //while we are still checking a row in the table
                let id = Int(sqlite3_column_int(statement, 0))
                let p1stepsX = String(describing: String(cString: sqlite3_column_text(statement, 1)));
                let p1stepsY = String(describing: String(cString: sqlite3_column_text(statement, 2)));
                let p2stepsX = String(describing: String(cString: sqlite3_column_text(statement, 3)));
                let p2stepsY = String(describing: String(cString: sqlite3_column_text(statement, 4)));
                let outcome = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                
                let model = Game()
                model.id = id
                let data1 = try! JSONDecoder().decode([Int].self, from: p1stepsX.data(using: .utf8)!)
                model.p1stepsX = data1
                let data2 = try! JSONDecoder().decode([Int].self, from: p1stepsY.data(using: .utf8)!)
                model.p1stepsY = data2
                let data3 = try! JSONDecoder().decode([Int].self, from: p2stepsX.data(using: .utf8)!)
                model.p2stepsX = data3
                let data4 = try! JSONDecoder().decode([Int].self, from: p2stepsY.data(using: .utf8)!)
                model.p2stepsY = data4
                model.outcome = outcome
                
                list.append(model)
            }
        }
                
        return list
    }
    
}
