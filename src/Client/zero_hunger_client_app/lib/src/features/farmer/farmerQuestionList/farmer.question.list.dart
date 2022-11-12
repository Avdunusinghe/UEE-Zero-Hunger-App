import 'package:flutter/material.dart';
import 'package:zero_hunger_client_app/src/models/question/basic.question.model.dart';

class FarmerQuestionList extends StatelessWidget {
  final List<BasicQuestionModel> questionList;
  final Function deleteQuestion;
  final Function viewAnswer;
  final Function updateQuestion;
  FarmerQuestionList(this.questionList, this.viewAnswer, this.updateQuestion,
      this.deleteQuestion);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: questionList.map((question) {
        return Card(
            margin: EdgeInsets.all(20),
            semanticContainer: true,
            elevation: 6.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text(question.question),
                  trailing: Icon(
                    Icons.question_mark_outlined,
                    color: Colors.red,
                    size: 50.0,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  alignment: Alignment.centerLeft,
                  child:
                      Text(question.isAnswered ? "Answered" : "Not Answered"),
                ),
                ButtonBar(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 33, 20, 179)),
                      child: Text(
                          question.isAnswered ? "View Answer" : "Not Answered"),
                      onPressed: () {
                        this.viewAnswer(question);
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(255, 54, 244, 63)),
                      child: const Text('Update'),
                      onPressed: () {
                        this.updateQuestion(question);
                      },
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                      child: const Text('Delete'),
                      onPressed: () {
                        this.deleteQuestion(question.id);
                      },
                    )
                  ],
                )
              ],
            ));
      }).toList(),
    );
  }
}
