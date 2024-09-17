import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/models/manager.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:tuple/tuple.dart';

final ruleTypeRadioProvider =
    StateProvider<String>((ref) => RuleType.multiple.value);
final instantiationTypeRadioProvider =
    StateProvider<String>((ref) => InstantiationType.consume.value);

class CreateRuleScreen extends ConsumerStatefulWidget {
  final String policyId;
  const CreateRuleScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateRuleScreenState();
}

class _CreateRuleScreenState extends ConsumerState<CreateRuleScreen> {
  final GlobalKey _scaffold = GlobalKey();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late double _distanceToField;
  late StringTagController _stringTagController;
  bool isChecked = false;

  void createRule(String? managerId) {
    List<String>? tags = _stringTagController.getTags;

    if (titleController.text.trim().isNotEmpty) {
      ref.read(ruleControllerProvider.notifier).createRule(
            widget.policyId,
            managerId,
            titleController.text.trim(),
            descriptionController.text.trim(),
            isChecked,
            tags,
            ref.read(ruleTypeRadioProvider.notifier).state,
            ref.read(instantiationTypeRadioProvider.notifier).state,
            null,
            _scaffold.currentContext!,
          );
    }
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final policy =
        await ref.read(getPolicyByIdProvider2(widget.policyId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (policy != null) {
      if (policy.uid != user.uid) {
        if (manager != null &&
            manager.permissions.contains(ManagerPermissions.createrule.value) ==
                false) {
          Future.delayed(Duration.zero, () {
            showSnackBar(
                context,
                'You do not have permission to create a rule for this policy',
                true);
            Routemaster.of(context).pop();
          });
        }
      }
    } else {
      Future.delayed(Duration.zero, () {
        showSnackBar(context, 'Policy does not exist', true);
        Routemaster.of(context).pop();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
    _stringTagController = StringTagController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateUser();
    });
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  Widget bodyOfScaffold(Policy? policy, Manager? manager) {
    final ruleTypeRadioProv = ref.watch(ruleTypeRadioProvider.notifier).state;
    final instantiationTypeRadioProv =
        ref.watch(instantiationTypeRadioProvider.notifier).state;

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
              activeColor: Pallete.ruleColor,
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Title',
                filled: true,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(18),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Pallete.ruleTagColor),
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
                  borderSide: BorderSide(color: Pallete.ruleTagColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 3,
              maxLength: 1000,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldTags<String>(
              textfieldTagsController: _stringTagController,
              textSeparators: const [' ', ','],
              letterCase: LetterCase.small,
              validator: (String tag) {
                if (_stringTagController.getTags!.contains(tag)) {
                  return 'You\'ve already entered that';
                }
                return null;
              },
              inputFieldBuilder: (context, inputFieldValues) {
                return TextField(
                  onTap: () {
                    _stringTagController.getFocusNode?.requestFocus();
                  },
                  controller: inputFieldValues.textEditingController,
                  focusNode: inputFieldValues.focusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Pallete.ruleTagColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Pallete.ruleTagColor),
                    ),
                    hintText:
                        inputFieldValues.tags.isNotEmpty ? '' : "Enter tag",
                    errorText: inputFieldValues.error,
                    prefixIconConstraints:
                        BoxConstraints(maxWidth: _distanceToField * 0.8),
                    prefixIcon: inputFieldValues.tags.isNotEmpty
                        ? SingleChildScrollView(
                            controller: inputFieldValues.tagScrollController,
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8,
                                bottom: 8,
                                left: 8,
                              ),
                              child: Wrap(
                                  runSpacing: 4.0,
                                  spacing: 4.0,
                                  children:
                                      inputFieldValues.tags.map((String tag) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Pallete.ruleTagColor,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '#$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              // print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              inputFieldValues
                                                  .onTagRemoved(tag);
                                            },
                                          )
                                        ],
                                      ),
                                    );
                                  }).toList()),
                            ),
                          )
                        : null,
                  ),
                  onChanged: inputFieldValues.onTagChanged,
                  onSubmitted: (tag) {
                    List<String>? tags = _stringTagController.getTags;

                    if (tags != null && tags.length >= 5) {
                      showDialog(
                        context: _scaffold.currentContext!,
                        barrierDismissible: true,
                        builder: (context) {
                          String message =
                              "You have reached the limit of 5 tags";

                          return AlertDialog(
                            content: Text(message),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    } else {
                      inputFieldValues.onTagSubmitted(tag);
                    }
                  },
                );
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.build_outlined, size: 21),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Create a separate forum for each service when this rule is instantiated.",
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                  ),
                ),
                Radio(
                    value: RuleType.multiple.value,
                    groupValue: ruleTypeRadioProv,
                    onChanged: (newValue) {
                      ref.read(ruleTypeRadioProvider.notifier).state =
                          newValue.toString();
                    }),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.attach_money_outlined, size: 22),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Create a single forum for all services when this rule is instantiated.",
                      textWidthBasis: TextWidthBasis.longestLine,
                    ),
                  ),
                ),
                Radio(
                    value: RuleType.single.value,
                    groupValue: ruleTypeRadioProv,
                    onChanged: (newValue) {
                      ref.read(ruleTypeRadioProvider.notifier).state =
                          newValue.toString();
                    }),
              ],
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width,
              child: const Divider(color: Colors.grey, thickness: 1.0),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.build_outlined, size: 21),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Create forum immediately when policy is consumed by a service.",
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
                const Icon(Icons.attach_money_outlined, size: 22),
                const SizedBox(
                  width: 12,
                ),
                Flexible(
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Create forum when service consuming policy is ordered by another service.  For example a patient paying to see a doctor.",
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
                backgroundColor: Pallete.ruleColor,
              ),
              child: const Text(
                'Create Rule',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
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
                      key: _scaffold,
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
                      body: Stack(
                        children: <Widget>[
                          bodyOfScaffold(policy, manager),
                          Container(
                            child: isLoading ? const Loader() : Container(),
                          )
                        ],
                      ),
                    );
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
