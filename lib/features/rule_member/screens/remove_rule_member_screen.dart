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
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class RemoveRuleMemberScreen extends ConsumerStatefulWidget {
  final String policyId;
  final String ruleId;
  const RemoveRuleMemberScreen(
      {super.key, required this.policyId, required this.ruleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveRuleMemberScreenState();
}

class _RemoveRuleMemberScreenState
    extends ConsumerState<RemoveRuleMemberScreen> {
  final GlobalKey _scaffold = GlobalKey();

  void removeRuleMemberService(
      WidgetRef ref, String ruleId, String ruleMemberId) {
    ref
        .read(ruleMemberControllerProvider.notifier)
        .deleteRuleMember(ruleId, ruleMemberId, _scaffold.currentContext!);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final rule = await ref.read(getRuleByIdProvider2(widget.ruleId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (rule!.uid != user.uid) {
      if (manager != null &&
          manager.permissions
                  .contains(ManagerPermissions.addrulemember.value) ==
              false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(
              context,
              'You do not have permission to remove a member from this rule',
              true);
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
    final isLoading = ref.watch(ruleMemberControllerProvider);
    final ruleProv = ref.watch(getRuleByIdProvider(widget.ruleId));
    final ruleMembersProv = ref.watch(getRuleMembersProvider(widget.ruleId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return ruleProv.when(
      data: (rule) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Member',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              ruleMembersProv.when(
                data: (ruleMembers) {
                  if (ruleMembers.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: const Text(
                          'No members',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListView.builder(
                        itemCount: ruleMembers.length,
                        itemBuilder: (BuildContext context, int index) {
                          final ruleMember = ruleMembers[index];

                          return ref
                              .watch(
                                  getServiceByIdProvider(ruleMember.serviceId))
                              .when(
                                data: (service) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      ListTile(
                                        title: Row(
                                          children: [
                                            Flexible(
                                              child: Text(
                                                service!.title,
                                                textWidthBasis:
                                                    TextWidthBasis.longestLine,
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            service.public
                                                ? const Icon(
                                                    Icons.lock_open_outlined,
                                                    size: 18,
                                                  )
                                                : const Icon(
                                                    Icons.lock_outlined,
                                                    size: 18,
                                                    color: Pallete.greyColor),
                                          ],
                                        ),
                                        leading: service.image ==
                                                Constants.avatarDefault
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    Image.asset(service.image)
                                                        .image,
                                              )
                                            : CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(service.image),
                                              ),
                                        trailing: TextButton(
                                          onPressed: () =>
                                              removeRuleMemberService(
                                            ref,
                                            rule!.ruleId,
                                            ruleMember.ruleMemberId,
                                          ),
                                          child: const Text(
                                            'Remove',
                                          ),
                                        ),
                                        onTap: () => showServiceDetails(
                                            context, service.serviceId),
                                      ),
                                      service.tags.isNotEmpty
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 0, right: 20, left: 10),
                                              child: Wrap(
                                                alignment: WrapAlignment.end,
                                                direction: Axis.horizontal,
                                                children: service.tags.map((e) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5),
                                                    child: FilterChip(
                                                      visualDensity:
                                                          const VisualDensity(
                                                              vertical: -4,
                                                              horizontal: -4),
                                                      onSelected: (value) {},
                                                      backgroundColor: service
                                                                  .price ==
                                                              -1
                                                          ? Pallete
                                                              .freeServiceTagColor
                                                          : Pallete
                                                              .paidServiceTagColor,
                                                      label: Text(
                                                        '#$e',
                                                        style: const TextStyle(
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }).toList(),
                                              ),
                                            )
                                          : const SizedBox(),
                                    ],
                                  );
                                },
                                error: (error, stackTrace) =>
                                    ErrorText(error: error.toString()),
                                loading: () => const Loader(),
                              );
                        },
                      ),
                    );
                  }
                },
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
              Container(
                child: isLoading ? const Loader() : Container(),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
