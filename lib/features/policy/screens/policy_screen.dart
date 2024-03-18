import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
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
                body: const SizedBox(),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
