import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ManagerLeaveScreen extends ConsumerStatefulWidget {
  final String policyId;
  const ManagerLeaveScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ManagerLeaveScreenState();
}

class _ManagerLeaveScreenState extends ConsumerState<ManagerLeaveScreen> {
  void removeManagerService(
      BuildContext context, WidgetRef ref, String policyId, String managerId) {
    ref
        .read(managerControllerProvider.notifier)
        .deleteManager(policyId, managerId, context);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  @override
  Widget build(BuildContext context) {
    final policyProv = ref.watch(getPolicyByIdProvider(widget.policyId));
    final managersProv = ref.watch(getManagersProvider(widget.policyId));
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return policyProv.when(
      data: (policy) {
        return Scaffold(
          backgroundColor: currentTheme.backgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Services',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: managersProv.when(
            data: (managers) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: managers.length,
                  itemBuilder: (BuildContext context, int index) {
                    final manager = managers[index];

                    if (manager.serviceUid == user.uid) {
                      return ref
                          .watch(getServiceByIdProvider(manager.serviceId))
                          .when(
                            data: (service) {
                              return ListTile(
                                title: manager.selected == false
                                    ? Text(service!.title)
                                    : Row(
                                        children: [
                                          Text(service!.title),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          const Icon(
                                            Icons.check,
                                            color:
                                                Color.fromARGB(255, 3, 233, 33),
                                          )
                                        ],
                                      ),
                                leading: service.image ==
                                        Constants.avatarDefault
                                    ? CircleAvatar(
                                        backgroundImage:
                                            Image.asset(service.image).image,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(service.image),
                                      ),
                                trailing: TextButton(
                                  onPressed: () => removeManagerService(
                                    context,
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
                              );
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              );
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
