import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool loading;
  const CustomButton({super.key, required this.text, this.onPressed, this.loading=false});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: loading ? null : onPressed,
      child: loading ? const SizedBox(height:20,width:20,child:CircularProgressIndicator(strokeWidth:2))
                     : Text(text),
    );
  }
}
