//
//  OneQuizViewController.swift
//  P5-Quiz
//
//  Created by JESUS on 22/11/2018.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit



struct QuestionWithAnswer: Codable{
    let quizId: Int
    let answer: String
    let result: Bool
}

class OneQuizViewController: UIViewController {

    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var imgView: UIImageView!
   
    var id: Int = 0
    var question: String = ""
    var imagen: String = ""
    var myQuizImage: String = ""
    var isTrue: Bool = false
    var response: String = ""
    var losTips = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionLbl.text = question
        if let imageURL = URL(string: myQuizImage){//quizzes[indexPath.row].attachment!.url) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                       self.imgView.image = image
                    }
                }
            }
        }
        
        //self.txtField.becomeFirstResponder()
    
    }
    

    //"https://quiz2019.herokuapp.com/api/quizzes/"+String(self.id)+"?token=3b0d9d051c13f605e68c"
 
    @IBAction func buttonTapped(_ sender: UIButton) {
        
        if(txtField.text == nil || txtField.text == ""){
            return
        }
        //https://quiz2019.herokuapp.com/api/quizzes/3/check?token=3b0d9d051c13f605e68c&answer=Madrid
        
        let comprobar = "https://quiz2019.herokuapp.com/api/quizzes/"+String(self.id)+"/check?token=75bce630e75b90e53711&answer="+String(txtField.text!)
        
        let comprobada = comprobar.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        let urlResponse = URL(string: comprobada!)
        
        
        guard let downloadURL = urlResponse else { return }
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            do
            {
                let decoder = JSONDecoder()
                let downloadedQuizz = try decoder.decode(QuestionWithAnswer.self, from: data)
                
                DispatchQueue.main.async {
                    self.isTrue = downloadedQuizz.result
                    if(self.isTrue == true){
                        
                        // create the alert

                        let alert = UIAlertController(title: "CORRECTO", message: "La respuesta introducida ha sido\n ["+String(self.txtField.text!)+"]", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        //fondo alerta verde
                        let backView = alert.view.subviews.last?.subviews.last
                        backView?.layer.cornerRadius = 10.0
                        backView?.backgroundColor = UIColor.green
                        //color de texto
                        //alert.view.tintColor = UIColor.green
                        
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        // create the alert
                        let alert = UIAlertController(title: "INCORRECTO", message: "La respuesta introducida ha sido\n  ["+String(self.txtField.text!)+"] intentalo de nuevo o mira las pistas", preferredStyle: UIAlertControllerStyle.alert)
                        
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
                        //fondo alerta verde
                        let backView = alert.view.subviews.last?.subviews.last
                        backView?.layer.cornerRadius = 10.0
                        backView?.backgroundColor = UIColor.red
                        //color de texto
                        //alert.view.tintColor = UIColor.red

                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                }
            } catch {
                print("something wrong after being downloaded")
            }
            }.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "TipCell" {
            
            let tctvc = segue.destination as! TipCellTableViewController
            tctvc.showTips = losTips
        }
    }

}
