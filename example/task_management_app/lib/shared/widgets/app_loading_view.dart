import 'package:flutter/material.dart';

final class AppLoadingView extends StatelessWidget {
  const AppLoadingView({this.label = 'Loading…', super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: label,
        liveRegion: true,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
