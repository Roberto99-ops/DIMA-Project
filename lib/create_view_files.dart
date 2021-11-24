import 'package:flutter/material.dart';

class CreateViewFiles extends StatelessWidget {
  final String name;

  final camera;

  const CreateViewFiles({Key? key, required this.name, this.camera}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text('A new view is created!'),
      ),
    );
  }
}