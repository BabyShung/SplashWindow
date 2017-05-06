# SplashWindow
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

## About
This is an UIWindow-based touchID authentication view control written in Swift.



<div>
<kbd>
<img src="https://cloud.githubusercontent.com/assets/4360870/25762430/a39135e2-31ac-11e7-968b-06d82280bee9.gif" width="200">
<img src="https://cloud.githubusercontent.com/assets/4360870/25762432/a393ee54-31ac-11e7-9222-f9dad7756f68.gif" width="200">
<img src="https://cloud.githubusercontent.com/assets/4360870/25762433/a3975d28-31ac-11e7-976c-c0e2492b7ba0.gif" width="200">
<img src="https://cloud.githubusercontent.com/assets/4360870/25762431/a393ceba-31ac-11e7-8106-ba553bdf302f.gif" width="200">
</kbd>
</div>

## Integrate framework

#### 1. **[Carthage](https://github.com/Carthage/Carthage)** - Just follow Carthage configure steps.
- install carthage 

- create Cartfile (touch Cartfile)

- add framework in Cartfile
> github "BabyShung/SplashWindow"

- run "carthage update"

- bind frameworks in your project (add a shell script in build phase and bind the paths of frameworks)

#### 2. Manually 

## How to configure:

There is a "Demo" folder in the repo. You will find three targets, two of them are the needed frameworks. Just run the project and you can drag both SplashWindow.framework and ZHExtension.framework to your "Linked Frameworks and Libraries".

1.Make sure "Always Embed Swift Standard Libraries" in "Build Settings" is set to Yes

## Warnings
- iOS8+
- Sometimes after you've set the launchScreen image in your storyboard or xib, the splash screen is showing a blank view when running. This is a cache issue. To fix it, clean your project. If it still doesn't work, reboot your device or reset your similator.
