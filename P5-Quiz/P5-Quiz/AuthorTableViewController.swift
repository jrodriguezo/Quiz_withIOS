//
//  AuthorTableViewController.swift
//  P5-Quiz
//
//  Created by g838 DIT UPM on 23/11/2018.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit


struct Author: Codable{
        let id: Int
        let isAdmin: Bool?
        let username: String
}


class AuthorTableViewController: UITableViewController {
    
    var losAutores = [Author]()
    var losUsuarios = [String]()
    var losAdmin = [Bool]()
    
    override func viewWillAppear(_ animated: Bool){
        super.viewDidAppear(animated)
            title = "wait ..."
            //downloadJson()
            tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
    }
    
    //https://quiz2019.herokuapp.com/api/users?token=3b0d9d051c13f605e68c
    //"https://quiz2019.herokuapp.com/api/users?token=75bce630e75b90e53711"
    
    func downloadJson() {
        guard let url = URL(string:"https://quiz2019.herokuapp.com/api/users?token=75bce630e75b90e53711") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            
            /*do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }*/
            do {
                //here dataResponse received from a network request
                let decoder = JSONDecoder()
                let model = try decoder.decode([Author].self, from:dataResponse)
               
                DispatchQueue.main.async{
                    self.losAutores = model
                    /*DispatchQueue.main.sync{
                     self.losAutores = model
                     }*/
                    self.printInfo(model)
                    print(self.losAutores)
                    for i in 0..<self.losAutores.count{
                        self.losUsuarios.append(self.losAutores[i].username)
                        if(self.losAutores[i].isAdmin == nil){
                            self.losAdmin.append(false)
                        }else{
                            self.losAdmin.append(self.losAutores[i].isAdmin!)
                        }
                    }
                self.tableView.reloadData()
                }
                
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return losUsuarios.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AuthorCell", for: indexPath)
        
        title = "Autores"
        cell.textLabel?.text = losUsuarios[indexPath.row]// losUsername[indexPath.row]
        
        if(losAdmin[indexPath.row] == true){
        cell.detailTextLabel?.text = "True, this user is admin"
        }else{
        cell.detailTextLabel?.text = "False, this user is not admin"
        }

        return cell
    }
    
    func printInfo(_ value: Any) {
        let typePrinted = type(of: value)
        print("'\(value)' of type '\(typePrinted)'")
    }

}
