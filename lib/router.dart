import 'package:flutter/material.dart';
import 'package:reddit_tutorial/features/activity/screens/activity_screen.dart';
import 'package:reddit_tutorial/features/auth/screens/login_screen.dart';
import 'package:reddit_tutorial/features/consumer/screens/add_consumer_screen.dart';
import 'package:reddit_tutorial/features/consumer/screens/remove_consumer_screen.dart';
import 'package:reddit_tutorial/features/favorite/screens/list_user_favorite_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/create_forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/edit_forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/list_user_forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/forum_tools_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/remove_forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/view_forum_screen.dart';
import 'package:reddit_tutorial/features/manager/screens/remove_manager_screen.dart';
import 'package:reddit_tutorial/features/manager/screens/add_manager_screen.dart';
import 'package:reddit_tutorial/features/registrant/screens/registrant_screen.dart';
import 'package:reddit_tutorial/features/rule/screens/add_rule_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/consume_policy_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/create_policy_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/edit_policy_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/list_user_policy_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/policy_tools_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/policy_screen.dart';
import 'package:reddit_tutorial/features/rule/screens/remove_rule_screen.dart';
import 'package:reddit_tutorial/features/registrant/screens/deregister_screen.dart';
import 'package:reddit_tutorial/features/registrant/screens/register_screen.dart';
import 'package:reddit_tutorial/features/home/screens/home_screen.dart';
import 'package:reddit_tutorial/features/service/screens/add_policy_screen.dart';
import 'package:reddit_tutorial/features/service/screens/create_service_screen.dart';
import 'package:reddit_tutorial/features/service/screens/edit_service_screen.dart';
import 'package:reddit_tutorial/features/service/screens/list_user_service_screen.dart';
import 'package:reddit_tutorial/features/service/screens/remove_policy_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_add_forum_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_remove_forum_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_tools_screen.dart';
import 'package:reddit_tutorial/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_tutorial/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: LoginScreen(),
      ),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(
        child: HomeScreen(),
      ),
  '/activity': (_) => const MaterialPage(
        child: ActivityScreen(),
      ),
  '/favorite': (_) => const MaterialPage(
        child: ListUserFavoriteScreen(),
      ),
  // **************************************************
  // Forum
  // **************************************************
  '/create-forum': (_) => const MaterialPage(
        child: CreateForumScreen(),
      ),
  '/forum/:forumid': (route) => MaterialPage(
        child: ForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/viewforum/:forumid': (route) => MaterialPage(
        child: ViewForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/addforum/:serviceid': (route) => MaterialPage(
        child: ServiceAddForumScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/viewforum/:forumid/registrant/:registrantid': (route) => MaterialPage(
        child: RegistrantScreen(
          registrantId: route.pathParameters['registrantid']!,
        ),
      ),
  '/viewforum/:forumid/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools': (route) => MaterialPage(
        child: ForumToolsScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/view': (route) => MaterialPage(
        child: ViewForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/view/registrant/:registrantid': (route) =>
      MaterialPage(
        child: RegistrantScreen(
          registrantId: route.pathParameters['registrantid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/view/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/register': (route) => MaterialPage(
        child: RegisterScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/deregister': (route) => MaterialPage(
        child: DeregisterScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/add-forum': (route) => MaterialPage(
        child: CreateForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/remove-forum': (route) => MaterialPage(
        child: RemoveForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/register/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/deregister/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/view': (route) => MaterialPage(
        child: ViewForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/view/registrant/:registrantid': (route) => MaterialPage(
        child: RegistrantScreen(
          registrantId: route.pathParameters['registrantid']!,
        ),
      ),
  '/forum/:forumid/view/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/register': (route) => MaterialPage(
        child: RegisterScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/register/service/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/deregister/service/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list': (_) => const MaterialPage(
        child: ListUserForumScreen(),
      ),
  '/user/forum/list/detail/:forumid': (route) => MaterialPage(
        child: ForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/forum-tools': (route) => MaterialPage(
        child: ForumToolsScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/forum-tools/register': (route) =>
      MaterialPage(
        child: RegisterScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/forum-tools/deregister': (route) =>
      MaterialPage(
        child: DeregisterScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/forum-tools/add-forum': (route) =>
      MaterialPage(
        child: CreateForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/forum-tools/remove-forum': (route) =>
      MaterialPage(
        child: RemoveForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/forum-tools/register/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/detail/:forumid/forum-tools/deregister/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/detail/:forumid/forum-tools/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/forum-tools/view': (route) => MaterialPage(
        child: ViewForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/forum-tools/view/registrant/:registrantid':
      (route) => MaterialPage(
            child: RegistrantScreen(
              registrantId: route.pathParameters['registrantid']!,
            ),
          ),
  '/user/forum/list/detail/:forumid/forum-tools/view/edit': (route) =>
      MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/register': (route) => MaterialPage(
        child: RegisterScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/view': (route) => MaterialPage(
        child: ViewForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/view/registrant/:registrantid': (route) =>
      MaterialPage(
        child: RegistrantScreen(
          registrantId: route.pathParameters['registrantid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/view/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/register/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list/detail/:forumid/deregister/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  // **************************************************
  // Policy
  // **************************************************
  '/create-policy': (_) => const MaterialPage(
        child: CreatePolicyScreen(),
      ),
  '/policy/:policyid': (route) => MaterialPage(
        child: PolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/consume': (route) => MaterialPage(
        child: ConsumePolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools': (route) => MaterialPage(
        child: PolicyToolsScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/add-manager': (route) => MaterialPage(
        child: AddManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/remove-manager': (route) => MaterialPage(
        child: RemoveManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/add-consumer': (route) => MaterialPage(
        child: AddConsumerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/remove-consumer': (route) => MaterialPage(
        child: RemoveConsumerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/register/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/edit': (route) => MaterialPage(
        child: EditPolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/add-rule': (route) => MaterialPage(
        child: AddRuleScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/remove-rule': (route) => MaterialPage(
        child: RemoveRuleScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/:uid': (route) => MaterialPage(
        child: UserProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/user/:uid/edit': (route) => MaterialPage(
        child: EditProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/user/policy/list': (_) => const MaterialPage(
        child: ListUserPolicyScreen(),
      ),
  '/user/policy/list/detail/:policyid': (route) => MaterialPage(
        child: PolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/consume': (route) => MaterialPage(
        child: ConsumePolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/policy-tools': (route) => MaterialPage(
        child: PolicyToolsScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/policy-tools/add-manager': (route) =>
      MaterialPage(
        child: AddManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/policy-tools/remove-manager': (route) =>
      MaterialPage(
        child: RemoveManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/policy-tools/add-consumer': (route) =>
      MaterialPage(
        child: AddConsumerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/policy-tools/remove-consumer': (route) =>
      MaterialPage(
        child: RemoveConsumerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/policy-tools/edit': (route) =>
      MaterialPage(
        child: EditPolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/policy-tools/add-rule': (route) =>
      MaterialPage(
        child: AddRuleScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/policy-tools/remove-rule': (route) =>
      MaterialPage(
        child: RemoveRuleScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/detail/:policyid/policy-tools/register/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  // **************************************************
  // Service
  // **************************************************
  '/create-service': (_) => const MaterialPage(
        child: CreateServiceScreen(),
      ),
  '/service/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/service/:serviceid/service-tools': (route) => MaterialPage(
        child: ServiceToolsScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/service/:serviceid/service-tools/edit': (route) => MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/service/:serviceid/service-tools/add-policy': (route) => MaterialPage(
        child: AddPolicyScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/service/:serviceid/service-tools/remove-policy': (route) => MaterialPage(
        child: RemovePolicyScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/service/:serviceid/service-tools/add-forum': (route) => MaterialPage(
        child: ServiceAddForumScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/service/:serviceid/service-tools/remove-forum': (route) => MaterialPage(
        child: ServiceRemoveForumScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list': (_) => const MaterialPage(
        child: ListUserServiceScreen(),
      ),
  '/user/service/list/detail/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/detail/:serviceid/service-tools': (route) => MaterialPage(
        child: ServiceToolsScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/detail/:serviceid/service-tools/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/detail/:serviceid/service-tools/add-policy': (route) =>
      MaterialPage(
        child: AddPolicyScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/detail/:serviceid/service-tools/remove-policy': (route) =>
      MaterialPage(
        child: RemovePolicyScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/detail/:serviceid/service-tools/add-forum': (route) =>
      MaterialPage(
        child: ServiceAddForumScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/detail/:serviceid/service-tools/remove-forum': (route) =>
      MaterialPage(
        child: ServiceRemoveForumScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  // **************************************************
  // Registrant
  // **************************************************
  '/registrant/:registrantid': (route) => MaterialPage(
        child: RegistrantScreen(
          registrantId: route.pathParameters['registrantid']!,
        ),
      ),
});
