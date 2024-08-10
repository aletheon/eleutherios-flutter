import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

final GlobalKey _scaffold = GlobalKey();

class ListUserServiceScreen extends ConsumerWidget {
  const ListUserServiceScreen({super.key});

  void deleteService(
      String serviceId, BuildContext context, WidgetRef ref) async {
    final int? managerCount = await ref
        .read(managerControllerProvider.notifier)
        .getManagersByServiceIdCount(serviceId);

    final int? memberCount = await ref
        .read(memberControllerProvider.notifier)
        .getMembersByServiceIdCount(serviceId);

    final int? ruleMemberCount = await ref
        .read(ruleMemberControllerProvider.notifier)
        .getRuleMembersByServiceIdCount(serviceId);

    if (ruleMemberCount! > 0 || memberCount! > 0 || managerCount! > 0) {
      showDialog(
        context: _scaffold.currentContext!,
        barrierDismissible: true,
        builder: (context) {
          String message = "";

          if (managerCount! > 0 && memberCount! > 0 && ruleMemberCount > 0) {
            message +=
                "This service is serving as a manager in $managerCount policy(s), a ";
            message += "member in $memberCount forum(s) and a ";
            message += "rule member in $ruleMemberCount rule(s).";
          } else if (managerCount > 0 && memberCount! > 0) {
            message +=
                "This service is serving as a manager in $managerCount policy(s) and a ";
            message += "member in $memberCount forum(s).";
          } else if (managerCount > 0 && ruleMemberCount > 0) {
            message +=
                "This service is serving as a manager in $managerCount policy(s) and a ";
            message += "rule member in $ruleMemberCount rule(s).";
          } else if (memberCount! > 0 && ruleMemberCount > 0) {
            message +=
                "This service is serving as a member in $memberCount forum(s) and a ";
            message += "rule member in $ruleMemberCount rule(s).";
          } else if (managerCount > 0) {
            message +=
                "This service is serving as a manager in $managerCount policy(s).";
          } else if (memberCount > 0) {
            message +=
                "This service is serving as a member in $memberCount forum(s).";
          } else {
            message +=
                "This service has a rule member in $ruleMemberCount rule(s).";
          }
          message += "  Are you sure you want to delete it?";

          return AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(serviceControllerProvider.notifier).deleteService(
                        serviceId,
                        _scaffold.currentContext!,
                      );

                  Navigator.of(context).pop();
                },
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              )
            ],
          );
        },
      );
    } else {
      ref.read(serviceControllerProvider.notifier).deleteService(
            serviceId,
            _scaffold.currentContext!,
          );
    }
  }

  void showServiceDetails(String serviceId, BuildContext context) {
    Routemaster.of(context).push(serviceId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool isLoading = ref.watch(serviceControllerProvider);
    final bool memberIsLoading = ref.watch(memberControllerProvider);
    final bool ruleMemberIsLoading = ref.watch(ruleMemberControllerProvider);
    final bool managerIsLoading = ref.watch(managerControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(userServicesProvider).when(
          data: (services) => Scaffold(
            key: _scaffold,
            appBar: AppBar(
              title: Text(
                'Services(${services.length})',
                style: TextStyle(
                  color: currentTheme.textTheme.bodyMedium!.color!,
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                services.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            "No services",
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView.builder(
                          itemCount: services.length,
                          itemBuilder: (BuildContext context, int index) {
                            final service = services[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                ListTile(
                                  title: Row(
                                    children: [
                                      Text(service.title),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      service.public
                                          ? const Icon(
                                              Icons.lock_open_outlined,
                                              size: 18,
                                            )
                                          : const Icon(Icons.lock_outlined,
                                              size: 18,
                                              color: Pallete.greyColor),
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
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => deleteService(
                                        service.serviceId, context, ref),
                                  ),
                                  onTap: () => showServiceDetails(
                                      service.serviceId, context),
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
                                              padding: const EdgeInsets.only(
                                                  right: 5),
                                              child: FilterChip(
                                                visualDensity:
                                                    const VisualDensity(
                                                        vertical: -4,
                                                        horizontal: -4),
                                                onSelected: (value) {},
                                                backgroundColor:
                                                    service.price == -1
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
                        ),
                      ),
                Container(
                  child: isLoading ||
                          memberIsLoading ||
                          ruleMemberIsLoading ||
                          managerIsLoading
                      ? const Loader()
                      : Container(),
                )
              ],
            ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
