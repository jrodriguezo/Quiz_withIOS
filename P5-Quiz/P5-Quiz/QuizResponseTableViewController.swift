//
//  QuizResponseTableViewController.swift
//  P5-Quiz
//
//  Created by JESUS on 19/11/2018.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit

class QuizResponseTableViewController: UITableViewController {
    
    var id: Int = 0
    var imagen: String = ""
    
    
    var question: String = ""
    var bounds: CGRect = UIScreen.main.bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadJson()
        tableView.tableFooterView = UIView()
        tableView.rowHeight = bounds.size.height
        
    }
    
    func downloadJson() {
        var url = URL(string:"https://quiz2019.herokuapp.com/api/quizzes/"+String(self.id)+"?token=3b0d9d051c13f605e68c")
        
        guard let downloadURL = url else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            print(self.id)
            do
            {
                let decoder = JSONDecoder()
                let downloadedQuizz = try decoder.decode(oneQuizz.self, from: data)
                self.question = downloadedQuizz.question
                let downloadedQuiz = try decoder.decode(Quiz.self, from: data)
                self.imagen = downloadedQuiz.attachment!.url
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("something wrong after being downloaded")
            }
            }.resume()
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuizResponse") as? QuizResponseTableViewCell else { return UITableViewCell() }
        
        cell.preguntaLbl.text = self.question
        
         if let imageURL = URL(string: imagen) {
         DispatchQueue.global().async {
         let data = try? Data(contentsOf: imageURL)
         if let data = data {
         let image = UIImage(data: data)
         DispatchQueue.main.async {
         cell.imgView.image = image
         }
         }
         }
         }
        return cell
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
        return 1
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
