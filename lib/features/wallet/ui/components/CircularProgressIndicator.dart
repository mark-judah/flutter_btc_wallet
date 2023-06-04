import 'package:flutter/material.dart';

void main() => runApp(const CircularProgressComponent());

class CircularProgressComponent extends StatelessWidget {
  const CircularProgressComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.yellow,
        ),
      ),
    );
  }
}
