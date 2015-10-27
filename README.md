# Plum-O-Meter
###3D Touch Application for Weighing Any sort of soft-skinned fruits or vegetables

##### Based on FlexMonkey's original version  at https://github.com/FlexMonkey/Plum-O-Meter

Added an extension to the app that adds the ability to weigh the fruit, based on normalizing with a kitchen scale (probably not that accurate)

```swift

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
            return (percentStrength / 0.23758865)
        }
    }
}

```

##Note on Weight Accuracy

Turns out (with my terrible math) that force touch maxes out at about 430 grams (google it America!) so applying more pressure than that will still only register the maximumPossibleForce by the touch event. Useful for measuring the weight of fruit, but not much else.
