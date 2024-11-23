import 'package:flutter/material.dart';

class InputTextWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final IconData? iconData;
  final String? assetReference;
  final String lableString;
  final bool isObscure;

  InputTextWidget({
    required this.textEditingController,
    this.iconData,
    this.assetReference,
    required this.lableString,
    required this.isObscure,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        labelText: lableString,
      ),
    );
  }
}
