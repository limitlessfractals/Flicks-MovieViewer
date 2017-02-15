//
//  MoviesViewController.swift
//  movieViewer
//
//  Created by Wuqiong Fan on 2/9/17.
//  Copyright © 2017 Wuqiong Fan. All rights reserved.
//

import UIKit
import AFNetworking
// if not autocompleting, cmd + shift + k to clean the file, then cmd + b to build

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    // instance outlet
    var movies: [NSDictionary]?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // call API
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                if let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(dataDictionary)
                    
                    //load into movies
                    self.movies = dataDictionary["results"] as! [NSDictionary]
                    
                    // return after network request
                    self.tableView.reloadData()
                }
            }
        }
        task.resume()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return how many rows; conditional on if movies is nil
        
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // define cell and downcast to be class MovieCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        // API; option + click to check what is it cast as
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        let baseURL = "https://image.tmdb.org/t/p/w500/"
        let posterPath = movie["poster_path"] as! String
        let imageURL = NSURL(string: baseURL + posterPath)
        
        
        // label title and overview of each cell
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        // use method from imported AFNetwork pod
        cell.posterView.setImageWith(imageURL as! URL)
        
        // label each row with row number 
        // cell.textLabel!.text = "row \(indexPath.row)"
        // label each row with built in text label
        // cell.textLabel!.text = title
        print("row \(indexPath.row)")
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
