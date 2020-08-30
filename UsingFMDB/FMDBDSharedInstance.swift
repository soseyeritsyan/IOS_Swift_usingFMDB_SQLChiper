//
//  UsingFMDB.swift
//  UsinfFMDB
//
//  Created by Sose Yeritsyan on 6/15/20.
//  Copyright © 2020 Sose Yeritsyan. All rights reserved.
//


/*
 first implement FMDB with pod file
 after I don't need to create bridging header file
 in build settings change if need
    swift compiler general -> objective c bridging header

*/


import Foundation
import FMDB
import SQLite3

let sharedInstance = FMDBDSharedInstance()
class FMDBDSharedInstance: NSObject {

    var database: FMDatabase?
    private let key = "xyz123"
    class func getInstance() -> FMDBDSharedInstance
    {
        if (sharedInstance.database == nil)
        {
        sharedInstance.database = FMDatabase(path: Util.getPath(fileName: "UsingFMDB.sqlite"))
        }
        
        sharedInstance.database?.setKey(sharedInstance.key)
        return sharedInstance
    }
    

    func createDB() {
        guard database!.open() else {
            print("Unable to open database")
            return
        }
        database?.setKey(key)
        do {
            try database!.executeUpdate("create table if not exists usersTBL(firstname text, lastname text, birthday Date, ismale integer, height integer, weight integer, phone text, email text primary key, password text)", values: nil)
        } catch {
            print("DB is not created")
        }
        
    }

    func insertData(user: User) -> Bool {
        sharedInstance.database!.open()
        database?.setKey(key)
        
        let isSave = sharedInstance.database?.executeUpdate("INSERT INTO usersTBL(firstname , lastname , birthday , ismale , height , weight , phone, email, password) VALUES (?,?,?,?,?,?,?,?,?)", withArgumentsIn: [user.firstname,user.lastname,user.birthday,user.ismale,user.height,user.weight,user.phone,user.email,user.password])
        sharedInstance.database?.close()
        return isSave!

    }
    
    func getAllData() -> [User] {
        sharedInstance.database!.open()
        database?.setKey(key)

        var returnedUsers = [User]()
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM usersTBL", withArgumentsIn: [0])

        if (resultSet != nil) {
            while resultSet.next() {

                let item = User()
                item.firstname = String(resultSet.string(forColumn: "firstname")!)
                item.lastname = String(resultSet.string(forColumn: "lastname")!)
                item.birthday = resultSet.date(forColumn: "birthday")!
                item.ismale = Int(resultSet.int(forColumn: "ismale"))
                item.height = Int(resultSet.int(forColumn: "height"))
                item.weight = Int(resultSet.int(forColumn: "weight"))
                item.phone = String(resultSet.string(forColumn: "phone")!)
                item.email = String(resultSet.string(forColumn: "email")!)
                item.password = String(resultSet.string(forColumn: "password")!)

                returnedUsers.append(item)
            }
        }

        sharedInstance.database!.close()
        return returnedUsers
    }

    func updateRecode(user: User) {
        sharedInstance.database!.open()
        database?.setKey(key)


        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("UPDATE usersTBL SET firstname = ?,lastname = ?,birthday = ?, ismale = ?,height = ?,weight = ?, phone = ?, password = ? WHERE email = ?", withArgumentsIn: [user.firstname, user.lastname, user.birthday, user.ismale, user.height, user.weight, user.phone, user.password, user.email])

        if (resultSet != nil) {
            while resultSet.next() {
                let item = User()
                item.firstname = String(resultSet.string(forColumn: "firstname")!)
                item.lastname = String(resultSet.string(forColumn: "lastname")!)
                item.birthday = resultSet.date(forColumn: "birthday")!
                item.ismale = Int(resultSet.int(forColumn: "ismale"))
                
                item.height = Int(resultSet.int(forColumn: "height"))
                item.weight = Int(resultSet.int(forColumn: "weight"))
                item.phone = String(resultSet.string(forColumn: "phone")!)
                item.email = String(resultSet.string(forColumn: "email")!)
                item.password = String(resultSet.string(forColumn: "password")!)
            }
        }

        sharedInstance.database!.close()

    }
    func deleteRecode(email: String) {
        database!.open()
        database?.setKey(key)

        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("DELETE FROM usersTBL WHERE email = ?", withArgumentsIn: [email])

        if (resultSet != nil) {
            while resultSet.next() {
                
                let item = User()
                item.firstname = String(resultSet.string(forColumn: "firstname")!)
                item.lastname = String(resultSet.string(forColumn: "lastname")!)
                item.birthday = resultSet.date(forColumn: "birthday")!
                item.ismale = Int(resultSet.int(forColumn: "ismale"))
                
                item.height = Int(resultSet.int(forColumn: "height"))
                item.weight = Int(resultSet.int(forColumn: "weight"))
                item.phone = String(resultSet.string(forColumn: "phone")!)
                item.email = String(resultSet.string(forColumn: "email")!)
                item.password = String(resultSet.string(forColumn: "password")!)
            }
        }

        sharedInstance.database!.close()
    }

  
    
    func tryLogIn(email: String?, password: String?)->String {
        database!.open()
        database?.setKey(key)

        var outputstr = "your email \(email!) and password \(password!) is incorrect"
        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM usersTBL WHERE email = ? AND password = ?",  withArgumentsIn: [email!, password!])
        if (resultSet != nil) {
            while resultSet.next() {
                    outputstr = "your email \(email!) and password \(password!) is correct"
            }
        }
        return outputstr
    }
    

    
    func findUserByEmail(email: String?) -> User? {
        database!.open()
        database?.setKey(key)

        let resultSet:FMResultSet! = sharedInstance.database!.executeQuery("SELECT * FROM usersTBL WHERE email = ?", withArgumentsIn: [email!])

        if (resultSet != nil) {
            
            let item = User()
            while resultSet.next() {
                item.firstname = String(resultSet.string(forColumn: "firstname")!)
                item.lastname = String(resultSet.string(forColumn: "lastname")!)
                item.birthday = resultSet.date(forColumn: "birthday")!
                item.ismale = Int(resultSet.int(forColumn: "ismale"))
                item.height = Int(resultSet.int(forColumn: "height"))
                item.weight = Int(resultSet.int(forColumn: "weight"))
                item.phone = String(resultSet.string(forColumn: "phone")!)
                item.email = String(resultSet.string(forColumn: "email")!)
                item.password = String(resultSet.string(forColumn: "password")!)
                print(item)
                return item
        }
        }
            return nil
        
    }
    
}
