import 'dart:convert';

NotesModel notesModelFromJson(String str) => NotesModel.fromJson(json.decode(str));

String notesModelToJson(NotesModel data) => json.encode(data.toJson());

class NotesModel {
  int? id;
  String? title;
  String? content;
  String? category;
  String? image;
  String? createdAt;

  NotesModel({
    this.id,
    this.title,
    this.content,
    this.category,
    this.image,
    this.createdAt,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) => NotesModel(
    id: json["id"],
    title: json["title"],
    content: json["content"],
    category: json["category"],
    image: json["image"],
    createdAt: json["created_At"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "content": content,
    "category": category,
    "image": image,
    "created_At": createdAt,
  };
}
