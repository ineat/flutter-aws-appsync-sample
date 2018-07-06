//  This file was automatically generated and should not be edited.

import AWSAppSync

public final class GetMessagesQuery: GraphQLQuery {
  public static let operationString =
    "query GetMessages {\n  getMessages {\n    __typename\n    id\n    content\n    sender\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("getMessages", type: .list(.object(GetMessage.selections))),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(getMessages: [GetMessage?]? = nil) {
      self.init(snapshot: ["__typename": "Query", "getMessages": getMessages.flatMap { $0.map { $0.flatMap { $0.snapshot } } }])
    }

    public var getMessages: [GetMessage?]? {
      get {
        return (snapshot["getMessages"] as? [Snapshot?]).flatMap { $0.map { $0.flatMap { GetMessage(snapshot: $0) } } }
      }
      set {
        snapshot.updateValue(newValue.flatMap { $0.map { $0.flatMap { $0.snapshot } } }, forKey: "getMessages")
      }
    }

    public struct GetMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "sender": sender])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }
    }
  }
}

public final class NewMessageMutation: GraphQLMutation {
  public static let operationString =
    "mutation NewMessage($content: String!, $sender: String!) {\n  newMessage(content: $content, sender: $sender) {\n    __typename\n    id\n    content\n    sender\n  }\n}"

  public var content: String
  public var sender: String

  public init(content: String, sender: String) {
    self.content = content
    self.sender = sender
  }

  public var variables: GraphQLMap? {
    return ["content": content, "sender": sender]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("newMessage", arguments: ["content": GraphQLVariable("content"), "sender": GraphQLVariable("sender")], type: .object(NewMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(newMessage: NewMessage? = nil) {
      self.init(snapshot: ["__typename": "Mutation", "newMessage": newMessage.flatMap { $0.snapshot }])
    }

    public var newMessage: NewMessage? {
      get {
        return (snapshot["newMessage"] as? Snapshot).flatMap { NewMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "newMessage")
      }
    }

    public struct NewMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "sender": sender])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }
    }
  }
}

public final class SubscribeToNewMessageSubscription: GraphQLSubscription {
  public static let operationString =
    "subscription SubscribeToNewMessage {\n  subscribeToNewMessage {\n    __typename\n    id\n    content\n    sender\n  }\n}"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Subscription"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("subscribeToNewMessage", type: .object(SubscribeToNewMessage.selections)),
    ]

    public var snapshot: Snapshot

    public init(snapshot: Snapshot) {
      self.snapshot = snapshot
    }

    public init(subscribeToNewMessage: SubscribeToNewMessage? = nil) {
      self.init(snapshot: ["__typename": "Subscription", "subscribeToNewMessage": subscribeToNewMessage.flatMap { $0.snapshot }])
    }

    public var subscribeToNewMessage: SubscribeToNewMessage? {
      get {
        return (snapshot["subscribeToNewMessage"] as? Snapshot).flatMap { SubscribeToNewMessage(snapshot: $0) }
      }
      set {
        snapshot.updateValue(newValue?.snapshot, forKey: "subscribeToNewMessage")
      }
    }

    public struct SubscribeToNewMessage: GraphQLSelectionSet {
      public static let possibleTypes = ["Message"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
        GraphQLField("content", type: .nonNull(.scalar(String.self))),
        GraphQLField("sender", type: .nonNull(.scalar(String.self))),
      ]

      public var snapshot: Snapshot

      public init(snapshot: Snapshot) {
        self.snapshot = snapshot
      }

      public init(id: GraphQLID, content: String, sender: String) {
        self.init(snapshot: ["__typename": "Message", "id": id, "content": content, "sender": sender])
      }

      public var __typename: String {
        get {
          return snapshot["__typename"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: GraphQLID {
        get {
          return snapshot["id"]! as! GraphQLID
        }
        set {
          snapshot.updateValue(newValue, forKey: "id")
        }
      }

      public var content: String {
        get {
          return snapshot["content"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "content")
        }
      }

      public var sender: String {
        get {
          return snapshot["sender"]! as! String
        }
        set {
          snapshot.updateValue(newValue, forKey: "sender")
        }
      }
    }
  }
}