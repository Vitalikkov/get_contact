import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class GetButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GetButton({super.key, required this.onPressed});

  @override
  Widget build(
      BuildContext context) =>
      Container(
        child: Center(
          child:FilledButton(
            onPressed: onPressed,
            child: const Text('Get Contant'),
          ),

        ),
      );
}
