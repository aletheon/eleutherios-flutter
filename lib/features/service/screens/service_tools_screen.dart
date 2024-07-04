import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ServiceToolsScreen extends ConsumerWidget {
  final String serviceId;
  const ServiceToolsScreen({super.key, required this.serviceId});

  void editService(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  void editPrice(BuildContext context) {
    Routemaster.of(context).push('edit-price');
  }

  void addPolicy(BuildContext context) {
    Routemaster.of(context).push('add-policy');
  }

  void removePolicy(BuildContext context) {
    Routemaster.of(context).push('remove-policy');
  }

  void addForum(BuildContext context) {
    Routemaster.of(context).push('add-forum');
  }

  void removeForum(BuildContext context) {
    Routemaster.of(context).push('remove-forum');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Service Tools',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
      body: Column(children: [
        ListTile(
          onTap: () => editService(context),
          leading: const Icon(Icons.edit_note_outlined),
          title: const Text('Edit Service'),
        ),
        ListTile(
          onTap: () => editPrice(context),
          leading: const Icon(Icons.paid_outlined),
          title: const Text('Edit Price & Type'),
        ),
        ListTile(
          onTap: () => addPolicy(context),
          leading: const Icon(Icons.add_moderator_outlined),
          title: const Text('Add Policy'),
        ),
        ListTile(
          onTap: () => removePolicy(context),
          leading: const Icon(Icons.remove_moderator_outlined),
          title: const Text('Remove Policy'),
        ),
        ListTile(
          onTap: () => addForum(context),
          leading: const Icon(Icons.add_moderator_outlined),
          title: const Text('Add Forum'),
        ),
        ListTile(
          onTap: () => removeForum(context),
          leading: const Icon(Icons.remove_moderator_outlined),
          title: const Text('Remove Forum'),
        )
      ]),
    );
  }
}
