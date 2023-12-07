import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void navigateToUserProfile(String uid, BuildContext context) {
    Routemaster.of(context).push('/user/$uid');
  }

  void navigateToFavorites(BuildContext context) {
    Routemaster.of(context).push('/favorite');
    Scaffold.of(context).closeDrawer();
  }

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  void toggleTheme(WidgetRef ref) {
    ref.read(themeNotifierProvider.notifier).toggleTheme();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            GestureDetector(
              onTap: () => navigateToUserProfile(user.uid, context),
              child: user.profilePic == Constants.avatarDefault
                  ? CircleAvatar(
                      backgroundImage: Image.asset(user.profilePic).image,
                      radius: 50,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                      radius: 50,
                    ),
            ),
            const SizedBox(height: 10),
            Text(
              user.fullName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 10),
            const Divider(),
            ListTile(
              title: Text('Favorites(${user.favorites.length})'),
              leading: const Icon(
                Icons.favorite_border,
              ),
              onTap: () => navigateToFavorites(context),
            ),
            ListTile(
              title: const Text('My Profile'),
              leading: const Icon(Icons.person_outline),
              onTap: () => navigateToUserProfile(user.uid, context),
            ),
            ListTile(
              title: const Text('Log Out'),
              leading: Icon(
                Icons.logout,
                color: Pallete.redColor,
              ),
              onTap: () => logout(ref),
            ),
            Switch.adaptive(
              value: ref.watch(themeNotifierProvider.notifier).mode ==
                      ThemeMode.dark
                  ? true
                  : false,
              onChanged: (val) => toggleTheme(ref),
            ),
          ],
        ),
      ),
    );
  }
}
