# ![Apple TV](https://cloud.githubusercontent.com/assets/1049693/11407062/c1891a92-93b0-11e5-9270-745cf4fa4152.png) Uitzending Gemist 

[![Build Status](https://travis-ci.org/4np/UitzendingGemist.svg?branch=master)](https://travis-ci.org/4np/UitzendingGemist)
[![Release](https://img.shields.io/github/release/4np/UitzendingGemist.svg)](https://github.com/4np/UitzendingGemist/releases/latest)
[![Commits Since](https://img.shields.io/github/commits-since/4np/UitzendingGemist/1.6.0.svg?maxAge=3600)](https://github.com/4np/UitzendingGemist/commits/master)
[![Platform](https://img.shields.io/badge/platform-tvOS%2010-green.svg?maxAge=3600)](https://developer.apple.com/tvos/)
[![Swift](https://img.shields.io/badge/language-Swift-ed523f.svg?maxAge=3600)](https://swift.org)
[![codebeat badge](https://codebeat.co/badges/a5990b60-12ce-4f22-a875-31b2ccaecfcd)](https://codebeat.co/projects/github-com-4np-uitzendinggemist)
[![Open Issues](https://img.shields.io/github/issues/4np/UitzendingGemist.svg?maxAge=3600)](https://github.com/4np/UitzendingGemist/issues)
[![Closed Issues](https://img.shields.io/github/issues-closed/4np/UitzendingGemist.svg?maxAge=3600)](https://github.com/4np/UitzendingGemist/issues?q=is%3Aissue+is%3Aclosed)

```UitzendingGemist``` is an unofficial native ```Uitzending Gemist``` and ```NPO Live``` application for the Apple TV 4 developed in [Swift](https://developer.apple.com/swift/). It will allow you to browse and watch all video streams of the Nederlandse Publieke Omroep's (e.g. NPO, the Dutch public broadcaster) [Uitzending Gemist](http://www.npo.nl/uitzending-gemist) website on your Apple TV.

![TopShelf](https://github.com/4np/UitzendingGemist/blob/master/UitzendingGemist/Assets.xcassets/App%20Icon%20&%20Top%20Shelf%20Image.brandassets/Top%20Shelf%20Image.imageset/TopShelf.png?raw=true)

Watching videos is very snappy and almost instantaneous, contrary to streaming from your iDevice to Apple TV over Airplay or using the built-in player in your smart tv. This is a _truly_ native app contrary to some of the other apps that I have seen which are basically webcontainers
using a web app hosted on a remote server.

# Features

- Fast *_native_* app for Apple TV
- Confirmed to work abroad via [Unlocator](https://unlocator.com/account/aff/go/fMJQHpiASKffCbxepcEY?keyword=readme) (_disable_ the secure transport setting in the configuration view)
- Easy to use interface for browsing Programs and Episodes
- Live streaming TV and themed channels
- The possibility to (un)favorite programs
- Remembers watched episodes and will allow you to resume watching
- Will show you new unwatched episodes of favorite programs
- Closed Captioning for the deaf and hearing impaired (in _Dutch_)
- The ability to watch YouTube videos for Programs that have [YouTube Resources](https://github.com/4np/NPOKitResources)

# Donate

![donations-banner](https://cloud.githubusercontent.com/assets/1049693/23892645/c292896c-089b-11e7-9c9a-2c8f60d64c0a.jpg)

If you find this application useful and you would like to do something back, you could install [Bait App](https://itunes.apple.com/nl/app/bait/id1207460654) from the MacApp Store and purchase the € 1,99 in-app purchase 🙌🏻

# Okay, that's all great! But how do I get this on my ![Apple TV](https://cloud.githubusercontent.com/assets/1049693/11407062/c1891a92-93b0-11e5-9270-745cf4fa4152.png)?

Unfortunately the app cannot be distributed in the AppStore as the NPO does not allow third parties in doing so. However, using a _free_ Apple Developer account you *can* compile it yourself and install it in your own Apple TV 4 (_but also read the note below_). While this may sound scary and difficult to non-technical users, it's really not that hard if you follow these steps :)

**Prerequisites:**

- an [Apple TV](http://www.apple.com/tv/) 4th or 5th generation (the ones that have an AppStore)
- run tvOS 10 or 11
- a recent Apple Computer running ```macOS 10.11.x El Capitan or higher```
- a (free) Apple Developer account (signup [here](http://developer.apple.com))
- a [USB-C cable](http://www.apple.com/nl/shop/product/HHSP2ZM/B/belkin-usb-c-naar-usb-a-oplaadkabel?fnode=85) to connect your Apple TV to your Apple Computer

_Note: as of summer 2016 Apple has reduced the free Developer account provisioning from 90 days to a mere 7 days, which means when you are using a free Apple Developer Account the application [will expire every 7 days](http://mybyways.com/blog/new-limitations-imposed-on-free-apple-developer-account) after which you need to re-deploy the app (make sure to keep your bundle identifier the same for your favorites to stick). The paid Apple Developer Accounts do not have a time based limitation and deployed apps will continue to work during the lifetime of your subscription._

## 1. Xcode

The (latest) code was developed in [Xcode 9](https://itunes.apple.com/nl/app/xcode/id497799835)([alternative link](https://developer.apple.com/download/more/)) so you need at least to have that version installed. Continue with the following steps when you have finished installing ```Xcode``` as the next steps require a finished installation.

## 2. Download the project

You can either download a zipped distribution (novice) or use Git (advanced).

### 2.1 Download the zipfile

For novice users it is probably the easiest route to just download the [latest zipped version](https://github.com/4np/UitzendingGemist/archive/master.zip) and continue with step 3. After installation to your Apple TV you are safe to delete the downloaded project but keep the _Bundle Identifier_ (see step 5) you used in mind as you will need to use it again when you want to redeploy your app to your Apple TV (in the case of software updates or when your free developer limit (7 days) runs out). 

### 2.2 Using Git

While not required, it is advisable to have a ```Developer``` folder on your machine. Execute the following code in ```Terminal``` to create those folders and clone this project:

```
mkdir -p ~/Developer/tvOS
cd ~/Developer/tvOS
git clone https://github.com/4np/UitzendingGemist.git
cd UitzendingGemist
```

If you are not experienced with Git, you can _pull_ new changes using:

```
cd ~/Developer/tvOS/UitzendingGemist
git fetch
git pull
```

Instead of using the terminal you can also use a graphical client like [SourceTree](https://www.sourcetreeapp.com) (generic) or [GitHub Desktop](https://desktop.github.com) (GitHub specific).

## 3. Open the project

Now that everything is in place, you can open the project file ```UitzendingGemist.xcworkspace``` (and _not_ the ```xcodeproj``` file)in ```Finder```. Alternatively, when you still have ```Terminal``` open you can also execute the following command:

```
open UitzendingGemist.xcworkspace
```

## 4. Connect the Apple TV 4 to your computer

Connect the ```Apple TV 4``` using the USB-C cable to your Mac and perform / click through the following steps in Xcode:

![Steps to perform](https://cloud.githubusercontent.com/assets/1049693/20404995/8b810916-ad07-11e6-8715-87b3732ecf3a.png)

## 5. Change the Bundle Identifier

The bundle identifier (see **4** in the screenshot above) uniquely identifies your app. As you cannot reuse mine, you need to set your own bundle identifier in reverse domain format (for example: com.yourname.UitzendingGemist). Make sure you remember the name as you will need to enter the same bundle identifier when you want to update or re-deploy the app to your AppleTV.

_Note: using a different identifier will make the app deploy next to a previous installation and separate favorites. Keeping the identifier the same will make the favorites continue to work after updates. Also *free* Apple Developer Accounts have a limit on the number of different identifiers you can create on a weekly basis (10)._

## 6. Select the team

In order to deploy the application to the Apple TV it needs to be signed with your team (see **5** in the screenshot above). If you do not have a team (e.g. ```None```), or you see the message ```No Matching provisioning profiles found``` click the ```Fix Issue``` and login with your Apple ID / Apple Developer Account credentials.

## 7. Select the Build Device

On the top left in Xcode click on the device the compiled program will be deployed to (see **6** in the screenshot above). If your Apple TV 4 is properly connected you will be able to pick you Apple TV device (otherwise it will run in the Simulator).

## 8. Run the application

Finally you are able to compile the program and deploy it onto your Apple TV! Click the play icon (see **7** in the screenshot above). The application will be compiled and deployed on your Apple TV 4. After this the application will remain on the Apple TV. 

_Note: if you encounter issues or you are unable to play, this is where you should debug what it going on. Observe the Xcode console output while leaving your Apple TV connected. Alternatively you can also run in the simulator (see **6** in the screenshot above) and observe the Xcode console output to debug the issues you are experiencing._

## 9. Sit back and enjoy :)

You're done! You can disconnect your Apple TV and start watching! :)

# Firewalls

If you have set up a firewall to filter _outbound_ network requests, make sure to configure it to allow the following URL patterns you can expect the app to call (also see [#18](https://github.com/4np/UitzendingGemist/issues/18)):

- apps-api.uitzendinggemist.nl (the API)
- api.github.com (check for new releases)
- *.omroep.nl (images, videos and live streams)
- googleapis.com (youtube API)
- youtube.com (youtube videos)
- freegeoip.net (determine your country by ip)

_Note: as the video and image content URLs come from the APIs, although unlikely, these URLs *might* change_

# Screenshots

## Application Icon

![App Icon](https://cloud.githubusercontent.com/assets/1049693/17006428/12c66edc-4ee1-11e6-9e4a-0f057bcad5bf.gif)

## Application screen with Application Icon and Top Shelf image

![Main Screen](https://cloud.githubusercontent.com/assets/1049693/11430705/e585f7aa-948a-11e5-8b4d-a35dc1ab617a.png)

## Tip Screen

![Tip Screen](https://cloud.githubusercontent.com/assets/1049693/18724167/ba26d9ba-803b-11e6-9c76-2f44c47d2dee.png)

## Episode Screen

![Episode Screen](https://cloud.githubusercontent.com/assets/1049693/17333941/b3440e30-58d4-11e6-8338-1e450b8b29db.png)

## Continue Watching

![Continue Watching](https://cloud.githubusercontent.com/assets/1049693/17069835/116a35fe-5059-11e6-8e21-bf75d2209732.png)

## Program Screen

![Program Screen](https://cloud.githubusercontent.com/assets/1049693/17334014/f9e93978-58d4-11e6-8a81-aed35d100ff5.png)

## By Day Screen

![By Day](https://cloud.githubusercontent.com/assets/1049693/17333843/448ba638-58d4-11e6-9934-6c2faa973cbb.png)

## By Program Screen

![By Program](https://cloud.githubusercontent.com/assets/1049693/17334126/57f71c38-58d5-11e6-9dfe-d4f1a4ddbb45.png)

## Live TV Screen

![Live TV](https://cloud.githubusercontent.com/assets/1049693/18724305/479ddd3e-803c-11e6-912d-674eb207198a.png)

## Update Screen

![Update Screen](https://cloud.githubusercontent.com/assets/1049693/17013518/61df0220-4f1f-11e6-81eb-340f0fe0c452.png)

## Program with a YouTube channel

Several programs have [additional YouTube content](https://github.com/4np/NPOKitResources) available. 

![YouTube Button](https://cloud.githubusercontent.com/assets/1049693/20447426/08b7e0da-addf-11e6-90a3-fc3a094a8d92.png)

![YouTube Channel](https://cloud.githubusercontent.com/assets/1049693/20447425/08aaed3a-addf-11e6-88f8-346ed87f6ca9.png)

## Content Availability

Content that is geographically restricted will show a warning then you are outside of The Netherlands. While the play button remains enabled you will most likely be unable to watch the video. If you encounter such warnings and are unable to play the respective videos, you might give [Unlocator](https://unlocator.com/account/aff/go/fMJQHpiASKffCbxepcEY?keyword=readme) a try. It has been confirmed to work reliably with the Uitzending Gemist tvOS app when you disable the _secure transport_ setting in the configuration screen (see below).

![Region Check](https://cloud.githubusercontent.com/assets/1049693/23863344/d8cf8004-080f-11e7-8752-5f92de247f33.png)

## Configuration

When using [Unlocator](https://unlocator.com/account/aff/go/fMJQHpiASKffCbxepcEY?keyword=readme) outside of The Netherlands, disable the _secure transport_ setting (which is enabled by default).

![Configuration](https://cloud.githubusercontent.com/assets/1049693/24857070/456dc044-1de7-11e7-89a7-463f057b68ee.png)

## Closed Captioning

When closed captioning is enabled in the configuration screen (see above), all content will be subtitled (when available).

![screen shot 2017-03-22 at 22 32 26](https://cloud.githubusercontent.com/assets/1049693/24221660/86d5cd98-0f4f-11e7-9ae6-aed889b50f24.png)

# License

See the accompanying [LICENSE](LICENSE) and [NOTICE](NOTICE) files for more information.

```
Copyright 2016 Jeroen Wesbeek

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

