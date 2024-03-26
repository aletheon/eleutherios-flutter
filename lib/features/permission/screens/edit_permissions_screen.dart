import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditPermissionsScreen extends ConsumerWidget {
  final String _forumId;
  final String _registrantId;
  const EditPermissionsScreen(
      {super.key, required String forumId, required String registrantId})
      : _forumId = forumId,
        _registrantId = registrantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Permissions',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Wrap(children: [
          Text('forumId - $_forumId'),
          Text('registrantId - $_registrantId')
        ]),
      ),
    );
  }
}
