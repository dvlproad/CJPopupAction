//
//  TSPopupMainViewController.swift
//  TSDemo_Popup-Swift
//
//  Created by ciyouzen on 2026/7/27.
//  Copyright © 2026年 dvlproad. All rights reserved.
//

import UIKit
import CQDemoKit
import CQDemoResource
import TSDemo_Popup

@objc public class TSPopupMainViewController: CJUIKitBaseTabBarViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        var tabBarModels: [CQDMTabBarModel] = []

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("Popup ObjC", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-menu")
            model.classEntry = NSClassFromString("ViewController")
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("Popup Swift", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-folder")
            model.classEntry = NSClassFromString("ViewController")
            tabBarModels.append(model)
        }

        self.tabBarModels = tabBarModels
    }
}
