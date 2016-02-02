//
//  DetailViewController.swift
//  MovieViewer
//
//  Created by Reis Sirdas on 2/1/16.
//  Copyright © 2016 sirdas. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoView: UIView!
    
    var movie : NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: infoView.frame.origin.y + infoView.frame.size.height)
        
        let title = movie["title"] as? String
        titleLabel.text = title
        
        let overview = movie["overview"]
        overviewLabel.text = overview as? String
        
        overviewLabel.sizeToFit()
        
        if let posterPath = movie["poster_path"] as? String {
            let smallUrl = "http://image.tmdb.org/t/p/w45"
            let largeUrl = "http://image.tmdb.org/t/p/original"
            let smallImageRequest = NSURLRequest(URL: NSURL(string: smallUrl + posterPath)!)
            let largeImageRequest = NSURLRequest(URL: NSURL(string: largeUrl + posterPath)!)
            
            posterImageView.setImageWithURLRequest(
                smallImageRequest,
                placeholderImage: nil,
                success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                    // imageResponse will be nil if the image is cached
                    if smallImageResponse != nil {
                        print("Image was NOT cached, fade in image")
                        self.posterImageView.alpha = 0.0
                        self.posterImageView.image = smallImage
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.posterImageView.alpha = 1.0
                            }, completion: { (success) -> Void in
                                self.posterImageView.setImageWithURLRequest(largeImageRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                    self.posterImageView.image = largeImage
                                    }, failure: { (largeImageRequest, largeImageResponse, error) -> Void in
                                        self.posterImageView.image = smallImage
                                })
                        })
                    } else {
                        print("Image was cached so just update the image")
                        self.posterImageView.setImageWithURLRequest(largeImageRequest, placeholderImage: smallImage, success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                            self.posterImageView.image = largeImage
                            }, failure: { (largeImageRequest, largeImageResponse, error) -> Void in
                                self.posterImageView.image = smallImage
                        })
                    }
                    
                }, failure: { (smallImageRequest, smallImageResponse, error) -> Void in
                    self.posterImageView.image = nil
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
