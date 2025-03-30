//
//  SosViewController.swift
//  PoliceApp
//
//  Created by Aziza Gilash on 29.03.2025.
//

import UIKit

class SosViewController: UIViewController {
    
    @IBOutlet weak var sosButton: UIButton!
    // 
    
    @IBAction func sosButtonTapped(_ sender: UIButton) {
        callPolice()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func showCallConfirmation() {
        let alert = UIAlertController(
            title: "Экстренный вызов",
            message: "Вы уверены, что хотите позвонить в полицию?",
            preferredStyle: .alert
        )
        
        let callAction = UIAlertAction(title: "Позвонить", style: .destructive) { _ in
            self.callPolice()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        
        alert.addAction(callAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func callPolice() {
        if let phoneURL = URL(string: "tel://102") {
            if UIApplication.shared.canOpenURL(phoneURL) {
                UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
            } else {
                showErrorAlert()
            }
        }
    }
    
    func showErrorAlert() {
        let alert = UIAlertController(
            title: "Ошибка",
            message: "Звонок невозможен на этом устройстве",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }


        

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
