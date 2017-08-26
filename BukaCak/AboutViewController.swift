//
//  AboutViewController.swift
//  BukaCak
//
//  Created by Buka Cakrawala on 12/30/16.
//  Copyright © 2016 Buka Cakrawala. All rights reserved.
//

import UIKit


struct About {
    
    let image: UIImage
    let title: String
    let text: String
}

let aboutMe: About = About(image: #imageLiteral(resourceName: "profile"), title: "I am C. Sriteja", text: " I'm a 21 year old sofware developer based in India. I have completed my graduation recently from SRM University. I am a confident and self motivated individual and love to make my hands dirty with tech toys.")

let interests: About = About(image: #imageLiteral(resourceName: "calhacks"), title: "Interests : Artificial Intelligence ", text: "The very thought of bringing most of intelligent behaviour we see in humans to machine for making good accurate predictions during the face of uncertainty like understanding the context of text /speech , picking up an object without specifying the mathematical co ordinates or tracking the spots of the floor that have already been swept has always fascinated me. Using large clusters of irregular data, visualise them and come to conclusions is something I found much beyond interesting in recent past.")


let hobby: About = About(image: #imageLiteral(resourceName: "yellowPencil"), title: "Hobbies", text: "Besides doing hours and hours of programming, I love watching movies, travelling and playing cricket. I am big foodie and love to explore different cuisines and restaurants. Apart from all these i love playing games on my Xbox One. ")

let inspiration: About = About(image: #imageLiteral(resourceName: "bulb"), title: "👨🏼‍💻Inspiration", text: "Stay Hungry , Stay foolish. Steve jobs has always been my inspiration. I am restless individual and would love to leave a dent on this planet during my time just like how steve did. Steve's 2005 commencement video is stored safely and time in and time out, when i feel low, I keep watching it just to motivate myself and lift my spirit")

let futurePlan: About = About(image: #imageLiteral(resourceName: "building"), title: "Future Plan", text: "I Love working on challenging projects. I want to take up challenging projects to develop intelligent systems.I want to pursue research in fields of Machine learning and work under some renowed professor for Phd degree.")



class AboutViewController: UIViewController {
    
    let aboutLists:[About] = [aboutMe, interests, hobby, inspiration, futurePlan]
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBAction func dismissButtonAsAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissButton.setBackgroundImage(#imageLiteral(resourceName: "error"), for: .normal)
        self.dismissButton.layer.borderColor = UIColor.white.cgColor
        self.dismissButton.layer.borderWidth = 1.2
        
        let shadowPath = UIBezierPath(rect: self.dismissButton.bounds)
        
        dismissButton.layer.cornerRadius = dismissButton.frame.size.width / 2
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}

extension AboutViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "aboutCell", for: indexPath) as! AboutCollectionViewCell

        cell.imageView.image = aboutLists[indexPath.item].image
        cell.titleLabel.text = aboutLists[indexPath.item].title
        cell.contentTextView.text = aboutLists[indexPath.item].text
        
        cell.contentTextView.setContentOffset(CGPoint.zero, animated: false)
        cell.contentTextView.scrollRangeToVisible(NSMakeRange(0, 0))
        
        cell.layer.borderWidth = 1.0
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 17
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = ((view.frame.width) / 2) + 95
        let height = ((view.frame.height) / 2 + 200)
        
        let cellSize = CGSize(width: width, height: height)
        return cellSize
        
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        
//        let width = ((view.frame.width) - 40) * 3
//        let cellSpacing = 10 * (2)
//        
//        let leftInset = (collectionView.frame.width - CGFloat(width) + CGFloat(cellSpacing)) / 2
//        let rightInset = leftInset
//        
//        return UIEdgeInsetsMake(0, leftInset, 0, rightInset)
//        
//    }
    
}
