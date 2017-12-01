/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Main view controller for the AR experience.
*/

import ARKit
import SceneKit
import UIKit

class ARKitViewController: BaseViewController {
    
    // MARK: - ARKit Config Properties
    
    var screenCenter: CGPoint?
    
    let session = ARSession()
    let standardConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    
    // MARK: - Virtual Object Manipulation Properties
    
    var dragOnInfinitePlanesEnabled = false
    var virtualObjectManager: VirtualObjectManager!
    
    var isLoadingObject: Bool = false {
        didSet {
            DispatchQueue.main.async {
                self.settingsButton.isEnabled = !self.isLoadingObject
                self.addObjectButton.isEnabled = !self.isLoadingObject
                self.restartExperienceButton.isEnabled = !self.isLoadingObject
            }
        }
    }
    
    // MARK: - Other Properties
    
    var textManager: TextManager!
    var restartExperienceButtonIsEnabled = true
    
    // MARK: - UI Elements
    
    var spinner: UIActivityIndicatorView?
    var timeoutTimer : DispatchSourceTimer!
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var messagePanel: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var addObjectButton: UIButton!
    @IBOutlet weak var restartExperienceButton: UIButton!
    @IBOutlet weak var clearSceneButton: UIButton!
    @IBOutlet weak var loadNillousButton: UIButton!
    
    // MARK: - Queues
    
	let serialQueue = DispatchQueue(label: "com.apple.arkitexample.serialSceneKitQueue")
	
    // MARK: - View Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async(execute: {
            UIApplication.shared.registerForRemoteNotifications()
        })
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        addSlideMenuButton()
        self.title = "ARKit"
        Setting.registerDefaults()
		setupUIControls()
        setupScene()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		// Prevent the screen from being dimmed after a while.
		UIApplication.shared.isIdleTimerDisabled = true
		
		if ARWorldTrackingConfiguration.isSupported {
			// Start the ARSession.
			resetTracking()
		} else {
			// This device does not support 6DOF world tracking.
			let sessionErrorMsg = "This app requires world tracking. World tracking is only available on iOS devices with A9 processor or newer. " +
			"Please quit the application."
			displayErrorMessage(title: "Unsupported platform", message: sessionErrorMsg, allowRestart: false)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		// session.pause()
        resetTracking()
	}
    
    // MARK: - Re-load object in store
	
    // MARK: - Setup
	func setupScene() {
        // Synchronize updates via the `serialQueue`.
        virtualObjectManager = VirtualObjectManager(updateQueue: serialQueue)
        virtualObjectManager.delegate = self
		
		// set up scene view
		sceneView.setup()
		sceneView.delegate = self
		sceneView.session = session
		// sceneView.showsStatistics = true
		
		sceneView.scene.enableEnvironmentMapWithIntensity(25, queue: serialQueue)
		
		setupFocusSquare()
		
		DispatchQueue.main.async {
			self.screenCenter = self.sceneView.bounds.mid
		}
	}
    
    func setupUIControls() {
        textManager = TextManager(viewController: self)
        
        // Set appearance of message output panel
        messagePanel.layer.cornerRadius = 3.0
        messagePanel.clipsToBounds = true
        messagePanel.isHidden = true
        messageLabel.text = ""
    }
	
    // MARK: - Gesture Recognizers
    
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		virtualObjectManager.reactToTouchesBegan(touches, with: event, in: self.sceneView)
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		virtualObjectManager.reactToTouchesMoved(touches, with: event)
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if virtualObjectManager.virtualObjects.isEmpty {
            chooseObject(addObjectButton)
            return
        }
        virtualObjectManager.reactToTouchesEnded(touches, with: event)
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		virtualObjectManager.reactToTouchesCancelled(touches, with: event)
	}
	
    // MARK: - Planes
	var planes = [ARPlaneAnchor: Plane]()
	
    func addPlane(node: SCNNode, anchor: ARPlaneAnchor) {
        
		let plane = Plane(anchor)
		planes[anchor] = plane
		node.addChildNode(plane)
		
		textManager.cancelScheduledMessage(forType: .planeEstimation)
		textManager.showMessage("SURFACE DETECTED")
		if virtualObjectManager.virtualObjects.isEmpty {
			textManager.scheduleMessage("TAP + TO PLACE AN OBJECT", inSeconds: 7.5, messageType: .contentPlacement)
		}
	}
		
    func updatePlane(anchor: ARPlaneAnchor) {
        if let plane = planes[anchor] {
			plane.update(anchor)
		}
	}
			
    func removePlane(anchor: ARPlaneAnchor) {
		if let plane = planes.removeValue(forKey: anchor) {
			plane.removeFromParentNode()
        }
    }
	
	func resetTracking() {
		session.run(standardConfiguration, options: [.resetTracking, .removeExistingAnchors])
		
		textManager.scheduleMessage("FIND A SURFACE TO PLACE AN OBJECT",
		                            inSeconds: 7.5,
		                            messageType: .planeEstimation)
	}
    
    func enableButton() -> Void {
        DispatchQueue.main.async {
            self.clearSceneButton.isUserInteractionEnabled = true
            self.loadNillousButton.isUserInteractionEnabled = true
        }
    }
    
    func disableButton() -> Void {
        DispatchQueue.main.async {
            self.clearSceneButton.isUserInteractionEnabled = false
            self.loadNillousButton.isUserInteractionEnabled = false
        }
    }

    // MARK: - Focus Square
    var focusSquare: FocusSquare?
	
    func setupFocusSquare() {
		serialQueue.async {
			self.focusSquare?.isHidden = true
			self.focusSquare?.removeFromParentNode()
			self.focusSquare = FocusSquare()
			self.sceneView.scene.rootNode.addChildNode(self.focusSquare!)
		}
		
		textManager.scheduleMessage("TRY MOVING LEFT OR RIGHT", inSeconds: 5.0, messageType: .focusSquare)
    }
	
	func updateFocusSquare() {
		guard let screenCenter = screenCenter else { return }
		
		DispatchQueue.main.async {
			var objectVisible = false
			for object in self.virtualObjectManager.virtualObjects {
				if self.sceneView.isNode(object, insideFrustumOf: self.sceneView.pointOfView!) {
					objectVisible = true
					break
				}
			}
			
			if objectVisible {
                self.focusSquare?.hide()
			} else {
                self.focusSquare?.unhide()
			}
			
            let (worldPos, planeAnchor, _) = self.virtualObjectManager.worldPositionFromScreenPosition(screenCenter,
                                                                                                       in: self.sceneView,
                                                                                                       objectPos: self.focusSquare?.simdPosition)
			if let worldPos = worldPos {
				self.serialQueue.async {
					self.focusSquare?.update(for: worldPos, planeAnchor: planeAnchor, camera: self.session.currentFrame?.camera)
				}
				self.textManager.cancelScheduledMessage(forType: .focusSquare)
			}
		}
	}
    
    func addTapGestureToSceneView() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARKitViewController.didTap(withGestureRecognizer:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func didTap(withGestureRecognizer recognizer: UIGestureRecognizer) {
        let tapLocation = recognizer.location(in: sceneView)
        let hitTestResults = sceneView.hitTest(tapLocation)
        guard let node = hitTestResults.first?.node else { return }
        node.removeFromParentNode()
    }
    
	// MARK: - Error handling
    
	func displayErrorMessage(title: String, message: String, allowRestart: Bool = false) {
		// Blur the background.
		textManager.blurBackground()
		
		if allowRestart {
			// Present an alert informing about the error that has occurred.
			let restartAction = UIAlertAction(title: "Reset", style: .default) { _ in
				self.textManager.unblurBackground()
				self.restartExperience(self)
			}
			textManager.showAlert(title: title, message: message, actions: [restartAction])
		} else {
			textManager.showAlert(title: title, message: message, actions: [])
		}
	}
    
    @IBAction func removingNillous(_sender:UIButton) {
        LoadingIndicatorView.show("- Loading -")
        self.delay(time: self._timer) {
            LoadingIndicatorView.hide()
            DispatchQueue.main.async {
                self.virtualObjectManager.removeAllVirtualObjects()
            }
        }
    }
    
    @IBAction func placingNillous(_sender:UIButton) {
        self.apiGetAllNillous()
    }
    
    // MARK: - Alert message
    override func showAlertMessage(title: String, message: String) {
        let closeAlert = UIAlertAction(title: "OK", style: .default, handler: nil)
        textManager.showAlertCustomize(title: title, message: message, actions: [closeAlert])
    }
    
    // MARK: - Detect User Inactivity
    func startTimer() -> Void {
        let delay : DispatchTime = .now() + .seconds(2)
        if timeoutTimer == nil {
            timeoutTimer = DispatchSource.makeTimerSource()
            timeoutTimer.schedule(deadline: delay, repeating: 0)
            timeoutTimer.setEventHandler {
                self.timeoutTimer.cancel()
                self.timeoutTimer = nil
                DispatchQueue.main.async {
                    // do something after time out on the main thread
                    print("\n--- ViewController | startTimer ---\n")
                    print("User inactivity detected \n")
                }
            }
            timeoutTimer.resume()
        } else {
            timeoutTimer.schedule(deadline: delay, repeating: 0)
        }
    }
    
    // MARK: - GET All Nillous
    func apiGetAllNillous() -> Void {
        
        print("\n--- ViewController | apiGetAllNillous ---\n")
        
        fetchedNillous = []
        
        // urlPath
        let urlPath = scriptUrl + "/api/getNillousList"
        print("URLPath: ", urlPath, "\n")
        
        // request
        var request  = URLRequest(url: URL(string: urlPath)!)
        request.httpMethod = "GET"
        
        // config
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        // task
        LoadingIndicatorView.show("- Loading -")
        self.delay(time: self._timer) {
            let task = session.dataTask(with: request) { (data, response, error) in
                if (error != nil) {
                    LoadingIndicatorView.hide()
                    print("Error from server \n")
                    self.showAlertMessage(title: "Nillous", message: "Error from server")
                    return
                } else {
                    DispatchQueue.main.async { // Correct
                        do {
                            let fetchedData = try JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as! NSArray
                            print("fetchedData: ", fetchedData, "\n")
                            
                            for eachFetchedNillous in fetchedData {
                                let eachNillous = eachFetchedNillous as! [String : Any]
                                
                                self.nillousID = eachNillous["id"] as? Int
                                self.nillousImage = eachNillous["image"] as? String ?? ""
                                self.nillousIndexObject = eachNillous["indexObject"] as? Int
                                self.nillousPositionX = eachNillous["positionX"] as? Float
                                self.nillousPositionY = eachNillous["positionY"] as? Float
                                self.nillousPositionZ = eachNillous["positionZ"] as? Float
                                self.nillousCameraX1 = eachNillous["x1"] as? Float
                                self.nillousCameraY1 = eachNillous["y1"] as? Float
                                self.nillousCameraZ1 = eachNillous["z1"] as? Float
                                self.nillousCameraW1 = eachNillous["w1"] as? Float
                                self.nillousCameraX2 = eachNillous["x2"] as? Float
                                self.nillousCameraY2 = eachNillous["y2"] as? Float
                                self.nillousCameraZ2 = eachNillous["z2"] as? Float
                                self.nillousCameraW2 = eachNillous["w2"] as? Float
                                self.nillousCameraX3 = eachNillous["x3"] as? Float
                                self.nillousCameraY3 = eachNillous["y3"] as? Float
                                self.nillousCameraZ3 = eachNillous["z3"] as? Float
                                self.nillousCameraW3 = eachNillous["w3"] as? Float
                                self.nillousCameraX4 = eachNillous["x4"] as? Float
                                self.nillousCameraY4 = eachNillous["y4"] as? Float
                                self.nillousCameraZ4 = eachNillous["z4"] as? Float
                                self.nillousCameraW4 = eachNillous["w4"] as? Float
                                
                                self.fetchedNillous.append(NillousCL(id: self.nillousID!, image: self.nillousImage, indexObject: self.nillousIndexObject!, positionX: self.nillousPositionX!, positionY: self.nillousPositionY!, positionZ: self.nillousPositionZ!, x1: self.nillousCameraX1!, y1: self.nillousCameraY1!, z1: self.nillousCameraZ1!, w1: self.nillousCameraW1!, x2: self.nillousCameraX2!, y2: self.nillousCameraY2!, z2: self.nillousCameraZ2!, w2: self.nillousCameraW2!, x3: self.nillousCameraX3!, y3: self.nillousCameraY3!, z3: self.nillousCameraZ3!, w3: self.nillousCameraW3!, x4: self.nillousCameraX4!, y4: self.nillousCameraY4!, z4: self.nillousCameraZ4!, w4: self.nillousCameraW4!))
                            }
                            print("fetchedNillous: ", self.fetchedNillous, "\n")
                            print(type(of: self.fetchedNillous), "\n")
                            
                            // set value
                            self.nillousesCount = self.fetchedNillous.count
                            print("nillousesCount: ", self.nillousesCount, "\n")
                            
                            // check count
                            if (!self.nillousCount(array: self.fetchedNillous)) {
                                LoadingIndicatorView.hide()
                                return
                            }
                            
                            // inform user
                            let closeAlert = UIAlertAction(title: "OK", style: .default) { (action: UIAlertAction!) in
                                // place object
                                LoadingIndicatorView.hide()
                                self.placingAllNillous(array: self.fetchedNillous)
                            }
                            self.textManager.showAlertCustomize(title: "Nillous", message: "\(self.nillousesCount) item(s) found in database,\npray to find them to earn bonuse(s)", actions: [closeAlert])
                            
                        }  catch let jsonErr {
                            LoadingIndicatorView.hide()
                            print("Error serializing json: ", jsonErr.localizedDescription, "\n")
                            self.showAlertMessage(title: "Nillous", message: "\nError serializing json\nor\nNo data json found in database.")
                            return
                        }
                    }
                }
            }
            task.resume()
        }
    }
}
