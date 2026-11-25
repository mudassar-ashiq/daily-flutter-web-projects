import 'package:flutter/material.dart';

import 'models.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _frontController = TextEditingController();
  final _backController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      Flashcard(
        front: _frontController.text.trim(),
        back: _backController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a card')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _frontController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Front — the question',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Write the question first'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _backController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Back — the answer',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Write the answer too'
                    : null,
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: _save, child: const Text('Save card')),
            ],
          ),
        ),
      ),
    );
  }
}
