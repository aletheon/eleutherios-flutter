import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

final GlobalKey _scaffold = GlobalKey();

class RemoveForumScreen extends ConsumerWidget {
  final String _forumId;
  const RemoveForumScreen({super.key, required String forumId})
      : _forumId = forumId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      key: _scaffold,
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
