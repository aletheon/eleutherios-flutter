import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/rule_member.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class EditPotentialMemberPermissionsScreen extends ConsumerStatefulWidget {
  final String policyId;
  final String ruleId;
  final String ruleMemberId;
  const EditPotentialMemberPermissionsScreen(
      {super.key,
      required this.policyId,
      required this.ruleId,
      required this.ruleMemberId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditPotentialMemberPermissionsScreenState();
}

class _EditPotentialMemberPermissionsScreenState
    extends ConsumerState<EditPotentialMemberPermissionsScreen> {
  void save(RuleMember ruleMember, List<String> permissions) {
    ruleMember = ruleMember.copyWith(permissions: permissions);
    ref
        .read(ruleMemberControllerProvider.notifier)
        .updateRuleMember(ruleMember: ruleMember, context: context);
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final rule = await ref.read(getRuleByIdProvider2(widget.ruleId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (rule!.uid != user.uid) {
      if (manager!.permissions.contains(
              ManagerPermissions.editpotentialmemberpermissions.name) ==
          false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to make changes to potential member permissions');
          Routemaster.of(context).pop();
        });
      }
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
    final currentTheme = ref.watch(themeNotifierProvider);
    List<String> permissions = [];

    return ref.watch(getRuleMemberByIdProvider(widget.ruleMemberId)).when(
          data: (ruleMember) {
            permissions = ruleMember!.permissions;
            return ref.watch(getServiceByIdProvider(ruleMember.serviceId)).when(
                  data: (service) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'Edit Permissions',
                          style: TextStyle(
                            color: currentTheme.textTheme.bodyMedium!.color!,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => {
                              save(ruleMember, permissions),
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                service!.image == Constants.avatarDefault
                                    ? CircleAvatar(
                                        backgroundImage:
                                            Image.asset(service.image).image,
                                        radius: 25,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(service.image),
                                        radius: 25,
                                      ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    service.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: MemberPermissions.values.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final permission =
                                      MemberPermissions.values[index];
                                  List<Widget> _icons = [];

                                  switch (permission.name) {
                                    case 'editforum':
                                      _icons.add(
                                        const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'addmember':
                                      _icons.add(
                                        const Icon(
                                          Icons.construction,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'removemember':
                                      _icons.add(
                                        const Icon(
                                          Icons.construction,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'createforum':
                                      _icons.add(
                                        const Icon(
                                          Icons.forum,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'removeforum':
                                      _icons.add(
                                        const Icon(
                                          Icons.forum,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'createpost':
                                      _icons.add(
                                        const Icon(
                                          Icons.article,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'removepost':
                                      _icons.add(
                                        const Icon(
                                          Icons.article,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    default:
                                      _icons.add(
                                        const Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                  }

                                  final permissionIcon = CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Pallete.greyColor,
                                    child: CircleAvatar(
                                      radius: 13,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: _icons,
                                      ),
                                    ),
                                  );

                                  return CheckboxListTile(
                                    secondary: permissionIcon,
                                    title: Text(permission.value),
                                    value: permissions.contains(permission.name)
                                        ? true
                                        : false,
                                    onChanged: (isChecked) {
                                      setState(() {
                                        if (isChecked!) {
                                          permissions.add(permission.name);
                                        } else {
                                          permissions.remove(permission.name);
                                        }
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    activeColor: Pallete.forumColor,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
