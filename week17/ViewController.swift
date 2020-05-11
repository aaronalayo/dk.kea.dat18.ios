//
//  ViewController.swift
//  HealthAppDemo
//
//  Created by Aaron ALAYO on 24/04/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    let activityManager = CMMotionActivityManager()
    let pedometer = CMPedometer()
    
    @IBOutlet weak var steps: UITextField!
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var pace: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func startPressed(_ sender: UIButton) {
        if CMMotionActivityManager.isActivityAvailable() {
            startTrackingActivityType()
            
        }
        if CMPedometer.isDistanceAvailable(){
            startReceivingUpdates()
            
        }
    
        print("counting start")
    }
    
    
    @IBAction func stopPressed(_ sender: UIButton) {
        pedometer.stopUpdates()
        print("counting stop")
    }
    
    private func startTrackingActivityType() {
        
        activityManager.startActivityUpdates(to: OperationQueue.main) {
            [weak self] (activity: CMMotionActivity?) in
            guard let activity = activity else { return }
            DispatchQueue.main.async {
                if let strongSelf = self {
                    if activity.walking {
                        strongSelf.pace.text = "Walking"
                    } else if activity.stationary {
                        strongSelf.pace.text = "Stationary"
                    } else if activity.running {
                        strongSelf.pace.text = "Running"
                    } else if activity.automotive {
                        strongSelf.pace.text = "Automotive"
                    }
                }
                
            }
        }
    }
    
    
    private func startReceivingUpdates() {
        pedometer.startUpdates(from: Date()) {
            [weak self] pedometerData, error in
            guard let pedometerData = pedometerData, error == nil else {
                print("Error :\(error.debugDescription)")
                return
                
            }
            
            DispatchQueue.main.async {
                self?.steps.text = pedometerData.numberOfSteps.stringValue
                let dis = pedometerData.distance?.stringValue
                self?.distance.text = dis
                print("distance :\(String(describing: dis))")
            }
        }
    }
    
 
    
}

