import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditManagerPermissionsScreen extends ConsumerStatefulWidget {
  final String policyId;
  final String memberId;
  const EditManagerPermissionsScreen(
      {super.key, required this.policyId, required this.memberId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditManagerPermissionsScreenState();
}

class _EditManagerPermissionsScreenState
    extends ConsumerState<EditManagerPermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Manager Permissions',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
    );
  }
}
