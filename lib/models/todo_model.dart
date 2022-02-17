import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel {
  final String docId;
  final String description;
  final String title;
  final String type;
  final DateTime datetime;
  final String author;
  final String project;
  final String status;
  TodoModel({
    required this.docId,
    required this.description,
    required this.title,
    required this.type,
    required this.datetime,
    required this.author,
    required this.project,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'title': title,
      'type': type,
      'datetime': Timestamp.fromDate(DateTime.now()),
      'author': author,
      'project': project,
      'status': status,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map, String docId) {
    return TodoModel(
      docId: docId,
      description: map['description'] ?? '',
      title: map['title'] ?? '',
      type: map['type'] ?? '',
      datetime: DateTime.now(),
      author: map['author'] ?? '',
      project: map['project'] ?? '',
      status: map['status'] ?? '',
    );
  }
}
