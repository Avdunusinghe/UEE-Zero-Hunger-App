import 'package:flutter/material.dart';
import 'package:zero_hunger_client_app/src/models/question/basic.question.model.dart';

class UpdateQuestionFormLayout extends StatefulWidget {
  UpdateQuestionFormLayout(
      {Key? key,
      required this.updateQuestion,
      required this.basicQuestionModel})
      : super(key: key);
  final Function updateQuestion;
  final BasicQuestionModel basicQuestionModel;
  final questionController = TextEditingController();

  @override
  State<UpdateQuestionFormLayout> createState() =>
      _UpdateQuestionFormLayoutState();
}

class _UpdateQuestionFormLayoutState extends State<UpdateQuestionFormLayout> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    widget.questionController.text = widget.basicQuestionModel.question;

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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.updateQuestion(widget.questionController.text,
                          widget.basicQuestionModel.id);
                    }
                  },
                  child: const Text("Update")),
            )
          ],
        ),
      ),
    );
  }
}
