# sitaGrid

Goal:
⁃ Display a grid of items
⁃ Each row in the grid has 3 items
⁃ Each item show the image (if any) and name
⁃ Fetch the data from REST API https://2a6d3177-4681-4fc9-97b9-e4e9580db87a.mock.pstmn.io/airlines
⁃ Tapping on an item leads you to a detail view
⁃ The detail view shows image (if any), name, country and if it’s currently active
⁃ BONUS: Search through the items with a search bar at the top
⁃ BONUS: Persist the items so that they are available offline
⁃ BONUS: Each item can be assigned as favourite


Notes:

1. I choose to use UIKit instead of SwiftUI as your projects are written in UIKit.

2. I wanted to use RxSwift but I decided not to because I needed to import two big libraries. 
I decided to use Combine, for the first time together with UIKit. I used it with SwiftUI but not with UIKit.

3. I hardcoded API base url in the HttpClient here, but normaly this should be placed in a .xcconfig file, together with all configuration things.

4. There are couple of things that I don't like in the response.
Those are:
a. Id is received as a string, even it's always a number.
b. Active value is received as string, even it's should be bool

Having those two values as a string will complicate usage accross the app. 
So that's why I decided to create a separate model "AirlineData" which will be created by codable when parsing the response. And, another model "Airline" which will be created from first one. Second model will have id as Int and active as Bool, which will improve the usage and improve the app implementation.

5. One more thing, "Airline" instance is created from the "AirlineData" and by doind this I will convert the id value from String to Int.
If this fails, in most cases I would let the app crash as id value is not correct and by crashing we will see that something is not ok in response.
But, in this case when we have a lot of data in response I decided to handle this and rise an exception because I don't want the whole response to fail because of one or few failed airlines. When this happens, app will just skip and ignore failed airlines.

6. I decided to create a UI using Storyboards as this was the fastest way. Also I use Coordinates for controlling the ViewControllers. No segues. I use Coordinates also for dependency injection for ViewControllers and ViewModels. 

7. Data is downloaded from the server and stored in the local database. App reads data from the database and shows on the screen.

7. I am using CDPublisher, an combine publisher which is triggered every time when there is a change in the database, so the UI can be updated.

8. Unit tests: I created fake implementations and fixtures and I covered AirlineViewModel but I didn't had enough time to write all unit tests. Also for the same reason, for unit test target I didn't create separate AppDelegate and SceneDelegate.

9. As there are only couple of images in the response, I was using the random image generator `https://picsum.photos/800?random=\(id)` with images 800x800 px. This is applied only for the grid so I can test it with many images.

10. Item can be marked as favorite in detail screen. The status for this is visible on detail screen and on the grid, for each cell. Favorite info is stored in local database.
