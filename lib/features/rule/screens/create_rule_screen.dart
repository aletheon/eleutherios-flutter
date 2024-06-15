import 'package:flutter/material.dart';
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
import 'package:tuple/tuple.dart';

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
            _scaffold.currentContext!,
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
              const Icon(Icons.build_outlined, size: 21),
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
              const Icon(Icons.attach_money_outlined, size: 22),
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
        if (manager != null) {
          if (manager.permissions
                  .contains(ManagerPermissions.createrule.name) ==
              false) {
            Future.delayed(Duration.zero, () {
              showSnackBar(context,
                  'You do not have permission to create a rule for this policy');
              Routemaster.of(context).pop();
            });
          }
        } else {
          Future.delayed(Duration.zero, () {
            showSnackBar(context, 'Manager does not exist');
            Routemaster.of(context).pop();
          });
        }
      }
    } else {
      Future.delayed(Duration.zero, () {
        showSnackBar(context, 'Policy does not exist');
        Routemaster.of(context).pop();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateUser();
    });
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
