import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key}) : super(key: key);

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {

    final formKey = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(title: const Text("DEBUG PAGE")),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (formKey.currentState!.validate()) {
                      print(formKey.currentState!.context.toString());
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ChangedText extends StatefulWidget {
  const ChangedText(key) : super(key: key);

  @override
  State<ChangedText> createState() => _ChangedTextState();
}

class _ChangedTextState extends State<ChangedText> {
  var text = "";

  @override
  Widget build(BuildContext context) {
    return Text("Text from field $text");
  }
}
