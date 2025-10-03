import 'package:flutter/material.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final bool showBackButton;
  final List<Widget> children;

  const BaseScreen({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 16.0,
            children: children,
          ),
        ),
      ),
    );
  }
}
