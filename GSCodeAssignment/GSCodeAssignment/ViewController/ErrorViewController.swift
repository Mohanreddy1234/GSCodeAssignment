//
//  ErrorViewController.swift
//  GSCodeAssignment
//
//  Created by Mohanreddy Batchu on 09/09/22.
//

import Foundation
import UIKit

class ErrorViewController: UIViewController {
    
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    var errorMessage:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.errorMessageLabel.text = self.errorMessage
    }
    
    func dismissView()  {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: Touches began
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch: UITouch = touches.first {
            if (touch.view == self.view) {
                self.dismissView()
            }
        }
    }
    
    deinit {
        Utility.customLog(Constants.freeErrorViewControllerMemory)
    }
}
