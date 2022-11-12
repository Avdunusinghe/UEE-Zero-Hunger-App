import 'package:flutter/material.dart';

class SaveQuestionForm extends StatefulWidget {
  SaveQuestionForm({Key? key, required this.saveQuestion}) : super(key: key);
  final Function saveQuestion;
  final questionController = TextEditingController();

  @override
  State<SaveQuestionForm> createState() => _SaveQuestionFormState();
}

class _SaveQuestionFormState extends State<SaveQuestionForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
              maxLines: 15,
              autofocus: true,
              controller: widget.questionController,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.saveQuestion(widget.questionController.text);
                    }
                  },
                  child: const Text("Post Question")),
            )
          ],
        ),
      ),
    );
  }
}
