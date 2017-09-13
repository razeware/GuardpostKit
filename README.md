# GuardpostKit

An iOS framework for integrating with Guardpost.

Requires iOS 11 or greater.

## How to use

1. Get GuardpostKit into your project.
2. You might have to do some fiddling with Swift import paths to get CommonCrypto to work. If you do, then I'm sure there's sites on the web that'll explain it. For some reason it wasn't necessary in the Demo app.
3. Import the module:

  ```swift
  import GuardpostKit
 ```

4. Create a guardpost object, supplying the endpoint, SSO secret and URL scheme for the current app:

  ```swift
  let guardpost = Guardpost(baseUrl: "https://guardpost.rwdev.io",
                          urlScheme: "com.razeware.guardpost-demo://",
                          ssoSecret: "<SSO_SECRET>")
 ```

5. Ensure that your app is registered for the specified URL scheme:

  ```xml
  <key>CFBundleURLTypes</key>
  <array>
    <dict>
      <key>CFBundleURLName</key>
      <string>com.razeware.guardpost-demo</string>
      <key>CFBundleURLSchemes</key>
      <array>
        <string>com.razeware.guardpost-demo</string>
      </array>
    </dict>
  </array>
 ```
 
 6. Use the `currentUser` property to determine whether a user is currently logged in. Their profile is stored in the keychain, so persists between restarts, and backups.
 7. Use the `login()` method to initiate a login, providing a closure to handle the result of the login.
 8. Use the `logout()` method to remove the user from the keychain.
 
 ## Demo App
 
 The demo app shows GuardpostKit in action.
 
 ## Testing
 
 There are a few tests written. There should probably be some more.
 
 ## Requirements
 
 This framework requires a minimum of iOS 11.
