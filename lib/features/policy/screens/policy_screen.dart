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

class PolicyScreen extends ConsumerWidget {
  final String policyId;
  const PolicyScreen({super.key, required this.policyId});

  void navigateToPolicyTools(BuildContext context) {
    Routemaster.of(context).push('policy-tools');
  }

  void consume(BuildContext context) {
    Routemaster.of(context).push('consume');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final managersProv = ref.watch(getManagersProvider(policyId));

    return Scaffold(
      body: ref.watch(getPolicyByIdProvider(policyId)).when(
          data: (policy) => NestedScrollView(
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 150,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child:
                                policy!.banner == Constants.policyBannerDefault
                                    ? Image.asset(
                                        policy.banner,
                                        fit: BoxFit.cover,
                                      )
                                    : Image.network(
                                        policy.banner,
                                        fit: BoxFit.cover,
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          return loadingProgress
                                                      ?.cumulativeBytesLoaded ==
                                                  loadingProgress
                                                      ?.expectedTotalBytes
                                              ? child
                                              : const CircularProgressIndicator();
                                        },
                                      ),
                          )
                        ],
                      ),
                      floating: true,
                      snap: true,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate.fixed(
                          [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    policy.image == Constants.avatarDefault
                                        ? CircleAvatar(
                                            backgroundImage:
                                                Image.asset(policy.image).image,
                                            radius: 35,
                                          )
                                        : CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(policy.image),
                                            radius: 35,
                                          ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            policy.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        policy.public
                                            ? const Icon(
                                                Icons.lock_open_outlined)
                                            : const Icon(Icons.lock_outlined,
                                                color: Pallete.greyColor),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    policy.description.isNotEmpty
                                        ? Wrap(
                                            children: [
                                              Text(policy.description),
                                              const SizedBox(
                                                height: 30,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                    Text('${policy.managers.length} managers'),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    managersProv.when(
                                      data: (managers) {
                                        if (managers.isNotEmpty) {
                                          return SizedBox(
                                            height: 70,
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: managers.length,
                                              itemBuilder: (
                                                BuildContext context,
                                                int index,
                                              ) {
                                                final manager = managers[index];
                                                return ref
                                                    .watch(
                                                        getServiceByIdProvider(
                                                            manager.serviceId))
                                                    .when(
                                                      data: (service) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  right: 10),
                                                          child: Column(
                                                            children: [
                                                              service!.image ==
                                                                      Constants
                                                                          .avatarDefault
                                                                  ? CircleAvatar(
                                                                      backgroundImage:
                                                                          Image.asset(service.image)
                                                                              .image,
                                                                    )
                                                                  : CircleAvatar(
                                                                      backgroundImage:
                                                                          NetworkImage(
                                                                              service.image),
                                                                    ),
                                                              const SizedBox(
                                                                height: 10,
                                                              ),
                                                              service.title
                                                                          .length >
                                                                      20
                                                                  ? Text(
                                                                      '${service.title.substring(0, 20)}...')
                                                                  : Text(service
                                                                      .title),
                                                            ],
                                                          ),
                                                        );
                                                      },
                                                      error: (error,
                                                              stackTrace) =>
                                                          ErrorText(
                                                              error: error
                                                                  .toString()),
                                                      loading: () =>
                                                          const Loader(),
                                                    );
                                              },
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      },
                                      error: (error, stackTrace) =>
                                          ErrorText(error: error.toString()),
                                      loading: () => const Loader(),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    policy.uid == user.uid ||
                                            user.activities.contains(policyId)
                                        ? OutlinedButton(
                                            onPressed: () =>
                                                navigateToPolicyTools(context),
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 25)),
                                            child: const Text('Policy Tools'),
                                          )
                                        : const SizedBox(),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    policy.public
                                        ? OutlinedButton(
                                            onPressed: () => consume(context),
                                            style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 25),
                                            ),
                                            child: const Text('Consume'),
                                          )
                                        : const SizedBox(),
                                  ],
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ];
                }),
                body: const Padding(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                  child: Text('List rules for policy'),
                ),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
