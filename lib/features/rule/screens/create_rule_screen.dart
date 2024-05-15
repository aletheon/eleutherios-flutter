import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/models/manager.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:tuple/tuple.dart';

final instantiationTypeRadioProvider =
    StateProvider<String>((ref) => InstantiationType.consume.value);

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

  void createRule(String? managerId) {
    if (titleController.text.trim().isNotEmpty) {
      ref.read(ruleControllerProvider.notifier).createRule(
            widget.policyId!,
            managerId,
            titleController.text.trim(),
            descriptionController.text.trim(),
            isChecked,
            ref.read(instantiationTypeRadioProvider.notifier).state,
            null,
            context,
          );
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  Widget bodyOfScaffold(Policy? policy, Manager? manager) {
    final instantiationTypeRadioProv =
        ref.watch(instantiationTypeRadioProvider.notifier).state;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.build, size: 21, color: Colors.grey),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Create rule when policy is consumed by a service",
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                ),
              ),
              Radio(
                  value: InstantiationType.consume.value,
                  groupValue: instantiationTypeRadioProv,
                  onChanged: (newValue) {
                    ref.read(instantiationTypeRadioProvider.notifier).state =
                        newValue.toString();
                  }),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Icon(Icons.attach_money, size: 22, color: Colors.grey),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Create rule when service consuming policy has been ordered by a service",
                    textWidthBasis: TextWidthBasis.longestLine,
                  ),
                ),
              ),
              Radio(
                  value: InstantiationType.order.value,
                  groupValue: instantiationTypeRadioProv,
                  onChanged: (newValue) {
                    ref.read(instantiationTypeRadioProvider.notifier).state =
                        newValue.toString();
                  }),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () =>
                createRule(manager != null ? manager.managerId : ''),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              backgroundColor: Pallete.policyColor,
            ),
            child: const Text(
              'Create Rule',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(policyControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(getPolicyByIdProvider(widget.policyId!)).when(
          data: (policy) {
            return ref
                .watch(getUserSelectedManagerProvider(
                    Tuple2(widget.policyId, user.uid)))
                .when(
                  data: (manager) {
                    return Scaffold(
                        backgroundColor: currentTheme.scaffoldBackgroundColor,
                        appBar: AppBar(
                          title: Text(
                            'Create Rule for ${policy!.title}',
                            softWrap: true,
                            maxLines: 5,
                            style: TextStyle(
                              color: currentTheme.textTheme.bodyMedium!.color!,
                            ),
                          ),
                        ),
                        body: isLoading
                            ? const Loader()
                            : bodyOfScaffold(policy, manager));
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
