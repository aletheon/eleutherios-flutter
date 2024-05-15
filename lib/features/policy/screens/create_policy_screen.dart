import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class CreatePolicyScreen extends ConsumerStatefulWidget {
  const CreatePolicyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreatePolicyScreenState();
}

class _CreatePolicyScreenState extends ConsumerState<CreatePolicyScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isChecked = false;

  void createPolicy() {
    if (titleController.text.trim().isNotEmpty) {
      ref.read(policyControllerProvider.notifier).createPolicy(
          titleController.text.trim(),
          descriptionController.text.trim(),
          isChecked,
          context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(policyControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Create Policy',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  CheckboxListTile(
                    title: const Text(
                      "Public",
                      style: TextStyle(color: Pallete.greyColor),
                    ),
                    value: isChecked,
                    onChanged: (newValue) {
                      setState(() {
                        isChecked = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: Pallete.policyColor,
                  ),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(18),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLength: 40,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(18),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    maxLines: 8,
                    maxLength: 1000,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: createPolicy,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Pallete.policyColor,
                    ),
                    child: const Text(
                      'Create Policy',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
