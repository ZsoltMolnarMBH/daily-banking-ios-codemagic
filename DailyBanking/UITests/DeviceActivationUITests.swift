//
//  DailyBanking_UITests.swift
//  app-daily-banking-iosUITests
//
//  Created by Zsombor Szabó on 2021. 08. 16..
//

import XCTest

class DeviceActivationUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testDeviceActivation() throws {
        let app = XCUIApplication()
        
        let startDeviceActivationButton = app.buttons[Strings.Localizable.startDeviceActivation]
        _ = startDeviceActivationButton.waitForExistence(timeout: 10)
        startDeviceActivationButton.tap()
        
        let phoneNumberTextField = app.textFields.element(boundBy: 0)
        _ = phoneNumberTextField.waitForExistence(timeout: 10)
        phoneNumberTextField.tap()
        app.typeText("550000000")
        
        let passwordSecureTextField = app.secureTextFields.element(boundBy: 0)
        _ = passwordSecureTextField.waitForExistence(timeout: 10)
        passwordSecureTextField.tap()
        app.typeText("Aa123456")
        app.keyboards.buttons["Done"].tap()
        

        
        let otpTextField = app.textFields.element(boundBy: 0)
        _ = otpTextField.waitForExistence(timeout: 10)
        otpTextField.tap()
        app.typeText("154397")
        
        
        let commonNextButton = app.buttons[Strings.Localizable.commonNext]
        _ = commonNextButton.waitForExistence(timeout: 10)
        commonNextButton.tap()
        
        let pinInfoCreateButton = app.buttons[Strings.Localizable.pinInfoCreate]
        _ = pinInfoCreateButton.waitForExistence(timeout: 10)
        pinInfoCreateButton.tap()
        
        let numberButton = app.buttons["9"]
        _ = numberButton.waitForExistence(timeout: 10)
        numberButton.tap()
        app.buttons["0"].tap()
        app.buttons["1"].tap()
        app.buttons["3"].tap()
        app.buttons["7"].tap()
        app.buttons["1"].tap()
        
        _ = numberButton.waitForExistence(timeout: 10)
        numberButton.tap()
        app.buttons["0"].tap()
        app.buttons["1"].tap()
        app.buttons["3"].tap()
        app.buttons["7"].tap()
        app.buttons["1"].tap()
        
        let commonSkipButton = app.buttons[Strings.Localizable.commonSkip]
        _ = commonSkipButton.waitForExistence(timeout: 10)
        commonSkipButton.tap()
        
        _ = app.tabBars.element.waitForExistence(timeout: 10)
    }
}
