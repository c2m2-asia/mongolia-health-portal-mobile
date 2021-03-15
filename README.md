
<div align="center"><strong>Mongolia Health Portal</strong></div>
<div align="center">Accumulating health services data with OpenStreetMap</div>

<br />

<div align="center">
  <sub>Maintained by <a href="http://www.kathmandulivinglabs.org/">Kathmandu Living Labs</a> </sub>
</div>

<br />

Mongolia Health Portal - Mobile is developed using in Flutter for visualizing data for health services and pharmacies in Mongolia. This will allow an immersive and consistent experience across any device: mobile, tablet or web.

## Building and running the app

### 1. Clone the repository

```bash
git clone https://github.com/c2m2-asia/mongolia-health-portal-mobile
```
### 2. Set the API base url 
The default base url is set to Mongolia Health Portal's API base url. If you are trying the API for different city, replace the value of string `API_BASE_URL` in `strings.dart`. The link to API documentation can be found [here](https://c2m2mongolia.klldev.org/apidocs/).

### 3. Run the App
Run `flutter run` while you have a device connected to the computer or an emulator running and now you can run it.

## Current features

The features currently available in the mobile client are:
* Map-based data visualization for Health services 
* Search data for health services and pharmacies
* Filter data based on different scope
* Bookmark/Saving the selected data
* Share the selected data across multiple platforms
* Turn by turn navigation

## Mobile App
* [iPhone](https://testflight.apple.com/join/fz5RVcYV)
* [Android](https://play.google.com/store/apps/details?id=kll.c2m2.c2m2_mongolia)

## Packages Used

We recommend you to go through the packages below for better understanding of the code flow, especially if you are new to the packages been used: 
- flutter_map (https://pub.dev/packages/flutter_map)
- Hive db (https://pub.dev/packages/hive)
- Riverpod (https://pub.dev/packages/riverpod)
- Dio (https://pub.dev/packages/dio)
- flutter_mapbox_navigation(https://pub.dev/packages/flutter_mapbox_navigation)


### Other Configuration
  This app uses [flutter_mapbox_navigation](https://pub.dev/packages/flutter_mapbox_navigation) library for Turn by turn navigation which requires a [Mapbox access token](https://account.mapbox.com/access-tokens/). 

  #### a. Android
  Add your token in `string.xml` file of your android apps res/values/ path as below:

  ```
  <string name="mapbox_access_token" translatable="false">PASTE_YOUR_TOKEN_HERE</string>
  ```

  #### b. iOS
  Add your token in `Info-Debug.plist` and `Info-Release.plist` as below:

  ```
  <key>MGLMapboxAccessToken</key>
  <string>PASTE_YOUR_TOKEN_HERE</string>
  ```

## Contributing

If you'd like to contribute for other cities, clone the repository and push your changes to `data-portal-cityname` branch. You may also fork the repository and contribute to this open source data portal Mobile client.

## Links

- Issue tracker: https://github.com/c2m2-asia/mongolia-health-portal-mobile/issues
  - In case of sensitive bugs like security vulnerabilities, please contact
    TechTeam@kathmandulivinglabs.org directly instead of using issue tracker. We value your effort
    to improve the security and privacy of this project!
- Related projects:
  - Mongolia Health Portal - Web Client: https://github.com/c2m2-asia/mongolia-health-portal-client

## Partners

This project is a part of the C2M2 project with Kathmandu Living Labs and Public Lab Mongolia as project partners.

<a href="https://www.publiclabmongolia.org/" target="_blank"><img src="https://www.publiclabmongolia.org/wp-content/uploads/2019/11/cropped-logo-design-public-1-100x103.png" height="80" width="80"></a>
<a href="http://www.kathmandulivinglabs.org/" target="_blank"><img src="https://avatars.githubusercontent.com/u/5390948?s=280&v=4" height="80" width="80"></a>

## License
This project is licensed under the MIT license, Copyright (c) 2019 Maximilian
Stoiber. 
