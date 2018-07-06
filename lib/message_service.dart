import 'dart:async';
import 'dart:convert';

import 'package:appsync/constants.dart';
import 'package:appsync/message.dart';
import 'package:flutter/services.dart';

class MessageService {

  static const CHANNEL_NAME = 'com.ineat.appsync';
  static const QUERY_GET_ALL_MESSAGES = 'getAllMessages';
  static const MUTATION_NEW_MESSAGE = 'newMessage';
  static const SUBSCRIBE_NEW_MESSAGE = 'subscribeNewMessage';
  static const SUBSCRIBE_NEW_MESSAGE_RESULT = 'subscribeNewMessageResult';

  static const Map<String, dynamic> _DEFAULT_PARAMS = <String, dynamic> {
    'endpoint': AWS_APP_SYNC_ENDPOINT,
    'apiKey': AWS_APP_SYNC_KEY
  };

  static const MethodChannel APP_SYNC_CHANNEL = const MethodChannel(CHANNEL_NAME);

  MessageService() {
    APP_SYNC_CHANNEL.setMethodCallHandler(_handleMethod);
  }

  final StreamController<Message> messageBroadcast = new StreamController<Message>.broadcast();
  
  Future<List<Message>> getAllMessages() async {
    String jsonString = await APP_SYNC_CHANNEL.invokeMethod(QUERY_GET_ALL_MESSAGES, _buildParams());
    List<dynamic> values = json.decode(jsonString);
    return values.map((value) => Message.fromJson(value)).toList();
  }

  Future<Message> sendMessage(String content, String sender) async {
    final params = {
      "content": content,
      "sender": sender
    };
    String jsonString = await APP_SYNC_CHANNEL.invokeMethod(MUTATION_NEW_MESSAGE, _buildParams(otherParams: params));
    Map<String, dynamic> values = json.decode(jsonString);
    return Message.fromJson(values);
  }

  void subscribeNewMessage() {
    APP_SYNC_CHANNEL.invokeMethod(SUBSCRIBE_NEW_MESSAGE, _buildParams());
  }

  Future<Null> _handleMethod(MethodCall call) async {
    if (call.method == SUBSCRIBE_NEW_MESSAGE_RESULT) {
      String jsonString = call.arguments;
      try {
        Map<String, dynamic> values = json.decode(jsonString);
        Message message = Message.fromJson(values);
        messageBroadcast.add(message);
      } catch(e) {
        print(e);
      }
    }
    return null;
  }

  Map<String, dynamic> _buildParams({Map<String, dynamic> otherParams}) {
    final params = new Map<String, dynamic>.from(_DEFAULT_PARAMS);
    if (otherParams != null) {
      params.addAll(otherParams);
    }
    return params;
  }
  
}