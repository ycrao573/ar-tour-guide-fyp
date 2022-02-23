# Travelee

<img src="./assets/images/banner.png" style="zoom:100%;" />

#### *Your next-generation tour guide, Your trustable travel assistant.*

This is the code repository for my final year project (FYP) in Nanyang Technological University. The project is named "Next-Generation Tour Guide - an AR Travel Assistant". It is a full-stack mobile application development project, which is expected to design and develop an Android application to create a modern travel experience for travelers by applying some advanced technologies.

The total duration of this final year project is around 10 months, starting from the mid of August, 2021, whereas the whole development process starts from mid of September, 2021. It is expected to be fully completed by March.

**[Important!]** Noted that the **version 1.0** is already available through the download link [here](https://github.com/ycrao573/ar-tour-guide-fyp).

## About Travelee

#### <u>Why named *Travelee*?</u>

*The suffix* **-er** *is used to describe a person or thing that does or provides an action.*

*The suffix* **-ee** *describes the person or thing that receives the action.*

- **Traveler** - a person who travels
- **Travelee** – the thing receives the action => travelling

#### <u>Product Positioning</u>

- **A smart travel assistant** who provides travelers with useful travel tips and advice, to help them better explore local highlights and discover nearby “treasures”.
- **A trustable partner** who accompanies travelers throughout the journey, providing convenient tools and intuitive information at your fingertips
- **A local culture ambassador** who aims to promote local tourism, introduce local culture and hotspots to travelers around the world

#### <u>Our Objectives</u>

- **Enhance travel experience** by making use of modern technologies (e.g., AR, ML) 
- **Present** travellers with **useful travel tips/information** in an intuitive way.
- Help travellers **better explore their neighbourhoods** by giving smart recommendation
- Bring **convenience** to travellers by providing some innovative travel tools.

## Highlights

### **Live View AR Experience**

Augmented Reality (AR) is used here to enhance the view of your surroundings! Simply Use your phone’s camera to **unlock a new way of exploring nearby places!**

- [x] Places are displayed as virtual signs in all directions of the camera view
- [x] **Get live distances and useful information** for each place with just one click!
- [x] **Support 3 predefined categories:** shopping centres, MRT stations, tourist attractions
- [x] **Flexible distance filtering:** Avoid places flooding!
- [ ] [NEW!] Support user-customized places. Add and view any place you care about!
- [ ] [NEW!] Support multi-user real-time location tracking with AR enabled. Location sharing within your tour group! 

**AR SDK resource:**

<img src="./assets/images/wikitude.jpg" style="zoom:75%; float: left" />

**Data resource:**

- MRT stations: https://en.wikipedia.org/wiki/List_of_Singapore_MRT_stations
- Shopping centres: https://en.wikipedia.org/wiki/List_of_shopping_malls_in_Singapore
- Tourist attractions: https://data.gov.sg/dataset/tourist-attractions
- Coordinate service: https://www.onemap.gov.sg/docs/

### **ML-based Landmark Detection**

This intelligent detection leverages the power of Google AI Cloud and its powerful pretrained ML model. In short, **search whatever you see!**

- [x] **Recognise landmarks** **around the world** from camera/your gallery, and get the result within 3 seconds!
- [x] **Robust detection:** The detection works best if it's a well-known landscape. Even it's not a landmark, we will still try to provide our best guessed result.
- [x] **Aesthetic and easy-to-use UI:** Seamless photo upload process, intuitive result presentation and useful discovery tools.

**API resource:**

<img src="./assets/images/google3.png" style="zoom:90%; float: left" />

### **Smart Recommendation & Notification**

- [x] **Get real-time recommendation** on interesting places nearby, e.g., activities, landmarks, restaurants
- [x] **Automatic notification push:** Travelee will notify you if
  - if you are close enough to one of popular landmarks
  - if you’ve made your way to the destination

- [x] **Automatic recommendation push:** recommend popular places nearby occasionally

**Data resource:**

- Activities: https://kampung-api.herokuapp.com/attractions/ *[Source: Goh Zong Han]*
- Landmarks: https://data.gov.sg/dataset/tourist-attractions
- Restaurants: https://rapidapi.com/apidojo/api/travel-advisor/

### **Convenient Travel Tools**

- [x] **Weather info: **Get the latest weather conditions based on the user's location
- [x] **COVID-19 Support: **Travel safely and confidently with one-click access to latest local COVID-19 situation and safety information

**API resource:**

weather: https://openweathermap.org/api

COVID-19 support: [disease.sh - Open Disease Data API](https://corona.lmao.ninja/)

## Technical Content

### Tech stack involved

**Travelee** is an **Android application** mainly developed using Flutter SDK. It should be installed and run smoothly on any Android devices that support Google AR services. Theoretically, with certain configuration and debugging, it should also support iOS devices. However, considering time, labour, and device cost [I didn't own a Mac machine :(], this project will only focus on Android development.

**Programming Languages:**

​	Dart (Flutter), HTML/JavaScript/CSS (Wikitude), Python (for web scraping & data cleaning), Ruby (localization)

**Software SDKs:**

​	Flutter SDK, Wikitude SDK, Android SDK

**Cloud Support:**

​	Google Authentication, Google Vision API, JSONBin.io, Firebase [Authentication & Firestore]

**Other Skills:**

​	Knowledges on JSON, XML, YAML, Gradle, Markdown.

​	Send HTTP request for fetching data or calling APIs.

### Difficulties met

1. **Global outage: JFrog to Shut down JCenter and Bintray**, click [here](https://www.infoq.com/news/2021/02/jfrog-jcenter-bintray-closure/) for more information. It is suggested to migrating all the dependencies to Maven Central. Detailed implementation can be found in the [commit](https://github.com/ycrao573/ar-tour-guide-fyp/commit/278571d765fa33948a1684f7ce9dfe4a143c0d23#diff-197b190e4a3512994d2cebed8aff5479ff88e136b8cc7a4b148ec9c3945bd65a) done on Jan 13th.
2. Uneasy configuration needed for merging Wikitude AR SDK into Flutter SDK. Best way to deal with it to post or search your question in [Wikitude's Support Community](https://support.wikitude.com/support/home).
3. Google Vision AI provides no Flutter support on its Landmark Detection and Web Search features. We need to build the process including image processing, API calling and package all the functions from the scratch. Detailed implementation can be found in [credentials](https://github.com/ycrao573/ar-tour-guide-fyp/blob/master/lib/pages/credentials.dart) and [recognition engine](https://github.com/ycrao573/ar-tour-guide-fyp/blob/master/lib/pages/recognize.dart), which is based on [Google API Client Library v1](https://developers.google.com/api-client-library).

<img src="D:\Android_Test\test_app\wikitude-flutter-plugin-examples\assets\images\workflow.jpg" style="zoom: 35%; float: left;" />

Special thanks to the valuable online resources that have been of great help to this project: ()

- [Working with APIs in Data Science — Explore Bit-Rent Theory in Singapore’s HDB Resale Market](https://towardsdatascience.com/working-with-apis-in-data-science-explore-bit-rent-theory-in-singapores-hdb-resale-market-d7760fdfc601)
- [Build and Deploy a Google Maps Travel Companion Application | React.js](https://www.youtube.com/watch?v=UKdQjQX1Pko&t=996s)
- [Flutter Live Location Tracker - Google map and Firebase + Source Code](https://youtu.be/Uz49GlqJ7m4)
- [Flutter Travel UI Tutorial | Apps From Scratch](https://youtu.be/CSa6Ocyog4U)
- [I Build a COVID-19 Tracker - Coronavirus Live Stats | React Tutorial](https://youtu.be/mhA11RJMHEM)

## Acknowledgement

Firstly, I would like to extend my gratitude to my FYP supervisor, A/P Ling Keck Voon for his guidance and support throughout this long journey. I also want to thank him for his involvement in our regular bi-weekly meeting, which helped me stay on schedule, organize my thoughts and guide me on how to present my ideas better. Despite having previous experience in software programming, it is still challenging to build a full-stack system on my own. This project greatly improved my ability to solve complex problems, learn new things quickly, and extract useful information from technical documentation.

I would also like to thank those who selflessly post their high-quality technical blogs and tutorials online, which greatly reduced the difficulty of development and helped people better understand concepts and their applications.

Next, I would like to thank my friends for accompanying me through this degree journey. You all played important roles and left me with unforgettable memories. I also want to thank everyone in our FYP group for their brilliant ideas and findings that may be helpful to each other's projects. Finally, I want to thank my family who has always been supporting me throughout the pandemic.

It's never been an easy journey, but I've enjoyed the whole experience of working on this project. Now I can proudly say that I was able to complete this final year project without compromising the standards I set for myself.