import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();
  String? _city;
  AutovalidateMode autovalidMode = AutovalidateMode.disabled;

  void _submit() {
    setState(() {
      autovalidMode = AutovalidateMode.always;
    });
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      Navigator.pop(context, _city!.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: autovalidMode,
        child: Column(
          children: [
            Gap(60),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
              ),
              child: TextFormField(
                autofocus: true,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  labelText: 'City name',
                  hintText: 'more than 2 characters',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                validator: (String? input) {
                  if (input == null || input.trim().length < 2) {
                    return 'City name must have at least 2 characters long';
                  }
                  return null;
                },
                onSaved: (String? input) {
                  _city = input;
                },
              ),
            ),
            Gap(20),
            ElevatedButton(
              onPressed: _submit,
              child: const Text(
                'How\'s the weather?',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
