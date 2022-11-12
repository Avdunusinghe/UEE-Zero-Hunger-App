import 'package:flutter/material.dart';
import 'package:zero_hunger_client_app/src/models/question/basic.question.model.dart';

class viewAnswerFormLayout extends StatefulWidget {
  viewAnswerFormLayout({Key? key, required this.basicQuestionModel})
      : super(key: key);
  final BasicQuestionModel basicQuestionModel;
  final questionController = TextEditingController();
  final anwserController = TextEditingController();

  @override
  State<viewAnswerFormLayout> createState() => _viewAnswerFormLayoutState();
}

class _viewAnswerFormLayoutState extends State<viewAnswerFormLayout> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    widget.questionController.text = widget.basicQuestionModel.question;
    widget.anwserController.text = widget.basicQuestionModel.answerText;

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 30, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your question';
                }

                return null;
              },
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: "Question",
                hintText: "Enter your question",
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
              controller: widget.questionController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your question';
                }

                return null;
              },
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                labelText: "Answer",
                hintText: "Enter your question",
                border: OutlineInputBorder(),
              ),
              maxLines: 10,
              controller: widget.anwserController,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Back")),
            )
          ],
        ),
      ),
    );
  }
}
