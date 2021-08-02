import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Input extends StatefulWidget {
  final TextEditingController controller;
  final String errorText;
  final bool error;
  final String hint;
  final bool obscure;

  const Input(
      {Key? key,
      required this.controller,
      required this.error,
      required this.errorText,
      this.obscure: false,
      required this.hint})
      : super(key: key);

  @override
  _InputState createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          obscureText: widget.obscure,
          controller: widget.controller,
          decoration: InputDecoration(
              errorText: widget.error ? widget.errorText : null,
              hintText: widget.hint),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
