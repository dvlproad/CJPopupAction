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
            model.title = NSLocalizedString("Base", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-menu")
            model.classEntry = NSClassFromString("TSBaseAnimationHomeViewController")
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("Toast", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-folder")
            model.classEntry = NSClassFromString("TSToastHomeViewController")
            tabBarModels.append(model)
        }
        
        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("Window", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-folder")
            model.classEntry = NSClassFromString("TSWindowAnimationHomeViewController")
            tabBarModels.append(model)
        }

        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("CareAboutHide", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-folder")
            model.classEntry = NSClassFromString("TSCareAboutHideHomeViewController")
            tabBarModels.append(model)
        }
        
        do {
            let model = CQDMTabBarModel()
            model.title = NSLocalizedString("Extend", comment: "")
            model.normalImage = UIImage.cqresource_imageNamed("icons8-folder")
            model.classEntry = NSClassFromString("TSExtendHomeViewController")
            tabBarModels.append(model)
        }

        self.tabBarModels = tabBarModels
    }
}
