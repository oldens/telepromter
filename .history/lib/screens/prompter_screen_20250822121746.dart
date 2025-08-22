import 'package:flutter/material.dart';

class PrompterScreen extends StatelessWidget {
  final String scriptText;
  
  const PrompterScreen({
    super.key,
    required this.scriptText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Суфлер'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Text(
            scriptText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              height: 1.6,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
