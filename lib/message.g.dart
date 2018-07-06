// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => new Message(
    id: json['id'] as String,
    content: json['content'] as String,
    sender: json['sender'] as String);

abstract class _$MessageSerializerMixin {
  String get id;
  String get content;
  String get sender;
  Map<String, dynamic> toJson() =>
      <String, dynamic>{'id': id, 'content': content, 'sender': sender};
}
