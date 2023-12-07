import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToEditUser(BuildContext context) {
    Routemaster.of(context).push('edit');
  }

  Color getCertColor(UserModel user) {
    if (user.cert == 1) {
      return Pallete.cert1;
    }
    if (user.cert == 2) {
      return Pallete.cert2;
    }
    if (user.cert == 3) {
      return Pallete.cert3;
    }
    if (user.cert == 4) {
      return Pallete.cert4;
    }
    return Pallete.cert5;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      backgroundColor: currentTheme.backgroundColor,
      body: ref.watch(getUserDataProvider(uid)).when(
          data: (user) => NestedScrollView(
                headerSliverBuilder: ((context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 250,
                      floating: true,
                      snap: true,
                      flexibleSpace: Stack(
                        children: [
                          Positioned.fill(
                            child: user.banner == Constants.bannerDefault
                                ? Image.asset(
                                    user.banner,
                                    fit: BoxFit.cover,
                                  )
                                : Image.network(
                                    user.banner,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          user.profilePic == Constants.avatarDefault
                              ? CircleAvatar(
                                  backgroundImage:
                                      Image.asset(user.profilePic).image,
                                  radius: 45,
                                )
                              : Container(
                                  alignment: Alignment.bottomLeft,
                                  padding: const EdgeInsets.all(20)
                                      .copyWith(bottom: 50),
                                  child: CircleAvatar(
                                    backgroundImage:
                                        Image.network(user.profilePic).image,
                                    radius: 45,
                                  ),
                                ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding:
                                const EdgeInsets.all(5).copyWith(bottom: 5),
                            child: OutlinedButton(
                              onPressed: () => navigateToEditUser(context),
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25)),
                              child: const Text(
                                'Edit Profile',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  user.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Chip(
                                  backgroundColor: getCertColor(user),
                                  label: Text(
                                    'CERT ${user.cert}',
                                    style: TextStyle(
                                      color: currentTheme
                                          .textTheme.bodyMedium!.color!,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Divider(
                                  thickness: 2,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ];
                }),
                body: const Padding(
                  padding: EdgeInsets.only(top: 0, left: 20),
                  child: Text('Displaying posts'),
                ),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
