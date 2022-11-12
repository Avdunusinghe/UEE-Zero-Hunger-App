import 'package:flutter/material.dart';

class AuthenticationForm extends StatefulWidget {
  AuthenticationForm({Key? key, required this.login, required this.register})
      : super(key: key);

  final Function login;
  final Function register;
  final userNameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<AuthenticationForm> createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 80, bottom: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your Email';
                }
                if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Please enter Valid Email. : example(example.@gmail.com)';
                }
                return null;
              },
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person_outline_outlined),
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
              controller: widget.userNameController,
            ),
            const SizedBox(height: 16),
            TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Your Password';
                }

                return null;
              },
              obscureText: true,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.fingerprint),
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              controller: widget.passwordController,
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  widget.register();
                },
                child: const Text("Register"),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.login(widget.userNameController.text,
                          widget.passwordController.text);
                    }
                  },
                  child: Text('Login')),
            )
          ],
        ),
      ),
    );
  }
}
