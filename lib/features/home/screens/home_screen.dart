import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/home/delegates/search_home_delegate.dart';
import 'package:reddit_tutorial/features/home/drawers/list_drawer.dart';
import 'package:reddit_tutorial/features/home/drawers/profile_drawer.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void showPolicyDetails(String policyId, BuildContext context) {
    Routemaster.of(context).push('/policy/$policyId');
    Scaffold.of(context).closeDrawer();
  }

  void showForumDetails(String forumId, BuildContext context) {
    Routemaster.of(context).replace('/forum/$forumId');
  }

  void showServiceDetails(String serviceId, BuildContext context) {
    Routemaster.of(context).push('/service/$serviceId');
    Scaffold.of(context).closeDrawer();
  }

  void showCart(BuildContext context) {
    Routemaster.of(context).replace('/viewcart');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: const Icon(Icons.menu),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: SearchHomeDelegate(ref));
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              showCart(context);
            },
            icon: const Icon(Icons.shopping_cart),
          ),
          Builder(builder: (context) {
            return IconButton(
              onPressed: () {
                displayEndDrawer(context);
              },
              icon: user.profilePic == Constants.avatarDefault
                  ? CircleAvatar(
                      backgroundImage: Image.asset(user.profilePic).image,
                      radius: 18,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 18,
                    ),
            );
          }),
        ],
      ),
      drawer: const ListDrawer(),
      endDrawer: const ProfileDrawer(),
      body: Column(
        children: [
          // *********************************
          // public policies
          // *********************************
          ref.watch(policiesProvider).when(
                data: (policies) => policies.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 10),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            'No policies',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    : CarouselSlider.builder(
                        itemCount: policies.length,
                        itemBuilder: (context, index, realIndex) {
                          return GestureDetector(
                            onTap: () => showPolicyDetails(
                                policies[index].policyId, context),
                            child: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Pallete.policyColor),
                              // ),
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      child: policies[index].banner ==
                                              Constants.policyBannerDefault
                                          ? Image.asset(
                                              policies[index].banner,
                                            )
                                          : Image.network(
                                              policies[index].banner,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                return loadingProgress
                                                            ?.cumulativeBytesLoaded ==
                                                        loadingProgress
                                                            ?.expectedTotalBytes
                                                    ? child
                                                    : const CircularProgressIndicator();
                                              },
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.account_balance_outlined,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          policies[index].title,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      policies[index].description,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 260,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.2,
                          viewportFraction: 0.6,
                        ),
                      ),
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
          // *********************************
          // public forums
          // *********************************
          ref.watch(forumsProvider).when(
                data: (forums) => forums.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0, bottom: 10),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            'No forums',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    : CarouselSlider.builder(
                        itemCount: forums.length,
                        itemBuilder: (context, index, realIndex) {
                          return GestureDetector(
                            onTap: () => showForumDetails(
                                forums[index].forumId, context),
                            child: Container(
                              // decoration: BoxDecoration(
                              //   border: Border.all(color: Pallete.forumColor),
                              // ),
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      child: forums[index].banner ==
                                              Constants.forumBannerDefault
                                          ? Image.asset(
                                              forums[index].banner,
                                            )
                                          : Image.network(
                                              forums[index].banner,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                return loadingProgress
                                                            ?.cumulativeBytesLoaded ==
                                                        loadingProgress
                                                            ?.expectedTotalBytes
                                                    ? child
                                                    : const CircularProgressIndicator();
                                              },
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.sms_outlined,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          forums[index].title,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      forums[index].description,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                            height: 270,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.2,
                            viewportFraction: 0.6),
                      ),
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
          // *********************************
          // public services
          // *********************************
          ref.watch(servicesProvider).when(
                data: (services) => services.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            'No services',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      )
                    : CarouselSlider.builder(
                        itemCount: services.length,
                        itemBuilder: (context, index, realIndex) {
                          return GestureDetector(
                            onTap: () => showServiceDetails(
                                services[index].serviceId, context),
                            child: Container(
                              // decoration: BoxDecoration(
                              //   border:
                              //       Border.all(color: Pallete.freeServiceColor),
                              // ),
                              width: MediaQuery.of(context).size.width,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 2.0),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                      child: services[index].banner ==
                                              Constants.serviceBannerDefault
                                          ? Image.asset(
                                              services[index].banner,
                                            )
                                          : Image.network(
                                              services[index].banner,
                                              loadingBuilder: (context, child,
                                                  loadingProgress) {
                                                return loadingProgress
                                                            ?.cumulativeBytesLoaded ==
                                                        loadingProgress
                                                            ?.expectedTotalBytes
                                                    ? child
                                                    : const CircularProgressIndicator();
                                              },
                                            ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Wrap(
                                      crossAxisAlignment:
                                          WrapCrossAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.construction_outlined,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          services[index].title,
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 3,
                                    ),
                                    Text(
                                      services[index].description,
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        options: CarouselOptions(
                          height: 260,
                          enlargeCenterPage: true,
                          enlargeFactor: 0.2,
                          viewportFraction: 0.6,
                        ),
                      ),
                error: (error, stackTrace) =>
                    ErrorText(error: error.toString()),
                loading: () => const Loader(),
              ),
        ],
      ),
    );
  }
}
