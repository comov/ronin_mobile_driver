import 'package:flutter/material.dart';

class Debug extends StatefulWidget {
  const Debug({Key? key}) : super(key: key);

  @override
  State<Debug> createState() => _DebugState();
}

class _DebugState extends State<Debug> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DEBUG PAGE")),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
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
              ChangedText(_formKey),
              Text("Text from field ${_formKey.currentState}"),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState!.validate()) {
                      print(_formKey.currentState!.context.toString());
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
