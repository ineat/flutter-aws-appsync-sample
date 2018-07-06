# Flutter AppSync Demo

Create custom bridge for AWS AppSync

## Presentation

This project is an example of using Flutter with the AWS AppSync solution. It is configured in state UE CENTRAL 1 (Francfort)

[![Demo](https://github.com/ineat/flutter-aws-appsync-sample/blob/master/media/demo.gif)](https://github.com/ineat/flutter-aws-appsync-sample/blob/master/media/demo.mp4)

AWS AppSync automatically updates web and mobile application data in real time, and offline user data is updated as soon as it is reconnected.
If you use AppSync as a simple GraphQL API without the subscribe feature then it would be better to use the following plugin: : 
https://pub.dartlang.org/packages/graphql_flutter


The bridge is based on the official documentation of the AppSync SDK.

**AWS AppSync SDK Android :** 
https://docs.aws.amazon.com/appsync/latest/devguide/building-a-client-app-android.html

**AWS AppSync SDK iOS :** 
https://docs.aws.amazon.com/appsync/latest/devguide/building-a-client-app-ios.html

If you want more information on the development of a flutter plugin here is an official link: https://flutter.io/developing-packages/

To make this example work, AppSync is configured with the following GraphQL schema : 


## GraphQL schema

The GraphQL schema: 

```graphql
type Message {
	id: ID!
	content: String!
	sender: String!
}

type Mutation {
	newMessage(content: String!, sender: String!): Message
}

type Query {
	getMessages: [Message]
}

type Subscription {
	subscribeToNewMessage: Message
		@aws_subscribe(mutations: ["newMessage"])
}

schema {
	query: Query
	mutation: Mutation
	subscription: Subscription
}
```

To create your GraphQL schema for AppSync, see the link https://docs.aws.amazon.com/appsync/latest/devguide/graphql-overview.html 

## Security

AppSync will be secured by API Key.

https://docs.aws.amazon.com/appsync/latest/devguide/security.html

## Data Source

The Data Source used by AppSync is a lambda. Here is this example here is a simplified version :

```javascript

var incrementId = 0;
var messages = [];

exports.handler = async (event, context, callback) => {
    switch (event.field) {
        // match with Data Template resolver
        case 'getMessages':
            getMessages(event, context, callback);
            break;
        case 'newMessage':
            newMessage(event, context, callback);
            break;
        default: throw new Error("unsupported");
    }
};

function getMessages(event, context, callback) {
    callback(null, messages);
}

async function newMessage(event, context, callback) {
    const args = event.arguments;
    const msg = {
        id: (++incrementId).toString(),
        content: args.content,
        sender: args.sender,
        conversationId: args.conversationId
    };
    messages.push(msg);
    
    callback(null, msg);
}
```

To link the GraphQL schema methods to the lambda refer to the following link : https://docs.aws.amazon.com/appsync/latest/devguide/tutorial-lambda-resolvers.html

## Resolvers

Request template resolver for NewMessage Mutation :

```javascript
{
    "version" : "2017-02-28",
    "operation": "Invoke",
    "payload": {
    	"field" : "newMessage",
        "arguments": $util.toJson($context.args)
    }
}
```

Request template resolver for GetMessages Query :

```javascript
{
    "version" : "2017-02-28",
    "operation": "Invoke",
    "payload": {
    	"field" : "getMessages",
        "arguments": $util.toJson($context.args)
    }
}
```

## Configuration sample

To configure AppSync in the project, modify the constants of the file /lib/constants.dart

```dart
const AWS_APP_SYNC_ENDPOINT = "YOUR ENDPOINT"; // like https://xxx.appsync-api.eu-central-1.amazonaws.com/graphql
const AWS_APP_SYNC_KEY = "YOUR API KEY";
```

# Custom Configuration in your project

## 1. Android

**_Step 1:_** add aws android SDK classpath


```groovy
// android/build.gradle
buildscript {

    dependencies {
        classpath 'com.amazonaws:aws-android-sdk-appsync-gradle-plugin:2.6.17'
    }

}

```

_**Step 2:**_ Plugin plugin and SDK

```groovy
// android/app/build.gradle

apply plugin: 'com.amazonaws.appsync'

dependencies {
    implementation 'com.amazonaws:aws-android-sdk-appsync:2.6.17'
    implementation 'org.eclipse.paho:org.eclipse.paho.client.mqttv3:1.2.0'
    implementation 'org.eclipse.paho:org.eclipse.paho.android.service:1.1.1'
    implementation 'com.android.support:support-v4:27.1.1'
}
```

_**Step 3:**_ add schema and request GraphQL

Copy your files in :

/android/app/src/main/graphql/your.package.name/*.graphql
/android/app/src/main/graphql/your.package.name/*.json


_**Step 4:**_ Configure Android Manifest

```xml

<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.ineat.appsync">


    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.WAKE_LOCK" />
    
    <application>
        <!-- ... -->
        <!-- Service paho for retrieve all data in background -->
        <service android:name="org.eclipse.paho.android.service.MqttService" />
    </application>
    
</manifest>
```

_**Step 5:**_ Generation GraphQL models

Launch gradle command : 

```shell
# /android
./gradle generateApolloClasses
```

## 2. iOS

_**Step 1:**_ add AWS SDK in your Podfile

```ruby
target 'Runner' do
  use_frameworks!
  pod 'AWSAppSync', '~> 2.6.7'
end
```

_**Step 2:**_ Retrieve all dependencies

```ruby
pod install
```

_Caution:_ Configure your deployment target at 9.0 (Runner.xcworkspace)

_**Step 3:**_ add schema and request GraphQL

Copy your files in :

/iOS/*.graphql
/iOS/schema.json


For generate models you have to use the npm library aws-appsync-codegen (https://www.npmjs.com/package/aws-appsync-codegen)

Launch the command :

```shell
# ios/
aws-appsync-codegen generate *.graphql --schema schema.json --output ./Runner/AppSyncAPI.swift
```

