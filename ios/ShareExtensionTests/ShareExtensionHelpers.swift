//
//  XCTestCaseExtensions.swift
//
//  Useful extension to UI Test the Share Extension of apps.
//
//
//  Created by Antoine van der Lee on 18/05/2018.
//  Copyright © 2018. All rights reserved.
//
//  https://gist.github.com/AvdLee/719b2de80d74fc503ca1c64a23706d93

import XCTest

extension XCTestCase {
  
  /// Opens the Safari App for UI Testing with the given URL.
  ///
  /// - Parameter url: The URL to open.
  /// - Returns: The `XCUIApplication` pointing to the Safari App.
  func openSafari(with url: URL) -> XCUIApplication {
    let safariApp: XCUIApplication = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
    
    // Start the Safari app as we're starting test from there.
    safariApp.launch()
    
    // Wait for Safari to be the active application.
    let safariAppActiveExpectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "state == \(XCUIApplication.State.runningForeground.rawValue)"), object: safariApp)
    wait(for: [safariAppActiveExpectation], timeout: 10)
    
    // Tap the domain search field and enter the url.
    let urlBar = safariApp.otherElements["URL"]
    XCTAssert(urlBar.waitForExistence(timeout: 3.0), "The URL Bar should exist after opening Safari.")
    urlBar.tap()
    
    let urlTextField = safariApp.textFields["URL"]
    XCTAssert(urlTextField.waitForExistence(timeout: 3), "Even with large pages with expect the urlTextField to be available after 3 seconds")
    urlTextField.typeText(url.absoluteString)
    safariApp.keyboards.firstMatch.buttons["Go"].tap()
    
    return safariApp
  }
  
  
  /// Opens the share extension for the given name.
  ///
  /// - Parameters:
  ///   - name: The name of the Share Extension to open.
  ///   - application: The application in which we're trying to open the share extension. This application must contain a share extension button.
  func openShareExtension(name: String, in application: XCUIApplication) {
    // Open the share sheet
    let shareButton = application.toolbars.buttons["Share"]
    let hittableExpectation = expectation(for: NSPredicate(format: "hittable == 1"), evaluatedWith: shareButton, handler: nil)
    wait(for: [hittableExpectation], timeout: 5)
    shareButton.tap()
    
    let shareExtensionButton = application.collectionViews.collectionViews.buttons[name]
    if !shareExtensionButton.waitForExistence(timeout: 3) {
      // Check if our Share Extension is available and enable it when needed.
      let moreButton = application.collectionViews.collectionViews.buttons["More"]
      application.collectionViews.collectionViews.element(boundBy: 1).scrollToElement(element: moreButton, in: application)
      XCTAssert(moreButton.waitForExistence(timeout: 10), "More button not found")
      moreButton.tap()
      
      // Find the share extension switch.
      let shareExtensionSwitch = application.tables.switches[name].firstMatch
      application.tables.element(boundBy: 0).scrollToElement(element: shareExtensionSwitch, in: application)
      XCTAssert(shareExtensionSwitch.waitForExistence(timeout: 10), "Share Extension Switch not found")
      
      // Only tap the extension switch if it's off.
      if shareExtensionSwitch.value as? String != "1" {
        shareExtensionSwitch.tap()
      }
      
      // Close the switches view.
      let activityDoneButton = application.navigationBars["Activities"].buttons["Done"].firstMatch
      XCTAssert(activityDoneButton.waitForExistence(timeout: 10), "Done button not found")
      activityDoneButton.tap()
    }
    
    // Open the share extension.
    application.collectionViews.collectionViews.element(boundBy: 1).scrollToElement(element: shareExtensionButton, in: application, direction: .reverse)
    XCTAssert(shareExtensionButton.waitForExistence(timeout: 10), "Share extension button not found")
    shareExtensionButton.tap()
  }
}

private extension XCUIElement {
  enum HorizontalScrollDirection {
    case reverse
    case forward
    
    var offset: CGVector {
      switch self {
      case .reverse:
        return CGVector(dx: 100, dy: 100)
      case .forward:
        return CGVector(dx: -100, dy: -100)
      }
    }
  }
  
  /// Scrolls the given application in the given direction until the given element is visible.
  /// Pass any other elements which shouldn't intersect. This can be useful if you have floating buttons which could exist on top of the element we're looking for. If the element would intersect, tapping it would instead tap the overlaying button.
  ///
  /// - Parameters:
  ///   - element: The element we're looking for.
  ///   - application: The application in which we're searching.
  ///   - direction: The direction to scroll to. Defaults to `forward`.
  ///   - notIntersectingElements: Any elements which the element we're looking for should not intersect with.
  func scrollToElement(element: XCUIElement, in application: XCUIApplication = XCUIApplication(), direction: HorizontalScrollDirection = .forward, notIntersecting notIntersectingElements: XCUIElement...) {
    let notIntersectingFrames = notIntersectingElements.filter { $0.visible() && !$0.frame.isEmpty }.map { $0.frame }
    
    while !element.visible(in: application) || notIntersectingFrames.first(where: { element.frame.intersects($0) }) != nil {
      // We don't use swipeUp to swipe in smaller portions.
      let start = coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
      let finish = start.withOffset(direction.offset)
      start.press(forDuration: 0.0, thenDragTo: finish)
    }
  }
  
  /// Determines whether the element is visible in the bounds of the given application.
  /// - Returns: `true` if visible, otherwise `false`.
  func visible(in application: XCUIApplication = XCUIApplication()) -> Bool {
    guard exists && !frame.isEmpty else { return false }
    return application.windows.element(boundBy: 0).frame.contains(frame) && isHittable
  }
}
