# Slice iOS SDK

The [Slice API](https://developer.slice.com) provides developers access to a user's online purchase history. It works by processing email receipts, and spans across  merchants and product categories. Resources available include orders, items, shipments, and much more.

SliceSDK is a convenience framework for using the Slice API on iOS.

**Note:** The Slice API provides access for one user at a time, and the user must grant permission for you to access their data.


## Getting Started

Visit the Slice [developer portal](https://developer.slice.com) and create an account to get started. Create a new app and take note of your **Client ID** and **Client Secret**.

For the **Redirect URL**, enter the following:

```
com.slice.developer.<client_id>://auth
```

Here's an example of an app that is configured correctly:

![Alt text](/Documentation/DeveloperPortalConfiguration.png?raw=true)

## Installing

SliceSDK is available via Cocoapods. Add the following to your Podfile:

```
pod 'SliceSDK', :git => 'https://github.com/slicedev/slice-ios'
```

SliceSDK is written natively in Swift, so you will also need to add `use_frameworks!` to your Podfile.


## Integration

Take a look at the `SliceExampleApp` to see an integration in action.

### Initializing the SliceClient

The main point of entry is the `SliceClient` class. Initialize the client with your **Client ID** and **Client Secret** from your app on the Slice developer portal.

```swift
let clientID = "<client_id>"
let clientSecret = "<client_secret>"
let settings = SliceSettings(clientID: clientID, clientSecret: clientSecret)
let client = SliceClient(settings: settings)
```

By design SliceSDK does not provide singleton access. You'll want to keep a reference to the client and use it however you decide to design your application.

### Authenticating

First, in your application delegate, enter the following so the client can handle the authorization code redirect:

```swift
func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
    let handled = client.application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    return handled
}
```

Then to begin authorization, call the following on your client:

```swift
let application = UIApplication.sharedApplication()
client.authorize(application) { (accessToken, error) in
    // optionally use access token here
}
```

This will call out to Safari for the user to enter their Slice credentials. Safari then redirects back to the app with the authorization code.

`SliceClient` uses the authorization code to request an access token from the server, and stores it in the `Keychain`. The client manages the token for you, but if you choose you can get the access token as such: 

```swift
let accessToken = client.currentAccessToken
```

Finally, if you want to log out and clear the access token:

```swift
client.unauthenticate()
```

### Requesting Resources

Now for the fun part. To request Slice resources, simply call the following on your client:

```swift
client.resources("<resource_name>", parameters: nil) { (resources, error) in
    if let resources = resources as? JSONArray {
        // do something with the resources
    }
}
```

See the [resource documentation](http://devdocs.slice.com/resources) for all the available resources and their fields. For example, to request the user's orders, you would input `"orders"` for `"<resource_name>"` above.

There is an optional `parameters` input that let's you filter the results, also explained in the documentation.

The resources come back in a raw JSON format. We're working on returning more usable plain-old-Swift-objects in the near feature.

## Dependencies

[Alamofire](https://github.com/Alamofire/Alamofire)

[KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)

## Feedback

Feedback and contributions are welcome. Please file issues and don't hesitate to reach out with any questions.
