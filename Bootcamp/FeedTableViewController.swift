//
//  FeedTableViewController.swift
//  Bootcamp
//
//  Created by lichun on 6/3/18.
//  Copyright © 2018 lichun. All rights reserved.
//

import UIKit
import Apollo
import SDWebImage

class FeedTableViewController: UITableViewController {
    var watcher: GraphQLQueryWatcher<FeedQuery>?
    var feeds = [FeedQuery.Data.Feed.Edge?]() {
        didSet {
            self.tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        watcher = apollo.watch(query: FeedQuery(first: 10)) { (result, error) in
            if error != nil {
                fatalError("The query error: \(error!.localizedDescription)")
            }
            self.feeds = (result?.data?.feeds?.edges)!
        }
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
        return feeds.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedTableViewCell", for: indexPath) as? FeedTableViewCell else {
            fatalError("The dequeued cell is not an instance of FeedTableViewCell.")
        }
        cell.configure(with: self.feeds[indexPath.row]!)
        return cell
    }

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
    @IBAction func post(_ sender: UIBarButtonItem) {
        let inputPost = UIAlertController(title: "Enter post", message: nil, preferredStyle: .alert)
        inputPost.addTextField()
        inputPost.addAction(UIAlertAction(title: "Post", style: .default) { (action) in
            apollo.perform(mutation: PostMutation(post: inputPost.textFields![0].text!))
        })
        self.present(inputPost, animated: true)
    }

}
