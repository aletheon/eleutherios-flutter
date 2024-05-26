import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

final GlobalKey _scaffold = GlobalKey();

class ServiceRemovePolicyScreen extends ConsumerWidget {
  final String _serviceId;
  const ServiceRemovePolicyScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text(
          'Remove Policy',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
    );
  }
}
