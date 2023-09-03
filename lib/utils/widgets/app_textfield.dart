import 'package:flutter/material.dart';

class AppTextField extends StatefulWidget {
  final String title;
  final Function(dynamic) onChanged;
  final Function() onEditingComplete;
  final FocusNode focusNode;
  final String hintText;
  final TextInputType keyboardType;

  const AppTextField({
    Key? key,
    required this.title,
    required this.onChanged,
    required this.onEditingComplete,
    required this.focusNode,
    required this.hintText,
    required this.keyboardType,
  }) : super(key: key);

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16),
            child: Text(
              widget.title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
                color: Colors.grey[200],
              ),
              child: TextFormField(
                keyboardType: widget.keyboardType,
                onChanged: widget.onChanged,
                onEditingComplete: widget.onEditingComplete,
                focusNode: widget.focusNode,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
