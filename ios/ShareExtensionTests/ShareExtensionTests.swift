//
//  ShareExtension_tests.swift
//  ShareExtension-tests
//
//  Created by Davis Whitehead on 2018-11-24.
//  Copyright © 2018 Facebook. All rights reserved.
//

import XCTest

class ShareExtensionTests: XCTestCase {
  
  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication().launch()
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
  func testExample() {
    // Launch ShareExtension
    let safariApp = openSafari(with: URL(string: "https://www.apple.com")!)
    openShareExtension(name: "ShareExtension", in: safariApp)
    
    // Take screenshot
    sleep(2)
    let windowScreenshot = safariApp.windows.firstMatch.screenshot()
    let attachment = XCTAttachment(screenshot: windowScreenshot)
    attachment.lifetime = .keepAlways
    add(attachment)
    
    // Save screenshot
    let fileManager = FileManager.default
    let fileName = "iOSShareExtensionTest.png"
    // // Save locally
    try! fileManager.createFile(
      atPath: ("/Users/dwhitehead/Documents/github/react-native-starter/tmp/" + fileName),
      contents: windowScreenshot.pngRepresentation
    )
    print(fileManager.temporaryDirectory.absoluteString)
    // // Save to device
    try! fileManager.createFile(
      atPath: (fileManager.temporaryDirectory.absoluteString + fileName),
      contents: windowScreenshot.pngRepresentation
    )
  }
}
