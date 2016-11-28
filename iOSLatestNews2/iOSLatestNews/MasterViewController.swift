//
//  MasterViewController.swift
//  iOSLatestNews
//
//  Created by Alumnos on 11/23/16.
//  Copyright © 2016 UPC. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import SwiftyJSON


class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    var sources = [Source]()


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem

//        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(insertNewObject(_:)))
//        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }

    override func viewDidAppear(_ animated: Bool) {
        updateSources()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(_ sender: Any) {
//        objects.insert(NSDate(), at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
//    }

    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let source = sources[indexPath.row]
                (UIApplication.shared.delegate as! AppDelegate).service!.currentSource = source
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = source
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sources.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let source = sources[indexPath.row]
        cell.textLabel!.text = source.name
        cell.detailTextLabel!.text = source.description
        // update image if available
        cell.imageView!.af_setImage(withURL: URL(string: source.urlToSmallLogo)!)
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            sources.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }

    func updateSources() {
        let parameters: Parameters = ["language": "en"]
        
        Alamofire.request(NewsService.sourcesUrl, parameters: parameters).responseJSON {
            response in
            if response.result.isFailure { return }
            let json = JSON(response.result.value)
            self.sources = Source.build(jsonSources: json["sources"].arrayValue as [JSON])
            for source in self.sources { print("\(source.name)") }
            self.tableView.reloadData()
        }
    }
}

