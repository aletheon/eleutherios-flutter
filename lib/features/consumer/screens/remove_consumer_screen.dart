import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class RemoveConsumerScreen extends ConsumerStatefulWidget {
  final String policyId;
  const RemoveConsumerScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RemoveConsumerScreenState();
}

class _RemoveConsumerScreenState extends ConsumerState<RemoveConsumerScreen> {
  final GlobalKey _scaffold = GlobalKey();

  void removeConsumerService(WidgetRef ref, String serviceId) {
    ref.read(policyControllerProvider.notifier).removePolicyFromService(
        serviceId, widget.policyId, _scaffold.currentContext!);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  // validateUser() async {
  //   final user = ref.read(userProvider)!;
  //   final forum = await ref.read(getForumByIdProvider2(widget.forumId)).first;
  //   final member = await ref
  //       .read(getUserSelectedMemberProvider2(Tuple2(widget.forumId, user.uid)))
  //       .first;

  //   if (forum!.uid != user.uid) {
  //     if (member!.permissions.contains(MemberPermissions.removemember.name) ==
  //         false) {
  //       Future.delayed(Duration.zero, () {
  //         showSnackBar(context,
  //             'You do not have permission to remove a member from this forum');
  //         Routemaster.of(context).pop();
  //       });
  //     }
  //   }
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     validateUser();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(policyControllerProvider);
    final policyProv = ref.watch(getPolicyByIdProvider(widget.policyId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return policyProv.when(
      data: (policy) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Consumer',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: isLoading
              ? const Loader()
              : policy!.consumers.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: const Text(
                          'No consumers',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ListView.builder(
                        itemCount: policy.consumers.length,
                        itemBuilder: (BuildContext context, int index) {
                          final serviceId = policy.consumers[index];

                          return ref
                              .watch(getServiceByIdProvider(serviceId))
                              .when(
                                data: (service) {
                                  return ListTile(
                                    title: Text(
                                      service!.title,
                                      textWidthBasis:
                                          TextWidthBasis.longestLine,
                                    ),
                                    leading:
                                        service.image == Constants.avatarDefault
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
                                      onPressed: () => removeConsumerService(
                                        ref,
                                        serviceId,
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
                        },
                      ),
                    ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
