//
//  ViewController.swift
//  P5-Quiz
//
//  Created by JESUS on 19/11/2018.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit



struct Quizzes: Codable{
    let quizzes: [Quiz]
    let pageno: Int
    let nextUrl: String
}

struct Quiz: Codable {
    
    let id: Int
    let question: String
    let author: Author?
    let attachment: Attachment?
    let favourite: Bool
    let tips: [String]
    
    struct Author: Codable {
        let id: Int
        let isAdmin: Bool?
        let username: String
    }
    
    struct Attachment: Codable {
        let filename: String
        let mime: String
        let url: String
    }
}

class ViewController: UIViewController, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    /*final let url = URL(string:"https://quiz2019.herokuapp.com/api/quizzes?token=3b0d9d051c13f605e68c")*/
    
    
    var quizzes = [Quiz]()
    var lasUrlsDescargadas = [String]()
    var losAutores = [String]()
    var lasPreguntas = [String]()
    var losId = [Int]()
    var losTipVC = [[String]]()
    var imagesCache = [String:UIImage]()
    
    
    var nextHopUrl: String = "https://quiz2019.herokuapp.com/api/quizzes?token=75bce630e75b90e53711&pageno=1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
        //tableView.tableFooterView = UIView()
        tableView.rowHeight = 130
    }
    
    func downloadJson() {
        
        let url = URL(string: nextHopUrl)
        
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            do
            {
                let decoder = JSONDecoder()
                let downloadedQuizz = try decoder.decode(Quizzes.self, from: data)
                
                
                DispatchQueue.main.async {
                    self.quizzes = downloadedQuizz.quizzes
                    print(self.quizzes.count)
                    for i in 0..<self.quizzes.count{
                        
                        if(self.quizzes[i].attachment?.url == nil || self.quizzes[i].attachment!.url.isEmpty || self.quizzes[i].attachment!.mime == "image/gif"){
                            self.lasUrlsDescargadas.append("laimagenestavacia")
                        }else if (self.quizzes[i].attachment!.mime == "image/jpeg" || self.quizzes[i].attachment!.mime == "image/png"){
                            self.lasUrlsDescargadas.append(self.quizzes[i].attachment!.url)
                        }
                        if(self.quizzes[i].author == nil){
                            self.losAutores.append("unknown user")
                        }else{
                            self.losAutores.append(self.quizzes[i].author!.username)
                        }
                        self.lasPreguntas.append(self.quizzes[i].question)
                        self.losId.append(self.quizzes[i].id)
                        self.losTipVC.append(self.quizzes[i].tips)
                        
                    }
                    
                    print(self.lasUrlsDescargadas)
                    self.nextHopUrl = downloadedQuizz.nextUrl
                    if(self.nextHopUrl != ""){
                        self.downloadJson()
                    }
                    
                    self.tableView.reloadData()
                }
                
                
                
            } catch let parsingError {
                print("Error", parsingError)
            }
            }.resume()

    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("paso1")
        return lasUrlsDescargadas.count//quizzes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuizCell") as? QuizCell else { return UITableViewCell() }
        print("paso2")
        
        
        cell.autorLbl.text = losAutores[indexPath.row]//quizzes[indexPath.row].author?.username
        cell.questionLbl.text = lasPreguntas[indexPath.row]//quizzes[indexPath.row].question
        
        cell.contentView.backgroundColor = UIColor.darkGray
        cell.backgroundColor = UIColor.darkGray
        
        if lasUrlsDescargadas[indexPath.row] == "laimagenestavacia"{
            cell.imgView?.image = UIImage(named: "imageNotFound")
            return cell
        }
    
        if let img = imagesCache[lasUrlsDescargadas[indexPath.row]]{
            cell.imgView?.image = img
        }else{
            cell.imgView?.image = UIImage(named: "imageNotFound")
            download(lasUrlsDescargadas[indexPath.row],indexPath)
        }

        return cell
        
    }
    
    func download(_ urls: String,_ indexpath: IndexPath){
        print("bajando",urls)
        DispatchQueue.global().async {
            if let url = URL(string: urls),
                let data = try? Data(contentsOf: url),
                let img = UIImage(data: data){
                
                DispatchQueue.main.async {
                    self.imagesCache[urls] = img
                    self.tableView.reloadRows(at: [indexpath], with: .fade)
                }
            }else{
                print("MAL",urls)
                
                DispatchQueue.main.async {
                    self.imagesCache[urls] = UIImage(named: "imageNotFound")
                }
            }
        }
    }
    
    
    @IBAction func refreshButtonAction(_ sender: UIBarButtonItem) {
        if(nextHopUrl == ""){
            lasUrlsDescargadas.removeAll()
            losAutores.removeAll()
            lasPreguntas.removeAll()
            losId.removeAll()
            losTipVC.removeAll()
            //imagesCache.removeAll()
        self.nextHopUrl = "http://quiz2019.herokuapp.com/api/quizzes?token=75bce630e75b90e53711&pageno=1"
        downloadJson()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "QuizQuestion" {
            
            let oqvc = segue.destination as! OneQuizViewController
            
            if let ip = tableView.indexPathForSelectedRow {
                oqvc.question = lasPreguntas[ip.row]
                oqvc.myQuizImage = lasUrlsDescargadas[ip.row]
                oqvc.id = losId[ip.row]
                oqvc.losTips = losTipVC[ip.row]
                print(oqvc.id)
            }
        }
    }
}

