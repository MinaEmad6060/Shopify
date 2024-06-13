//
//  Settings.swift
//  Shopify
//
//  Created by Slsabel Hesham on 13/06/2024.
//

import UIKit
import DropDown

class Settings: UIViewController {
    @IBOutlet weak var curruncyLabel: UILabel!
    
    @IBAction func curruncyBtn(_ sender: Any) {
        curruncyDropDown.show()
    }
    @IBOutlet weak var curruncyView: UIView!
    
    let curruncyDropDown = DropDown()
    let curruncies = ["EGP" , "EUR" , "Dollar"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        curruncyDropDown.anchorView = curruncyView
        curruncyDropDown.dataSource = curruncies
        curruncyDropDown.bottomOffset = CGPoint(x: 0, y: (curruncyDropDown.anchorView?.plainView.bounds.height)!)
        curruncyDropDown.topOffset = CGPoint(x: 0, y: (curruncyDropDown.anchorView?.plainView.bounds.height)!)
        curruncyDropDown.direction = .bottom
        curruncyDropDown.selectionAction = { [weak self]
            (index: Int , item: String) in
            self?.curruncyLabel.text = self!.curruncies[index]
                
            
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
