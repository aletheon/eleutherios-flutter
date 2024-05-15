import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:url_launcher/url_launcher.dart';

class ServiceUserProfileScreen extends ConsumerWidget {
  final String uid;
  const ServiceUserProfileScreen({super.key, required this.uid});

  void showUrl({required String url}) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      print('cant launch');
    }
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
      backgroundColor: currentTheme.scaffoldBackgroundColor,
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
                                    backgroundImage: Image.network(
                                      user.profilePic,
                                      loadingBuilder:
                                          (context, child, loadingProgress) {
                                        return loadingProgress
                                                    ?.cumulativeBytesLoaded ==
                                                loadingProgress
                                                    ?.expectedTotalBytes
                                            ? child
                                            : const CircularProgressIndicator();
                                      },
                                    ).image,
                                    radius: 45,
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
                body: Padding(
                  padding: const EdgeInsets.only(top: 0, left: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      user!.businessName.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(user.businessName),
                            )
                          : const SizedBox(),
                      user.businessDescription.isNotEmpty
                          ? Container(
                              padding: const EdgeInsets.only(bottom: 15),
                              child: Text(user.businessDescription),
                            )
                          : const SizedBox(),
                      user.businessWebsite.isNotEmpty
                          ? Row(
                              children: [
                                const Text('Business'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Wrap(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () =>
                                          showUrl(url: user.businessWebsite),
                                      child: Text(
                                        user.businessWebsite,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: 10,
                      ),
                      user.personalWebsite.isNotEmpty
                          ? Row(
                              children: [
                                const Text('Personal'),
                                const SizedBox(
                                  width: 10,
                                ),
                                Wrap(
                                  children: <Widget>[
                                    InkWell(
                                      onTap: () =>
                                          showUrl(url: user.personalWebsite),
                                      child: Text(
                                        user.personalWebsite,
                                        style: const TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader()),
    );
  }
}
