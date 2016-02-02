//
//  MoviesViewController.swift
//  MovieViewer
//
//  Created by Reis Sirdas on 1/25/16.
//  Copyright © 2016 sirdas. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    var movies: [NSDictionary]?
    var endpoint: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string: "https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(
            URL: url!,
            cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
            timeoutInterval: 10)
        
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue()
        )
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "refreshControlAction", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    MBProgressHUD.hideHUDForView(self.view, animated: true)
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
                            print("response: \(responseDictionary)")
                            self.movies = responseDictionary["results"] as? [NSDictionary]
                            self.tableView.reloadData()
                            
                            refreshControl.endRefreshing()
                    }
                }
        })
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = movies {
            return movies.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MovieCell", forIndexPath: indexPath) as! MovieCell
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.orangeColor()
        cell.selectedBackgroundView = backgroundView
        let movie = movies![indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        cell.titleLabel.text = title
        cell.overviewLabel.text = overview
        
        //let baseUrl = "http://image.tmdb.org/t/p/w342"
        //let imageUrl = NSURL(string: baseUrl + posterPath)
        //let imageRequest = NSURLRequest(URL: imageUrl!)
        
        if let posterPath = movie["poster_path"] as? String {
            let smallUrl = "http://image.tmdb.org/t/p/w45"
            let largeUrl = "http://image.tmdb.org/t/p/original"
            let smallImageRequest = NSURLRequest(URL: NSURL(string: smallUrl + posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: largeUrl + posterPath)!)
            
            cell.posterView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    // imageResponse will be nil if the image is cached
                    if smallImageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        cell.posterView.alpha = 0.0
                        cell.posterView.image = smallImage
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            cell.posterView.alpha = 1.0
                            }, completion: { (success) -> Void in
                                cell.posterView.setImageWithURLRequest(largeImageRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    cell.posterView.image = largeImage
                                    }, failure: { (largeImageRequest, largeImageResponse, error) -> Void in
                                        cell.posterView.image = smallImage
                                })
                        })
                    } else {
                        print("Image was cached so just update the image")
                        cell.posterView.setImageWithURLRequest(largeImageRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            cell.posterView.image = largeImage
                            }, failure: { (largeImageRequest, largeImageResponse, error) -> Void in
                                cell.posterView.image = smallImage
                        })
                    }
                    
                }, failure: { (smallImageRequest, smallImageResponse, error) -> Void in
                    cell.posterView.image = nil
            })
        }
        //        print("row \(indexPath.row)")
        return cell
    }
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let movie = movies![indexPath!.row]
        
        let detailViewController = segue.destinationViewController as! DetailViewController
        detailViewController.movie = movie
        
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
