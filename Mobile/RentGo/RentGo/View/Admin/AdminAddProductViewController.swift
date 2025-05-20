//
//  AdminAddProductViewController.swift
//  RentGo
//
//  Created by Eray İnal on 20.05.2025.
//

import UIKit

class AdminAddProductViewController: UIViewController, URLSessionDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UITextField!
    @IBOutlet weak var productDescriptionLabel: UITextField!
    @IBOutlet weak var productPricePerWeekLabel: UITextField!
    @IBOutlet weak var productPricePerMonthLabel: UITextField!
    @IBOutlet weak var productCategoryButton: UIButton!
    
    
    var selectedCategoryId: String?
    var tempImageUrl: String = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS-PRicSM62TPGkzTxl74cjerevt241-AWX0KH1o6_tFeuu25TmdznU4A&s=10"
    let categoryMap: [String: String] = [
        "Personal Care": "A1E4DCD5-9FDA-4C9B-915F-32C4E9A1B8C3",
        "Hobbies & Games": "B2F5E1C6-2ACE-4D35-9E4C-9F1D2A3E4B5C",
        "Smart Home": "C3D6F2B7-7BBC-4B0A-8F5D-A2B3C4D5E6F7",
        "Baby & Kids": "D4E7C3A8-3ABC-4EF5-9B6D-B3C2A1F4E5D6",
        "Phones": "E5F8D4B9-1DEF-4C65-9C7E-C4D5A6B7C8D9"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        productImageView.isUserInteractionEnabled = true
        productImageView.addGestureRecognizer(tapGesture)
    }
    
    
    @objc func selectImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let editedImage = info[.editedImage] as? UIImage {
            productImageView.image = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            productImageView.image = originalImage
        }
        
        // Sadece görsel gösterilecek, backend'e sabit URL gönderilecek
        tempImageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS-PRicSM62TPGkzTxl74cjerevt241-AWX0KH1o6_tFeuu25TmdznU4A&s=10"
    }
    
    
    @IBAction func productCategoryButtonTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Select Category", message: nil, preferredStyle: .actionSheet)
        
        for (name, id) in categoryMap {
            let action = UIAlertAction(title: name, style: .default) { _ in
                self.productCategoryButton.setTitle(name, for: .normal)
                self.selectedCategoryId = id
            }
            alert.addAction(action)
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.sourceView = self.productCategoryButton
            popoverController.sourceRect = self.productCategoryButton.bounds
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func addTheProductButtonTapped(_ sender: Any) {
        guard let name = productTitleLabel.text, !name.isEmpty,
              let description = productDescriptionLabel.text, !description.isEmpty,
              let pricePerWeek = productPricePerWeekLabel.text, let weekly = Double(pricePerWeek),
              let pricePerMonth = productPricePerMonthLabel.text, let monthly = Double(pricePerMonth),
              let categoryId = selectedCategoryId else {
            print("Please fill all fields and select a category.")
            return
        }
        
        let product: [String: Any] = [
            "name": name,
            "description": description,
            "pricePerWeek": weekly,
            "pricePerMonth": monthly,
            "categoryId": categoryId,
            "productImageList": [
                ["imageUrl": tempImageUrl]
            ]
        ]
        
        guard let url = URL(string: "https://localhost:9001/api/v1/Product") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: product, options: [])
            request.httpBody = jsonData
        } catch {
            print("Failed to create JSON: \(error)")
            return
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let task = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Request error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("Status Code: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Success", message: "Product successfully added!", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self.productTitleLabel.text = ""
                        self.productDescriptionLabel.text = ""
                        self.productPricePerWeekLabel.text = ""
                        self.productPricePerMonthLabel.text = ""
                        self.productCategoryButton.setTitle("Select Category", for: .normal)
                        self.selectedCategoryId = nil
                        self.productImageView.image = UIImage(named: "addEventImages5")
                        self.tempImageUrl = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRS-PRicSM62TPGkzTxl74cjerevt241-AWX0KH1o6_tFeuu25TmdznU4A&s=10"
                    })
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                print("Server responded with status code: \(httpResponse.statusCode)")
            }
        }
        
        task.resume()
    }
    
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        guard let trust = challenge.protectionSpace.serverTrust else {
            completionHandler(.cancelAuthenticationChallenge, nil)
            return
        }
        let credential = URLCredential(trust: trust)
        completionHandler(.useCredential, credential)
    }
    
    
}
