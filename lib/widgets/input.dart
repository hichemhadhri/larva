import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
      this.obscure = false,
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
        TextFormField(
          onTap: () {
            showCupertinoModalPopup(
                context: context,
                builder: (context) {
                  return _buildBottomPicker(
                      CupertinoDatePicker(onDateTimeChanged: (time) {}));
                });
          },
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

  double _kPickerSheetHeight = 200.0;
  Widget _buildBottomPicker(Widget picker) {
    return Container(
      height: _kPickerSheetHeight,
      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: picker,
          ),
        ),
      ),
    );
  }
}
