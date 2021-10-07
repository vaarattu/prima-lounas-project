import 'package:flutter/material.dart';

class ErrorDisplayWidget extends StatelessWidget {
  const ErrorDisplayWidget({
    Key? key,
    required this.errorText,
    required this.callback,
  }) : super(key: key);

  final String errorText;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "Tapahtui virhe: \n\n" + errorText,
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: callback,
          child: Text("Yritä uudelleen"),
        ),
      ],
    );
  }
}
