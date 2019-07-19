//
//  ActivityIndicatorViewController.swift
//  CustomeClass
//
//  Created by MacSameer on 19/01/19.
//  Copyright © 2019 MacSameer. All rights reserved.
//

import UIKit
import SwiftMessages

class MessageBarController: NSObject {
    
    func MessageShow(title : NSString , alertType : MessageView.Layout , alertTheme : Theme , TopBottom : Bool) -> Void {
        //Hide All popup when present any one popup
       // SwiftMessages.hideAll()
        
        //Top Bottom
        //1 = Top , 2 = Bottom
        
        let alert = MessageView.viewFromNib(layout: alertType)
        
        //Alert Type
        alert.configureTheme(alertTheme)
        alert.configureDropShadow()
        alert.button?.isHidden = true
        
        //Set title value
        alert.configureContent(title: "", body: title as String)

        var successConfig = SwiftMessages.defaultConfig
        
        //Type for present popup is bottom or top
        (TopBottom == true) ? (successConfig.presentationStyle = .top):(successConfig.presentationStyle = .bottom)
        //successConfig.duration = .seconds(seconds: 0.25)
        
        //Configaration with Start with status bar
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        
        
        SwiftMessages.show(config: successConfig, view: alert)
    }

}
