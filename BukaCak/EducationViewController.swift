//
//  EducationViewController.swift
//  BukaCak
//
//  Created by Buka Cakrawala on 12/30/16.
//  Copyright © 2016 Buka Cakrawala. All rights reserved.
//

import UIKit
import MapKit

// MARK: - School Model
struct School {
    
    let schoolName: String!
    let schoolPlace: String!
    let schoolYear: String!
    let schoolStory: String!
    let latitude: CLLocationDegrees!
    let longtitude: CLLocationDegrees!
    
}

let product = School(schoolName: "SRM University",schoolPlace: "Chennai, India",schoolYear: "2013 - 2017",schoolStory: "Pursued Computer Science % Engineering. \n CGPA : 8.75 / 10 \n Major Project : Building a recommender system (GPA : 10). \n Was Part of App Development club", latitude: 12.8259, longtitude: 80.0395)

let summer = School(schoolName: "High School",schoolPlace: "Hyderabad, India",schoolYear: "2011-2013", schoolStory: "Major : Mathematics, Physics, Chemistry \n Percentage : 94.6/100 ", latitude: 17.4408, longtitude: 78.4917)

let inti = School(schoolName: "Pre high School", schoolPlace: "Hyderabad, India",schoolYear: "2002-2011",schoolStory: "Passed 10th standard with a percentage of 93.3 \n Attended various speed math competitions. \n Was part of team that won intra school cricket competition.", latitude: 17.4491, longtitude: 78.5338)

let schoolsList = [inti, summer, product]

class EducationViewController: UIViewController, UICollisionBehaviorDelegate {
    
    var timer: Timer!
    
    @IBOutlet weak var blinkingLabel: UILabel!
       
    @IBOutlet weak var dismissButton: UIButton!
   
    @IBAction func dismissAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var views = [UIView]()
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var snap: UISnapBehavior!
    var previousTouchPoint: CGPoint!
    var viewDragging = false
    var viewPinned = false
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        labelFadeOut(view: blinkingLabel)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        self.dismissButton.layer.cornerRadius = dismissButton.frame.size.height / 2
        self.dismissButton.setBackgroundImage(#imageLiteral(resourceName: "error-4"), for: .normal)
        self.dismissButton.layer.borderColor = UIColor.white.cgColor
        self.dismissButton.layer.borderWidth = 1.2
        
        animator = UIDynamicAnimator(referenceView: self.view)
        gravity = UIGravityBehavior()
        
        animator.addBehavior(gravity)
        gravity.magnitude = 4
        
        var offset: CGFloat = 250
        
        for i in 0 ... schoolsList.count - 1 {
        
            if let view = addViewController(atOffset: offset, dataForViewController: schoolsList[i].schoolName as AnyObject?, story: schoolsList[i].schoolStory as AnyObject?, lat: schoolsList[i].latitude as AnyObject?, long: schoolsList[i].longtitude as AnyObject?, place: schoolsList[i].schoolPlace as AnyObject?, year: schoolsList[i].schoolYear as AnyObject?) {
                views.append(view)
                offset -= 50
            }
        }
    }
    
    func labelFadeOut(view: UIView) {
        let animationDuration = 1.2
        
        
            // Fade in the view
            UIView.animate(withDuration: animationDuration, animations: {
                view.alpha = 1.0
            }, completion: { (success) in
                // if success, fade out the view.
                UIView.animate(withDuration: animationDuration, delay: 0.0, options: .repeat, animations: {
                    view.alpha = 0
                }, completion: nil)
            })
    }
    
    func addViewController(atOffset offset: CGFloat, dataForViewController data: AnyObject?, story: AnyObject?, lat: AnyObject?, long: AnyObject?, place: AnyObject?, year: AnyObject?) -> UIView? {
        
        let point = MKPointAnnotation()
        
        let span = MKCoordinateSpanMake(0.008, 0.008)
        
    
        let frame = self.view.bounds.offsetBy(dx: 0, dy: self.view.bounds.size.height - offset)
    
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let stack = sb.instantiateViewController(withIdentifier: "StackElement") as! EducationElementViewController
        
        if let view = stack.view {
            
            view.frame = frame
            view.layer.cornerRadius = 5
            view.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
            view.layer.shadowColor = UIColor.black.cgColor
            view.layer.shadowRadius = 3
            view.layer.shadowOpacity = 0.5
            
            if (data as? String) != nil {
                stack.schoolTitle.text = data as! String?
            }
            
            if (story as? String) != nil {
                stack.descriptionTextView.text = story as! String
            }
            
            if (year as? String) != nil {
                stack.schoolYearLabel.text = year as? String
            }
            
            if (lat as? CLLocationDegrees) != nil {
                if (long as? CLLocationDegrees) != nil {
                    point.coordinate = CLLocationCoordinate2D(latitude: lat as! CLLocationDegrees, longitude: long as! CLLocationDegrees)
                    point.title = data as? String
                    point.subtitle = place as? String
                    let region = MKCoordinateRegion(center: point.coordinate, span: span)
                    stack.mapView.addAnnotation(point)
                    stack.mapView.setRegion(region, animated: true)
                }
            }
            
            
            self.addChildViewController(stack)
            self.view.addSubview(view)
            
            stack.didMove(toParentViewController: self)
            
            self.view.isUserInteractionEnabled = true
            
            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(EducationViewController.handlePan(gestureRecognizer:)))
            
            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(EducationViewController.handleSwipe(recognizer:)))
            swipeGesture.direction = UISwipeGestureRecognizerDirection.down
            
            
            view.addGestureRecognizer(panGestureRecognizer)
            view.addGestureRecognizer(swipeGesture)
            
            
            let collision = UICollisionBehavior(items: [view])
            collision.collisionDelegate = self
            animator.addBehavior(collision)
            
            // Lower boundary
            let boundary = view.frame.origin.y + view.frame.size.height
            var boundaryStart = CGPoint(x: 0, y: boundary)
            var boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: boundary)
            collision.addBoundary(withIdentifier: 1 as NSCopying, from: boundaryStart, to: boundaryEnd)
            
            // Upper boundary
            
            boundaryStart = CGPoint(x: 0, y: 0)
            boundaryEnd = CGPoint(x: self.view.bounds.size.width, y: 0)
            collision.addBoundary(withIdentifier: 2 as NSCopying, from: boundaryStart, to: boundaryEnd)
            
            gravity.addItem(view)
            
            let itemBehaviour = UIDynamicItemBehavior(items: [view])
            animator.addBehavior(itemBehaviour)
            
            return view
            }     
        return nil
    }
    
    func handleSwipe(recognizer: UISwipeGestureRecognizer) {
        
        let touchPoint = recognizer.location(in: self.view)
        let swipedView = recognizer.view!
        
        if recognizer.direction == .down {
            print("swiped down is detected!")
            previousTouchPoint = touchPoint
            
            let yOffset = previousTouchPoint.y - touchPoint.y
            swipedView.center = CGPoint(x: swipedView.center.x, y: swipedView.center.y - yOffset)
            
            pin(view: swipedView)
            animator.updateItem(usingCurrentState: swipedView)
            
        } else {
            print("it is not swiping down!")
        }
    }
    
    // MARK: - Handle Pan
    func handlePan(gestureRecognizer: UIPanGestureRecognizer) {
    
        let touchPoint = gestureRecognizer.location(in: self.view)
        let draggedView = gestureRecognizer.view!
        
        if gestureRecognizer.state == .began {
            let dragStartPoint = gestureRecognizer.location(in: draggedView)
            print("TOUCHPOINT: \(touchPoint)")
            print("DRAG: \(dragStartPoint)")
            
            if dragStartPoint.y > 0 {
            
                viewDragging = true
                previousTouchPoint = touchPoint
            
            }
        
        } else if gestureRecognizer.state == .changed  {
            
            let yOffset = previousTouchPoint.y - touchPoint.y
            
            draggedView.center = CGPoint(x: draggedView.center.x, y: draggedView.center.y - yOffset)
            previousTouchPoint = touchPoint
        } else if gestureRecognizer.state == .ended  {
            
            pin(view: draggedView)
            addVelocity(toView: draggedView, fromGestureRecognizer: gestureRecognizer)
        
            animator.updateItem(usingCurrentState: draggedView)
            viewDragging = false
        }
    }
    
    
    func pin(view: UIView) {
    
        let viewHasReachedPinLocation = view.frame.origin.y < 100
        
        if viewHasReachedPinLocation {
            if !viewPinned {
                var snapPosition = self.view.center
                snapPosition.y += 30
                
                snap = UISnapBehavior(item: view, snapTo: snapPosition)
                animator.addBehavior(snap)
                
                setVisibility(view: view, alpha: 0)
                viewPinned = true
            }
        } else {
            if viewPinned {
                animator.removeBehavior(snap)
                setVisibility(view: view, alpha: 1)
                viewPinned = false
            }
        }
    }
    
    
    func setVisibility(view: UIView, alpha: CGFloat) {
        for aView in views {
            if aView != view {
                aView.alpha = alpha
            }
        }
    }
    
    func addVelocity(toView view: UIView, fromGestureRecognizer panGestureRecognizer: UIPanGestureRecognizer) {
        var velocity = panGestureRecognizer.velocity(in: self.view)
        velocity.x = 0
        
        if let behaviour = itemBehaviour(forView: view) {
             behaviour.addLinearVelocity(velocity, for: view)
        }
    }

    func itemBehaviour(forView view: UIView) ->UIDynamicItemBehavior? {
    
        for behaviour in animator.behaviors {
        
            if let itemBehaviour = behaviour as? UIDynamicItemBehavior {
            
                if let possibleView = itemBehaviour.items.first as? UIView, possibleView == view {
                    return itemBehaviour
                }
            }
        }
        return nil
    }
    
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if NSNumber(integerLiteral: 2).isEqual(identifier) {
            let view = item as! UIView
            pin(view: view)
        }
    }
    
}
