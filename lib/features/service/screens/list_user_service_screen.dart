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

class ListUserServiceScreen extends ConsumerWidget {
  const ListUserServiceScreen({super.key});

  void deleteService(
      BuildContext context, WidgetRef ref, String serviceId) async {
    final int ManagersCount = await ref
        .read(managerControllerProvider.notifier)
        .getManagersByServiceIdCount(serviceId);

    final int membersCount = await ref
        .read(memberControllerProvider.notifier)
        .getMembersByServiceIdCount(serviceId);

    final int ruleMembersCount = await ref
        .read(ruleMemberControllerProvider.notifier)
        .getRuleMembersByServiceIdCount(serviceId);

    // **************************************************************************
    // **************************************************************************
    // **************************************************************************
    // **************************************************************************
    // **************************************************************************
    // HERE ROB CHECK IF COUNTS > 0 AND IF END USER REALLY WANTS TO DELETE OR NOT
    // **************************************************************************
    // **************************************************************************
    // **************************************************************************
    // **************************************************************************
    // **************************************************************************
    // Routemaster.of(context).push(serviceId);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push(serviceId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref.watch(userServicesProvider).when(
          data: (services) => Scaffold(
            appBar: AppBar(
              title: Text(
                'Services(${services.length})',
                style: TextStyle(
                  color: currentTheme.textTheme.bodyMedium!.color!,
                ),
              ),
            ),
            body: services.isEmpty
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
                        return ListTile(
                          leading: service.image == Constants.avatarDefault
                              ? CircleAvatar(
                                  backgroundImage:
                                      Image.asset(service.image).image,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(service.image),
                                ),
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
                                      size: 18, color: Pallete.greyColor),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                deleteService(context, service.serviceId),
                          ),
                          onTap: () =>
                              showServiceDetails(context, service.serviceId),
                        );
                      },
                    ),
                  ),
          ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
