import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class CreateRuleScreen extends ConsumerStatefulWidget {
  final String? policyId;
  const CreateRuleScreen({super.key, this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateRuleScreenState();
}

class _CreateRuleScreenState extends ConsumerState<CreateRuleScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isChecked = false;

  void createRule() {
    if (titleController.text.trim().isNotEmpty) {
      // String policyId,
      // String managerId,
      // String title,
      // String description,
      // bool public,
      // String instantiationType,
      // DateTime instantiationDate,

      // ref.read(ruleControllerProvider.notifier).createRule(
      //       widget.policyId,
      //       titleController.text.trim(),
      //       descriptionController.text.trim(),
      //       isChecked,
      //       context,
      //     );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  Widget bodyOfScaffold() {
    return Padding(
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
            onPressed: createRule,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Pallete.policyColor,
            ),
            child: const Text(
              'Create Rule',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(forumControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    // HERE ROB HAVE TO GRAB THE DEFAULT SELECTED MANAGER OF THIS USER FOR THIS POLICY
    // IF THEY ARE THE POLICY OWNER SKIP THE MANAGER AND USE THE POLICY UID INSTEAD

    return Scaffold(
        backgroundColor: currentTheme.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Create Rule',
            style: TextStyle(
              color: currentTheme.textTheme.bodyMedium!.color!,
            ),
          ),
        ),
        body: isLoading ? const Loader() : bodyOfScaffold());
  }
}
