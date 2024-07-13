import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class RemoveManagerScreen extends ConsumerStatefulWidget {
  final String policyId;
  const RemoveManagerScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveManagerScreenState();
}

class _RemoveManagerScreenState extends ConsumerState<RemoveManagerScreen> {
  final GlobalKey _scaffold = GlobalKey();

  void removeManagerService(WidgetRef ref, String policyId, String managerId) {
    ref
        .read(managerControllerProvider.notifier)
        .deleteManager(policyId, managerId, _scaffold.currentContext!);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final policy =
        await ref.read(getPolicyByIdProvider2(widget.policyId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (policy!.uid != user.uid) {
      if (manager!.permissions
              .contains(ManagerPermissions.removemanager.value) ==
          false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(
              context,
              'You do not have permission to remove a manager from this policy',
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
    final isLoading = ref.watch(managerControllerProvider);
    final policyProv = ref.watch(getPolicyByIdProvider(widget.policyId));
    final managersProv = ref.watch(getManagersProvider(widget.policyId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return policyProv.when(
      data: (policy) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Manager',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: isLoading
              ? const Loader()
              : managersProv.when(
                  data: (managers) {
                    if (managers.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            'No managers',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView.builder(
                          itemCount: managers.length,
                          itemBuilder: (BuildContext context, int index) {
                            final manager = managers[index];

                            return ref
                                .watch(
                                    getServiceByIdProvider(manager.serviceId))
                                .when(
                                  data: (service) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        ListTile(
                                          title: Row(
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  service!.title,
                                                  textWidthBasis: TextWidthBasis
                                                      .longestLine,
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
                                                  backgroundImage: NetworkImage(
                                                      service.image),
                                                ),
                                          trailing: TextButton(
                                            onPressed: () =>
                                                removeManagerService(
                                              ref,
                                              policy!.policyId,
                                              manager.managerId,
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
                                                    top: 0,
                                                    right: 20,
                                                    left: 10),
                                                child: Wrap(
                                                  alignment: WrapAlignment.end,
                                                  direction: Axis.horizontal,
                                                  children:
                                                      service.tags.map((e) {
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
                                                          style:
                                                              const TextStyle(
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
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
