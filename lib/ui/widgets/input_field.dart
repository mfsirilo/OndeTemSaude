import 'package:flutter/material.dart';

class InputField extends StatelessWidget {

  final Icon icon;
  final String hint;
  final String label;
  final String initialValue;
  final bool obscure;
  final Stream<String> stream;
  final Function(String) onChanged;
  final FocusNode onCompleteFocus;

  InputField({
    this.icon,
    this.hint,
    this.obscure,
    this.stream,
    this.onChanged,
    this.onCompleteFocus,
    this.label,
    this.initialValue
  });

  @override
  Widget build(BuildContext context) {
    final _textController = TextEditingController();

    _textController.text = initialValue;

    return StreamBuilder<String>(
        stream: stream,
        builder: (context, snapshot) {
          return TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              icon: icon,
              labelText: label,
              errorText: snapshot.hasError ? snapshot.error : null,
            ),
            onEditingComplete: (){
              FocusScope.of(context).requestFocus(onCompleteFocus);
            },
          );
        }
    );
  }
}
