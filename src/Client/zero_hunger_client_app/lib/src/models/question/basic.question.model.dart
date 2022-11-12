import 'package:flutter/foundation.dart';

class BasicQuestionModel {
  final String id;
  final String question;
  final bool isAnswered;
  final String answerText;
  final bool isActive;

  BasicQuestionModel(
      {required this.id,
      required this.question,
      required this.isAnswered,
      required this.answerText,
      required this.isActive});

  factory BasicQuestionModel.fromJson(Map<String, dynamic> json) {
    return BasicQuestionModel(
      id: json['id'],
      question: json['question'],
      isAnswered: json['isAnswered'],
      answerText: json['answerText'],
      isActive: json['isActive'],
    );
  }
}
