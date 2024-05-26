import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

final GlobalKey _scaffold = GlobalKey();

class RemoveConsumerScreen extends ConsumerWidget {
  final String _policyId;
  const RemoveConsumerScreen({super.key, required String policyId})
      : _policyId = policyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Text(
          'Remove Consumer',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
    );
  }
}
