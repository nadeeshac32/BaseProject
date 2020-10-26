# Mobile_Architecture_IOS


## Description
This project can be used as a Base Project which can be extended and implement on that. Supports MVVM-C Architecture and UI binding is powered by [RxSwift](https://github.com/ReactiveX/RxSwift).


## Features
- [x] Base MVVM-Coodinator architecture
- [x] Base List view & Base Grid view that adopts to Base MVVM architecture
- [x] Both Base Grid view & Base Grid view supports,
  - API Pagination,
  - Static data loading,
  - Search,
  - Section headers (Dynemic and custom).
  - Can eliminate all the boilerplate code and you only have to customise your UITableViewCell/UICollectionViewCell which extends from BaseTVCell/BaseCVCell.
- [x] Base Form view that adopts to Base MVVM architecture.
  - Form validations dynemically added by the validations that are set to the form Fields.
  - In addition to that you can add custome validations too.
  - Base Form view also adjusts dynemic spacing in keyboard show/hide modes.
- [x] Base Menu View Controller - This is an Andoid style(UI) tab bar controller which is it's tab item highlighting animation can be styled with underline or border.

## Common components
- [x] Swivel Bottom Tab Bar Controller - Tab bar controller that can be customise with Customised Tab Bar Items.
- [x] GoogleSignable and FacebookSignable - Social sign in capability with these protocols and there default implementations. Both adopts to Base MVVM architecture.
- [x] Swivel Document Picker - Re-usable Document picker to brows files and pick.
- [x] Swivel Document Viewer - Re-usable Document presenter to display documents.
- [x] Swivel Image Picker Controller - Re-usable Image picker controller.
- [x] Swivel Custom Text Fields - Re-usable Text fields that supports to Base Form view which abstracts validations within.
  - Swivel Normal Text Field - Normal text field with error message animation.
  - Swivel Right Button Action TextField - Action can be configured to a button which is inside the text field. Ex:- Clear, Hide/Show Secure text.
  - Swivel Prefix Select TextField - Prefix Selection can be configured to append to the text as a prefix. Ex:- Country Code Picker.
  - Swivel Max Charachters TextField - Charactor counter is appeared at the corner of the text field. Max charactor count, Color, Max count exeeding action can be configured.
  - Swivel Username Text Field - Once the user start to type numeric value it will show a country picker and changed to a mobile number input field. But when you type a letter it will change back to email input field.


## Requirements:
- [x] Xcode Version 10.3
- [x] Swift 5
- [x] iOS Version 11.0 or above


 ## Running Xcode Project and General changes
 - Open the project(.xcworkspace file) in Xcode
 - Select Environment: Go to Project(Tokobook) -> Tokobook -> Application -> AppConfig.swift (line 45) -> Change environment which you want to run (.prod / .dev / .qa)
 - Now you can simply run the project in simulator
  
  
## Project Architecture and Related details

Specifics                 | Details
--------------------------|------------------------------------------------------------------------
| Architecture - MVVM-C   | Used RxSwift to bind View and ViewModel. Coodinator are responsible for navigation flow
| Networking - Alamofire  | `Network` folder -<br/>- `Network\HTTPService.swift` <br/>- `Network\APIProtocols` folder - All the protocols are implemented in `HTTPService.swift` <br/>
| Base classes            | `BaseClassesAndGenerics` folder - All the base & generic classes reside within this folder. All the other classes are inherited from the classes which are within this folder.
| Models                  | `Models` folder - All the models used by the app reside within this folder. Almost all the models which are consumed by the Network Services are extending `BaseModel` class.
| Views                   | `Views` folder - All the UI elements reside within this folder. (Storyboards, ViewControllers, ViewModels, Common Reusable components, TableView Cells)
| App Config         	    | Used a simple Singleton class to keep the configuration parameters. All the values that are used by AppConfig are stored in `Configuration.plist`


## Dependancies

Name                          | purpose
--------------------------    | -----------------------------------------------------
[Alamofire](https://github.com/Alamofire/Alamofire) | Network library
[ObjectMapper](https://github.com/tristanhimmelman/ObjectMapper) | Mapping JSON objects into Swift classes
[SnapKit](https://github.com/SnapKit/SnapKit) | SnapKit is a DSL to make Auto Layout easy on both iOS and OS X.
[SwiftEntryKit](https://github.com/huri000/SwiftEntryKit) | SwiftEntryKit is a content presenter. Warnings and Success messages are presented using this.
[KeychainSwift](https://github.com/evgenyneu/keychain-swift) | Wraper to store data securely in Keychain.
[DropDown](https://github.com/AssistoLab/DropDown) | A Material Design drop down for iOS written in Swift.
[PinCodeTextField](https://github.com/tkach/PinCodeTextField) | Simple pin code text input with underlined space for characters.
[CountryPickerView](https://github.com/kizitonwose/CountryPickerView) | Simple Country Picker View.
[DatePickerDialog](https://github.com/squimer/DatePickerDialog-iOS-Swift) | Simple Date Picker View.
[Agrume](https://github.com/JanGorman/Agrume) | Image display view.
[CalendarDateRangePickerViewController](https://github.com/miraan/CalendarDateRangePickerViewController) | Simple date range picker.
[RxCocoa](https://github.com/ReactiveX/RxSwift) | This is a Swift version of Rx.
[RxAppState](https://github.com/pixeldock/RxAppState) | let you observe all the changes in your Application's state.
[RxDataSources](https://github.com/RxSwiftCommunity/RxDataSources) | You need this to bind complex data sets with multiples sections, or when you need to perform animations when adding/modifying/deleting items.
[GoogleSignIn](https://developers.google.com/identity/sign-in/ios/start-integrating) | Google Sign in functionality
[FBSDKLoginKit](https://developers.facebook.com/docs/facebook-login/ios/) | Google Sign in functionality

## License

Copyright © 2020 Swivel Tech. All rights reserved.
