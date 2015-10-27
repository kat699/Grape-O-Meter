//
//  UITouch+3DTouch.swift
//  Plum-o-Meter
//
//  Created by Stoo Sepp on 2015-10-26.
//  Copyright © 2015 Stoo Sepp. All rights reserved.
//

import Foundation
import UIKit

extension UITouch
{
    var percentStrength: CGFloat {
        get{
            return (force / maximumPossibleForce) * 100
        }
    }
    
    var weight: CGFloat {
        get{
            //This math is based on normalizing from a kitchen scale. Probably not that accurate
            return (percentStrength / 0.23191489)
        }
    }
}

