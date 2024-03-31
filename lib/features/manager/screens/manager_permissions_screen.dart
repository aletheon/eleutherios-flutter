import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class ManagerPermissionsScreen extends ConsumerStatefulWidget {
  final String policyId;
  const ManagerPermissionsScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagerPermissionsScreenState();
}

class _ManagerPermissionsScreenState
    extends ConsumerState<ManagerPermissionsScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manager Permissions',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
    );
  }
}
