import 'dart:convert';

class NotificationModel {
  bool status;
  List<Notification> notifications;

  NotificationModel({
    required this.status,
    required this.notifications,
  });

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        status: json["status"],
        notifications: List<Notification>.from(
            json["notifications"].map((x) => Notification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "notifications":
            List<dynamic>.from(notifications.map((x) => x.toJson())),
      };
}

class Notification {
  String the0;
  String the1;
  String the2;
  String the3;
  String the4;
  String id;
  String title;
  String body;
  String link;
  String image;

  Notification({
    required this.the0,
    required this.the1,
    required this.the2,
    required this.the3,
    required this.the4,
    required this.id,
    required this.title,
    required this.body,
    required this.link,
    required this.image,
  });

  factory Notification.fromRawJson(String str) =>
      Notification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        the0: json["0"],
        the1: json["1"],
        the2: json["2"],
        the3: json["3"],
        the4: json["4"],
        id: json["id"],
        title: json["title"],
        body: json["body"],
        link: json["link"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "0": the0,
        "1": the1,
        "2": the2,
        "3": the3,
        "4": the4,
        "id": id,
        "title": title,
        "body": body,
        "link": link,
        "image": image,
      };
}
