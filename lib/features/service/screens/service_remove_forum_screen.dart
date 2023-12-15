import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class ServiceRemoveForumScreen extends ConsumerWidget {
  final String _serviceId;
  const ServiceRemoveForumScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Remove Forum',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
    );
  }
}
