/*
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import XCTest
@testable import GuardpostKit

class SingleSignOnUserTests: XCTestCase {
  
  override func tearDown() {
    // Ensure we don't have any leftover users in the keychain
    SingleSignOnUser.removeUserFromKeychain()
  }
  
  let userDictionary = [
    "external_id": "sample_external_id",
    "email": "email@example.com",
    "username": "sample_username",
    "avatar_url": "http://example.com/avatar.jpg",
    "name": "Sample Name",
    "token": "Samaple.Token"
  ]
  
  func testUserCorrectlyPopulatesWithDictionary() {
    guard let user = SingleSignOnUser(dictionary: userDictionary) else {
      XCTFail("User should be correctly populated")
      return
    }
    
    XCTAssertEqual(userDictionary["external_id"], user.externalId)
    XCTAssertEqual(userDictionary["email"], user.email)
    XCTAssertEqual(userDictionary["username"], user.username)
    XCTAssertEqual(userDictionary["avatar_url"], user.avatarUrl.absoluteString)
    XCTAssertEqual(userDictionary["name"], user.name)
    XCTAssertEqual(userDictionary["token"], user.token)
  }
  
  func testUserDictionaryHasRequiredFields() {
    var invalidDictionary = userDictionary
    invalidDictionary.removeValue(forKey: "external_id")
    let user = SingleSignOnUser(dictionary: invalidDictionary)
    
    XCTAssertNil(user)
  }
  
  func testAdditionalEntriesInTheDictionaryAreIgnored() {
    var overSpecifiedDictionary = userDictionary
    overSpecifiedDictionary["extra_field"] = "some-guff"
    let user = SingleSignOnUser(dictionary: overSpecifiedDictionary)
    
    XCTAssertNotNil(user)
  }
  
  func testAvatarURLMustBeAURL() {
    var invalidDictionary = userDictionary
    invalidDictionary["avatar_url"] = "not a url"
    let user = SingleSignOnUser(dictionary: invalidDictionary)
    
    XCTAssertNil(user)
  }
  
  func testPersistenceToKeychain() {
    guard let user = SingleSignOnUser(dictionary: userDictionary) else {
      return XCTFail()
    }
    
    XCTAssert(user.persistToKeychain())
    
    guard let restoredUser = SingleSignOnUser.restoreFromKeychain() else {
      return XCTFail("Unable to restore user from Keychain")
    }
    
    XCTAssertEqual(user, restoredUser)
  }
  
  func testRemovalOfUserFromKeychain() {
    XCTAssertNil(SingleSignOnUser.restoreFromKeychain())
    
    guard let user = SingleSignOnUser(dictionary: userDictionary) else {
      return XCTFail()
    }
    
    XCTAssert(user.persistToKeychain())
    XCTAssertNotNil(SingleSignOnUser.restoreFromKeychain())
    
    XCTAssert(SingleSignOnUser.removeUserFromKeychain())
    
    XCTAssertNil(SingleSignOnUser.restoreFromKeychain())
  }
}
