import 'package:flutter/material.dart';

class MockMapScreen extends StatelessWidget {
  const MockMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[300],
      child: const Center(
        child: Text('Mock Map'),
      ),
    );
  }
}
