# Flutter AppSync Demo

Create custom bridge for AWS AppSync

## Presentation

This project is an example of using Flutter with the AWS AppSync solution. It is configured in state UE CENTRAL 1 (Francfort)

[![Demo](https://github.com/ineat/flutter-aws-appsync-sample/blob/master/media/demo.gif)](https://github.com/ineat/flutter-aws-appsync-sample/blob/master/media/demo.mp4)

### My AppSync Configuration

**Lambda called by AppSync :** 
```javascript

var incrementId = 0;
var messages = [];

exports.handler = async (event, context, callback) => {
    switch (event.field) {
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

**Schema GraphQL in App Sync :** 

```graphql
type Message {
	id: ID!
	content: String!
	sender: String!
	conversationId: Int!
}

type Mutation {
	newMessage(content: String!, sender: String!, conversationId: Int!): Message
}

type Query {
	getMessages: [Message]
}

type Subscription {
	subscribeToNewMessage(conversationId: Int!): Message
		@aws_subscribe(mutations: ["newMessage"])
}

schema {
	query: Query
	mutation: Mutation
}
```

Settings Authorization type is : **API key**

Add **resolver** into query, mutation. The data source name  is linked with the previously lambda.

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

Add AppSync API URL, and API Key in the file /lib/constants.dart

# Custom Configuration in your project

## 1. Android

Step 1: add aws android SDK classpath


```groovy
// android/build.gradle
buildscript {

    dependencies {
        classpath 'com.amazonaws:aws-android-sdk-appsync-gradle-plugin:2.6.17'
    }

}

```

Step 2: Plugin plugin and SDK

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

Step 3: add schema and request GraphQL

Copy your files in :

/android/app/src/main/graphql/your.package.name/*.graphql
/android/app/src/main/graphql/your.package.name/*.json


Step 4: Configure Android Manifest
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
Step 5: Generation GraphQL models

Launch gradle command : 

```shell
# /android
./gradle generateApolloClasses
```

## 2. iOS

Step 1: add AWS SDK in your Podfile

```ruby
target 'Runner' do
  use_frameworks!
  pod 'AWSAppSync', '~> 2.6.7'
end
```

Step 2: Retrieve all dependencies
```ruby
pod install
```

Caution: Configure your deployment target at 9.0 (Runner.xcworkspace)

Step 3: add schema and request GraphQL

Copy your files in :

/iOS/*.graphql
/iOS/schema.json


For generate models you have to use the npm library aws-appsync-codegen (https://www.npmjs.com/package/aws-appsync-codegen)

Launch the command :

```shell
# ios/
aws-appsync-codegen generate *.graphql --schema schema.json --output ./Runner/AppSyncAPI.swift
```

