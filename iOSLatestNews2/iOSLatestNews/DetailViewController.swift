//
//  DetailViewController.swift
//  iOSLatestNews
//
//  Created by Alumnos on 11/23/16.
//  Copyright © 2016 UPC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!

    @IBOutlet weak var articlesCollectionView: UICollectionView!
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    private let reuseIdentifier = "Cell"
    var articles = [Article]()
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.name
            }
            if let imageView = self.logoImageView {
                
                imageView.af_setImage(withURL: URL(string: detail.urlToLargeLogo)!)
            }
            if let label = self.urlLabel {
                label.text = detail.url
            }
            
            updateArticles()
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        //self.collectionView!.register(ArticlesCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.articlesCollectionView.register(UINib(nibName: "ArticlesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        // Do any additional setup after loading the view, typically from a nib.
        articlesCollectionView.delegate = self
        articlesCollectionView.dataSource = self
        
        
        self.configureView()
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Source? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection")
        // #warning Incomplete implementation, return the number of items
        return articles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("cellForItemAtIndexPath")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ArticlesCollectionViewCell
        let article = articles[indexPath.row]
        // Configure the cell
        if let label = cell.titleLabel {
            label.text = article.title
            print("\(label.text!)")
        }
        cell.titleLabel.text = article.title!
        cell.pictureImageView.af_setImage(withURL: URL(string: article.urlToImage!)!)
        
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
    func updateArticles() {
        let currentSource = (UIApplication.shared.delegate as! AppDelegate).service?.currentSource
        print("Current Source id is \(currentSource!.id!)")
        
        let parameters: Parameters = ["source": currentSource!.id!, "apiKey": "fecf4feeffa64e4da682e7d268612ce5"]
        Alamofire.request(NewsService.articlesUrl,  parameters: parameters).responseJSON {
            response in
            if response.result.isFailure {
                print("Error in request")
                return }
            let json = JSON(data: response.data!)
            print("\(json)")
            self.articles = Article.build(jsonArticles: json["articles"].arrayValue)
            for article in self.articles { print("\(article.title)")}
            self.articlesCollectionView.reloadData()
            
        }
    }


    @IBAction func urlButtonAction(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: detailItem!.url!)!)
    }
}





