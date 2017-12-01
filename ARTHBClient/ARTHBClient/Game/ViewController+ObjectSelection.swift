/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Methods on the main view controller for handling virtual object loading and movement
*/

import UIKit
import SceneKit

extension ViewController: VirtualObjectSelectionViewControllerDelegate, VirtualObjectManagerDelegate {
    // MARK: - VirtualObjectManager delegate callbacks
    
    func virtualObjectManager(_ manager: VirtualObjectManager, willLoad object: VirtualObject) {
        DispatchQueue.main.async {
            // Show progress indicator
            self.spinner = UIActivityIndicatorView()
            self.spinner!.center = self.addObjectButton.center
            self.spinner!.bounds.size = CGSize(width: self.addObjectButton.bounds.width - 5, height: self.addObjectButton.bounds.height - 5)
            self.addObjectButton.setImage(#imageLiteral(resourceName: "buttonring"), for: [])
            self.sceneView.addSubview(self.spinner!)
            self.spinner!.startAnimating()
            
            self.isLoadingObject = true
        }
    }
    
    func virtualObjectManager(_ manager: VirtualObjectManager, didLoad object: VirtualObject) {
        DispatchQueue.main.async {
            self.isLoadingObject = false
            
            // Remove progress indicator
            self.spinner?.removeFromSuperview()
            self.addObjectButton.setImage(#imageLiteral(resourceName: "add"), for: [])
            self.addObjectButton.setImage(#imageLiteral(resourceName: "addPressed"), for: [.highlighted])
        }
    }
    
    func virtualObjectManager(_ manager: VirtualObjectManager, couldNotPlace object: VirtualObject) {
        textManager.showMessage("CANNOT PLACE OBJECT\nTry moving left or right.")
    }
    
    // MARK: - VirtualObjectSelectionViewControllerDelegate
    
    func virtualObjectSelectionViewController(_: VirtualObjectSelectionViewController, didSelectObjectAt index: Int) {
        
        // values
        guard let cameraTransform = session.currentFrame?.camera.transform else {
            return
        }
        
        let definition = VirtualObjectManager.availableObjects[index]
        let object = VirtualObject(definition: definition)
        let position = focusSquare?.lastPosition ?? float3(0)
        
        print("\n", position, " - ", type(of: position), " - position.x: ", position.x, " - position.y: ", position.y, " - position.z: ",position.z)
        
        let indexObject: String = String(index)
        let image: String = object.definition.displayName
        let positionX = position.x
        let positionY = position.y
        let positionZ = position.z
        let x1 = cameraTransform[0].x
        let y1 = cameraTransform[0].y
        let z1 = cameraTransform[0].z
        let w1 = cameraTransform[0].w
        let x2 = cameraTransform[1].x
        let y2 = cameraTransform[1].y
        let z2 = cameraTransform[1].z
        let w2 = cameraTransform[1].w
        let x3 = cameraTransform[2].x
        let y3 = cameraTransform[2].y
        let z3 = cameraTransform[2].z
        let w3 = cameraTransform[2].w
        let x4 = cameraTransform[3].x
        let y4 = cameraTransform[3].y
        let z4 = cameraTransform[3].z
        let w4 = cameraTransform[3].w

        // parameters
        let parameters = ["image": image, "indexObject": indexObject, "positionX": positionX, "positionY": positionY, "positionZ": positionZ, "x1": x1, "y1": y1, "z1": z1, "w1": w1, "x2": x2, "y2": y2, "z2": z2, "w2": w2, "x3": x3, "y3": y3, "z3": z3, "w3": w3, "x4": x4, "y4": y4, "z4": z4, "w4": w4] as [String : Any]

        // for TEST:

        // let parameters = ["image": "Cup", "indexObject": 2, "positionX": -0.0137424, "positionY": -0.0368241, "positionZ": -0.0368309, "x1": 0.0232212, "y1": -0.737753, "z1": 0.674671, "w1": 0, "x2": 0.99847, "y2": -0.0167582, "z2": -0.0526909, "w2": 0, "x3": 0.0501791, "y3": 0.674863, "z3": 0.736235, "w3": 0, "x4": -0.0111227, "y4": -0.00124113, "z4": 0.00195315, "w4": 1] as [String : Any]
        print("\n",parameters,"-",type(of: parameters))

        // urlPath
        let urlPath = scriptUrl + "/apithb/postNewNillous"
        let myUrl = URL(string: urlPath)
        print("\n",myUrl!)

        // request
        var request = URLRequest(url: myUrl!)
        request.httpMethod = "POST"

        // compose a query string
        let postString = (parameters.flatMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }) as Array).joined(separator: "&")
        print("\n",postString)

        // body
        request.httpBody = postString.data(using: String.Encoding.utf8)

        // session
        LoadingIndicatorView.show("- Loading -")
        self.delay(time: self._timer) {
            let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    LoadingIndicatorView.hide()
                    self.showAlertMessage(title: "Nillous", message: "Request timed out / Server not found")
                    print("error=\(String(describing: error))")
                    return
                }
                print("response = \(String(describing: response))")

                // convert response sent from a server side script to a NSDictionary object:
                DispatchQueue.main.async {
                    do {
                        // serializing json from data
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                        // parsing json
                        if let parseJSON = json {
                            print(parseJSON)

                            // check if nillous already exist in DB
                            let result: Bool = (parseJSON["result"] as? Bool)!
                            if (!result) {
                                LoadingIndicatorView.hide()
                                self.showAlertMessage(title: "Nillous", message: (parseJSON["message"] as! String))
                                return
                            }

                            // mapping data in struct // display object in scene
                            if (parseJSON["nillous"] as? NSDictionary) != nil {
                                LoadingIndicatorView.hide()
                                self.virtualObjectManager.loadVirtualObject(object, to: position, cameraTransform: cameraTransform, index: index)
                                if object.parent == nil {
                                    self.serialQueue.async {
                                        self.sceneView.scene.rootNode.addChildNode(object)
                                        self.enableButton()
                                    }
                                }
                            }
                        }
                    } catch let jsonErr {
                        LoadingIndicatorView.hide()
                        print("Error serializing json:", jsonErr.localizedDescription)
                        self.showAlertMessage(title: "Nillous", message: "\nError serializing json : \(jsonErr.localizedDescription)")
                    }
                }
            }
            task.resume()
        }
    }
    
    // Put Nillous Object in the plane
    func placingAllNillous(array: Array<Any>) -> Void {
        
        for i in 0...self.nillousesCount-1 {
            virtualObjectManager.nillouses = array as! [NillousCL]
            
            let index = virtualObjectManager.nillouses[i].indexObject
            let definition = VirtualObjectManager.availableObjects[index]
            let object = VirtualObject(definition: definition)
            let position = float3(virtualObjectManager.nillouses[i].positionX, virtualObjectManager.nillouses[i].positionY, virtualObjectManager.nillouses[i].positionZ)
            let cameraTransform = simd_float4x4([[virtualObjectManager.nillouses[i].x1, virtualObjectManager.nillouses[i].y1, virtualObjectManager.nillouses[i].z1, virtualObjectManager.nillouses[i].w1], [virtualObjectManager.nillouses[i].x2, virtualObjectManager.nillouses[i].y2, virtualObjectManager.nillouses[i].z2, virtualObjectManager.nillouses[i].w2], [virtualObjectManager.nillouses[i].x3, virtualObjectManager.nillouses[i].y3, virtualObjectManager.nillouses[i].z3, virtualObjectManager.nillouses[i].w3], [virtualObjectManager.nillouses[i].x4, virtualObjectManager.nillouses[i].y4, virtualObjectManager.nillouses[i].z4, virtualObjectManager.nillouses[i].w4]])
            
            print("\nposition: \(position), index: \(object), cameraTransform: \(cameraTransform)")
            
            virtualObjectManager.loadVirtualObject(object, to: position, cameraTransform: cameraTransform, index: index)
            serialQueue.async {
                self.sceneView.scene.rootNode.addChildNode(object)
            }
        }
    }
    
    func virtualObjectSelectionViewController(_: VirtualObjectSelectionViewController, didDeselectObjectAt index: Int) {
        virtualObjectManager.removeVirtualObject(at: index)
    }
    
}
