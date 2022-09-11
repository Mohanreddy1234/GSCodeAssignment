# GSCodeAssignment

Seach Option: Select the date from the picker it will show options "Done" and "Cancel", When the user press Done button it will update the title, date, explanation and image as per the server response, When the user press Cancel button it will dismiss the picker. 
Favorite Icon: Select the Heart icon on the Dashboard screen, when use the tap on the icon will show alert "Add" and "Cancel". 
Favorite Screen: Top right corner has the "Favorite", When the user taps on "Favorite" it will redirect to Favorite Dashboard. 
Delete Icon: In Favorite Dashboard has the Option to delete the item from the favorite list.

- Code Flow: Following MVVM Pattern development
- Network Flow - Network Wrapper to develop the code and can easily used where ever is needed
- Model - Following Codable
- ModelView - Following the MVVM Pattern Easily to write unit test cased.
- ViewController - ViewController is main view controller acts as Dashboard page, Favorite controller showing as favorite items is selected by user and error controller showing as error information when network not available.
- Utitlt - Support methods written this file
- Extensions - added extenions which needed for this project.
- Constants - Written all constants one place for feature controlled by the developer
- Storyboard - Developed UI by using storyboard concepts
- Added unit test cases by using the apple XCTest framework as well.
