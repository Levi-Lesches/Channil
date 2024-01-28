import "package:cloud_firestore/cloud_firestore.dart";

import "package:channil/data.dart";

enum ConnectionStatus {
  pending, 
  accepted,
  rejected,
  blocked,
}

class Message {
  final String content;
  final DateTime timestamp;
  const Message({
    required this.content,
    required this.timestamp,
  });

  Message.fromJson(Json json) : 
    content = json["content"],
    timestamp = json["timestamp"].toDate();

  Json toJson() => {
    "content": content,
    "timestamp": Timestamp.fromDate(timestamp),
  };
}

class Connection {
  final UserID from;
  final String fromName;
  final String toName;
  final UserID to;
  final String fromImageUrl;
  final String toImageUrl;
  final List<Message> messages;
  
  ConnectionStatus status;
  Connection({
    required this.from,
    required this.fromName,
    required this.fromImageUrl,
    required this.to,
    required this.toName,
    required this.toImageUrl,
    required this.status,
    required this.messages,
  });

  Connection.start({
    required ChannilUser from,
    required ChannilUser to,
    required Message firstMessage,
  }) : 
    from = from.id,
    to = to.id,
    fromName = from.name,
    toName = to.name,
    fromImageUrl = from.matchProfileType(
      handleBusiness: (profile) => profile.logo.url, 
      handleAthlete: (profile) => profile.profilePics.first.url,
    ),
    toImageUrl = to.matchProfileType(
      handleBusiness: (profile) => profile.logo.url, 
      handleAthlete: (profile) => profile.profilePics.first.url,
    ),
    status = ConnectionStatus.pending,
    messages = [firstMessage];

  Connection.fromJson(Json json) : 
    from = json["from"],
    to = json["to"],
    fromName = json["fromName"],
    toName = json["toName"],
    fromImageUrl = json["fromImageUrl"],
    toImageUrl = json["toImageUrl"],
    status = ConnectionStatus.values.byName(json["status"]),
    messages = [
      for (final messageJson in json["messages"])
        Message.fromJson(messageJson),
    ];

  String get id => "$from--$to";

  Json toJson() => {
    "from": from,
    "to": to,
    "fromName": fromName,
    "toName": toName,
    "fromImageUrl": fromImageUrl,
    "toImageUrl": toImageUrl,
    "status": status.name,
    "between": [from, to],
    "messages": [
      for (final message in messages)
        message.toJson(),
    ],
  };
}
