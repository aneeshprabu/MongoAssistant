<p align="center">
  <a href="https://i.imgur.com/Dc8R4IX.png" target="blank"><img src="https://i.imgur.com/Dc8R4IX.png" width="500" alt="Assistant Logo" /></a>
</p>

<p align="center">Built with <a href="https://codemagic.io/start/" target="_blank">CodeMagic</a> framework</p>

<div align="center">

  <a href="">![SwiftUI](https://img.shields.io/badge/SwiftUI-orange.svg)</a>
  <a href="">![iOS](https://img.shields.io/badge/os-iOS-green.svg?style=flat)</a>
  <a href="">![Build](https://api.codemagic.io/apps/63be3abdc21f171fa5cf115d/mongo-assistant-workflow/status_badge.svg)</a>

</div>

# Mongo Assistant
#### A new way to access and manage your MongoDB

## 🤖 Architecture

![Mongo Assistant Architecture](https://i.imgur.com/D3DwODY.jpg)

## 📝 Description

This is the front end application for Mongo Assistant. Mongo Assistant is application that allows you to execute MQL directly on to you Atlas by using Natural Language. We have a Regex trans-compiler present in the backend that evaluates every MQL query and executes them.

The trans-compiler uses a method mapper that maps MQL keywords to mongo driver methods. See the image below - 

<p align="center">
  <a href="https://i.imgur.com/rx4v94R.png" target="blank"><img src="https://i.imgur.com/rx4v94R.png" width="500" alt="method mapper" /></a>
</p>

The application also can convert Natural Language to Aggregation pipeline queries which can be copied and used in Atlas.

## 🏛️ Frameworks and Libraries

- [SwiftUI](http://nestjs.com) - Framework uses Swift to build the app. 
- [XCode](https://www.mongodb.com) - Code Editor
- [Alamofire](https://www.mongodb.com/docs/drivers/node/current) - Rest API
- [CodeEditor](https://github.com/ZeeZide/CodeEditor) - A Library to enable code editors in your app.
- [SwiftyJSON](https://github.com/SwiftyJSON/SwiftyJSON) To Decode JSON responses from Alamofire


## 🧠 FastAPI (Backend)

The brain of Mongo Assistant. Please visit the below link.
 [](Link)


![https://i.imgur.com/nVqHAqa.png](https://i.imgur.com/nVqHAqa.png)

## 🎮 For local usage:
- Install Xcode https://apps.apple.com/in/app/xcode/id497799835?mt=12
- Clone project to a directory 
- Open MongoGPT3Demo.xcodeproj
- Select a simulator on the top MongoGPT3Demo > Iphone 14 Pro (or any simulator that you like)
- Press play button on top left to build and run
- APIs will not work because the strings are empty for security and cost reasons purposes
**Please DM me for the URL**

## CICD using CodeMagic

Code magic builds the app without code signing. Code signing requires a Apple 99$ Development subscription. If I had the subscription I can setup App connect and link testflight to it. When the app builds it'll get deployed in TestFlight which can be used by people to test the app.

![https://i.imgur.com/Ycgnm1C.png](https://i.imgur.com/Ycgnm1C.png)


## Connect to Atlas

Connect your application to Atlas to execute generate MQL quries

<img src="Images/connect.png" width=20% height=20%>


## Generate MQL queries with Natural Language


<img src="Images/mql.png" width=20% height=20%>


## Learn more about MongoDB


<img src="Images/chat.png" width=20% height=20%>

## License

MIT
