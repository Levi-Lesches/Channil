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
    timestamp = Timestamp.fromMillisecondsSinceEpoch(json["milliseconds"]).toDate();

  Json toJson() => {
    "content": content,
    "timestamp": Timestamp.fromDate(timestamp),
  };
}

class Connection {
  final UserID from;
  final UserID to;
  final ConnectionStatus status;
  final List<Message> messages;
  const Connection({
    required this.from,
    required this.to,
    required this.status,
    required this.messages,
  });

  Connection.start({
    required this.from,
    required this.to,
  }) : 
    status = ConnectionStatus.pending,
    messages = [];

  Connection.fromJson(Json json) : 
    from = json["from"],
    to = json["to"],
    status = ConnectionStatus.values.byName(json["status"]),
    messages = [
      for (final messageJson in json["messages"])
        Message.fromJson(messageJson),
    ];

  Json toJson() => {
    "from": from,
    "to": to,
    "status": status.name,
    "messages": [
      for (final message in messages)
        message.toJson(),
    ],
  };
}
