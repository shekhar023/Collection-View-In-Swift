//
//  ViewController.swift
//  AnitnoLabs Assignment
//
//  Created by Shekhar Chaudhary on 06/02/20.
//  Copyright © 2020 Shekhar Chaudhary. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}


struct MyData: Decodable{
    
    let url : String
    let name : String
    let age : String
    let location : String
    let Details : [String]
    let bodyType : String
    let userDesire : String
}

class ViewController: UIViewController, UICollectionViewDataSource {
 
    var mydata = [MyData]()

    @IBOutlet weak var collectionview: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.collectionview.dataSource = self
        
        let url = URL(string: "http://demo8716682.mockable.io/cardData")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil{
                
                do{
                
                    self.mydata = try JSONDecoder().decode([MyData].self, from: (data!))
                    
                }catch{
                    print("Parse Error")
                    print(error)
                }
                DispatchQueue.main.async {
                debugPrint("running")
                    self.collectionview.reloadData()
                }
            }
            
        }.resume()
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mydata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.nameLb!.text = mydata[indexPath.row].name.capitalized
        cell.ageLb.text = mydata[indexPath.row].age.capitalized
        cell.locationLb.text = mydata[indexPath.row].location.capitalized
        
        
        let defaultLink = mydata[indexPath.row].url
        cell.imageView.downloaded(from: defaultLink)
        cell.clipsToBounds = true
        cell.imageView.layer.cornerRadius = cell.imageView.frame.height/2
        cell.imageView.contentMode = .scaleAspectFit

        return cell
    }


}

