import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ListUserServiceScreen extends ConsumerWidget {
  const ListUserServiceScreen({super.key});

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('detail/$serviceId');
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
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("You haven't created any services"),
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
                          title: Text(service.title),
                          trailing: service.public
                              ? const Icon(Icons.lock_open_outlined)
                              : const Icon(Icons.lock_outlined,
                                  color: Pallete.greyColor),
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
