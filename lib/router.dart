import 'package:flutter/material.dart';
import 'package:reddit_tutorial/features/auth/screens/login_screen.dart';
import 'package:reddit_tutorial/features/favorite/screens/list_user_favorite_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/create_forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/edit_forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/list_user_forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/forum_tools_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/remove_forum_screen.dart';
import 'package:reddit_tutorial/features/forum/screens/view_forum_screen.dart';
import 'package:reddit_tutorial/features/manager/screens/edit_manager_permissions_screen.dart';
import 'package:reddit_tutorial/features/manager/screens/manager_leave_screen.dart';
import 'package:reddit_tutorial/features/manager/screens/manager_permissions_screen.dart';
import 'package:reddit_tutorial/features/manager/screens/manager_screen.dart';
import 'package:reddit_tutorial/features/manager/screens/remove_manager_screen.dart';
import 'package:reddit_tutorial/features/manager/screens/add_manager_screen.dart';
import 'package:reddit_tutorial/features/member/screens/edit_member_permissions_screen.dart';
import 'package:reddit_tutorial/features/member/screens/member_leave_screen.dart';
import 'package:reddit_tutorial/features/member/screens/member_permissions_screen.dart';
import 'package:reddit_tutorial/features/member/screens/member_screen.dart';
import 'package:reddit_tutorial/features/consumer/screens/add_consumer_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/create_policy_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/edit_policy_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/list_user_policy_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/policy_tools_screen.dart';
import 'package:reddit_tutorial/features/policy/screens/policy_screen.dart';
import 'package:reddit_tutorial/features/consumer/screens/remove_consumer_screen.dart';
import 'package:reddit_tutorial/features/rule/screens/create_rule_screen.dart';
import 'package:reddit_tutorial/features/member/screens/remove_member_screen.dart';
import 'package:reddit_tutorial/features/member/screens/add_member_screen.dart';
import 'package:reddit_tutorial/features/home/screens/home_screen.dart';
import 'package:reddit_tutorial/features/rule/screens/edit_rule_screen.dart';
import 'package:reddit_tutorial/features/rule/screens/remove_rule_screen.dart';
import 'package:reddit_tutorial/features/rule/screens/rule_screen.dart';
import 'package:reddit_tutorial/features/rule/screens/rule_tools_screen.dart';
import 'package:reddit_tutorial/features/rule_member/screens/add_rule_member_screen.dart';
import 'package:reddit_tutorial/features/rule_member/screens/edit_rule_member_permissions_screen.dart';
import 'package:reddit_tutorial/features/rule_member/screens/rule_member_permissions_screen.dart';
import 'package:reddit_tutorial/features/rule_member/screens/remove_rule_member_screen.dart';
import 'package:reddit_tutorial/features/service/screens/add_policy_screen.dart';
import 'package:reddit_tutorial/features/service/screens/create_service_screen.dart';
import 'package:reddit_tutorial/features/service/screens/edit_service_screen.dart';
import 'package:reddit_tutorial/features/service/screens/list_user_service_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_remove_policy_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_add_forum_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_likes_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_remove_forum_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_tools_screen.dart';
import 'package:reddit_tutorial/features/service/screens/service_user_profile_screen.dart';
import 'package:reddit_tutorial/features/shopping_cart/screens/add_to_cart_screen.dart';
import 'package:reddit_tutorial/features/shopping_cart/screens/view_cart_screen.dart';
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
  '/viewcart': (_) => const MaterialPage(
        child: ViewCartScreen(),
      ),
  // **************************************************
  // Favorite
  // **************************************************
  '/favorite': (_) => const MaterialPage(
        child: ListUserFavoriteScreen(),
      ),
  '/favorite/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/favorite/:serviceid/edit': (route) => MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/favorite/:serviceid/add-to-cart': (route) => MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  // **************************************************
  // ViewForum / AddForum
  // **************************************************
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
  '/viewforum/:forumid/member/:memberid': (route) => MaterialPage(
        child: MemberScreen(
          memberId: route.pathParameters['memberid']!,
        ),
      ),
  '/viewforum/:forumid/member/:memberid/add-to-cart/:serviceid': (route) =>
      MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/viewforum/:forumid/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
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
  '/forum/:forumid/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/leave-forum': (route) => MaterialPage(
        child: MemberLeaveScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/leave-forum/service/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/leave-forum/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/leave-forum/service/:serviceid/add-to-cart': (route) =>
      MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/forum-tools': (route) => MaterialPage(
        child: ForumToolsScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/add-member': (route) => MaterialPage(
        child: AddMemberScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/remove-member': (route) => MaterialPage(
        child: RemoveMemberScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/add-member/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/add-member/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/add-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/forum/:forumid/forum-tools/add-member/service/:serviceid/likes': (route) =>
      MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/add-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/forum/:forumid/forum-tools/remove-member/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/remove-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/forum/:forumid/forum-tools/remove-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/forum/:forumid/forum-tools/remove-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/forum/:forumid/forum-tools/remove-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
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
  '/forum/:forumid/forum-tools/member-permissions': (route) => MaterialPage(
        child: MemberPermissionsScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/member-permissions/edit/:memberid': (route) =>
      MaterialPage(
        child: EditMemberPermissionsScreen(
          forumId: route.pathParameters['forumid']!,
          memberId: route.pathParameters['memberid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/member-permissions/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/forum/:forumid/forum-tools/member-permissions/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/forum/:forumid/forum-tools/member-permissions/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/forum/:forumid/forum-tools/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/view': (route) => MaterialPage(
        child: ViewForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/view/member/:memberid': (route) => MaterialPage(
        child: MemberScreen(
          memberId: route.pathParameters['memberid']!,
        ),
      ),
  '/forum/:forumid/forum-tools/view/member/:memberid/add-to-cart/:serviceid':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/forum/:forumid/forum-tools/view/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/add-member': (route) => MaterialPage(
        child: AddMemberScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/remove-member': (route) => MaterialPage(
        child: RemoveMemberScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/add-member/service/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/add-member/service/:serviceid/edit': (route) => MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/add-member/service/:serviceid/add-to-cart': (route) =>
      MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/add-member/service/:serviceid/likes': (route) =>
      MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/add-member/service/:serviceid/likes/:uid': (route) =>
      MaterialPage(
        child: ServiceUserProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/forum/:forumid/remove-member/service/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/remove-member/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/remove-member/service/:serviceid/add-to-cart': (route) =>
      MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/remove-member/service/:serviceid/likes': (route) =>
      MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/remove-member/service/:serviceid/likes/:uid': (route) =>
      MaterialPage(
        child: ServiceUserProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/forum/:forumid/view': (route) => MaterialPage(
        child: ViewForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/forum/:forumid/view/member/:memberid': (route) => MaterialPage(
        child: MemberScreen(
          memberId: route.pathParameters['memberid']!,
        ),
      ),
  '/forum/:forumid/view/member/:memberid/add-to-cart/:serviceid': (route) =>
      MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/forum/:forumid/view/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list': (_) => const MaterialPage(
        child: ListUserForumScreen(),
      ),
  '/user/forum/list/:forumid': (route) => MaterialPage(
        child: ForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/leave-forum': (route) => MaterialPage(
        child: MemberLeaveScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/leave-forum/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list/:forumid/leave-forum/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list/:forumid/leave-forum/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools': (route) => MaterialPage(
        child: ForumToolsScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/forum-tools/add-member': (route) => MaterialPage(
        child: AddMemberScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/forum-tools/remove-member': (route) =>
      MaterialPage(
        child: RemoveMemberScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/forum-tools/add-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/add-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/add-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/add-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/add-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/remove-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/remove-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/remove-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/remove-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/remove-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/add-forum': (route) => MaterialPage(
        child: CreateForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/forum-tools/remove-forum': (route) => MaterialPage(
        child: RemoveForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/forum-tools/member-permissions': (route) =>
      MaterialPage(
        child: MemberPermissionsScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/forum-tools/member-permissions/edit/:memberid':
      (route) => MaterialPage(
            child: EditMemberPermissionsScreen(
              forumId: route.pathParameters['forumid']!,
              memberId: route.pathParameters['memberid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/member-permissions/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/member-permissions/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/member-permissions/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/forum-tools/view': (route) => MaterialPage(
        child: ViewForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/forum-tools/view/member/:memberid': (route) =>
      MaterialPage(
        child: MemberScreen(
          memberId: route.pathParameters['memberid']!,
        ),
      ),
  '/user/forum/list/:forumid/forum-tools/view/member/:memberid/add-to-cart/:serviceid':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/forum-tools/view/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/add-member': (route) => MaterialPage(
        child: AddMemberScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/remove-member': (route) => MaterialPage(
        child: RemoveMemberScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/add-member/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list/:forumid/add-member/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list/:forumid/add-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/add-member/service/:serviceid/likes': (route) =>
      MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list/:forumid/add-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/forum/list/:forumid/remove-member/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list/:forumid/remove-member/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list/:forumid/remove-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/remove-member/service/:serviceid/likes': (route) =>
      MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/forum/list/:forumid/remove-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/forum/list/:forumid/view': (route) => MaterialPage(
        child: ViewForumScreen(
          forumId: route.pathParameters['forumid']!,
        ),
      ),
  '/user/forum/list/:forumid/view/member/:memberid': (route) => MaterialPage(
        child: MemberScreen(
          memberId: route.pathParameters['memberid']!,
        ),
      ),
  '/user/forum/list/:forumid/view/member/:memberid/add-to-cart/:serviceid':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/forum/list/:forumid/view/edit': (route) => MaterialPage(
        child: EditForumScreen(
          forumId: route.pathParameters['forumid']!,
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
  '/policy/:policyid/edit': (route) => MaterialPage(
        child: EditPolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/rule/:ruleid': (route) => MaterialPage(
        child: RuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule/:ruleid/edit': (route) => MaterialPage(
        child: EditRuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule/:ruleid/rule-tools': (route) => MaterialPage(
        child: RuleToolsScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule/:ruleid/rule-tools/edit': (route) => MaterialPage(
        child: EditRuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule/:ruleid/rule-tools/rule-member-permissions':
      (route) => MaterialPage(
            child: RuleMemberPermissionsScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/rule-member-permissions/edit/:rulememberid':
      (route) => MaterialPage(
            child: EditRuleMemberPermissionsScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
              ruleMemberId: route.pathParameters['rulememberid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/add-rule-member': (route) =>
      MaterialPage(
        child: AddRuleMemberScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule/:ruleid/rule-tools/remove-rule-member': (route) =>
      MaterialPage(
        child: RemoveRuleMemberScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid': (route) => MaterialPage(
        child: RuleToolsScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule-tools/:ruleid/edit': (route) => MaterialPage(
        child: EditRuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule-tools/:ruleid/add-rule-member': (route) =>
      MaterialPage(
        child: AddRuleMemberScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule-tools/:ruleid/remove-rule-member': (route) =>
      MaterialPage(
        child: RemoveRuleMemberScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/rule-tools/:ruleid/add-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid/add-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid/add-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid/add-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid/add-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid/remove-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid/remove-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid/remove-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid/remove-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/rule-tools/:ruleid/remove-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/policy/:policyid/leave-policy': (route) => MaterialPage(
        child: ManagerLeaveScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/leave-policy/service/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/leave-policy/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/leave-policy/service/:serviceid/add-to-cart': (route) =>
      MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/add-consumer': (route) => MaterialPage(
        child: AddConsumerScreen(
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
  '/policy/:policyid/policy-tools/add-manager/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/add-manager/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/add-manager/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/add-manager/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/add-manager/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-manager/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/remove-manager/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-manager/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-manager/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-manager/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/edit': (route) => MaterialPage(
        child: EditPolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/add-manager': (route) => MaterialPage(
        child: AddManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/remove-manager': (route) => MaterialPage(
        child: RemoveManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/add-manager/service/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/add-manager/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/add-manager/service/:serviceid/add-to-cart': (route) =>
      MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/add-manager/service/:serviceid/likes': (route) =>
      MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/add-manager/service/:serviceid/likes/:uid': (route) =>
      MaterialPage(
        child: ServiceUserProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/policy/:policyid/remove-manager/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/remove-manager/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/remove-manager/service/:serviceid/add-to-cart': (route) =>
      MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/remove-manager/service/:serviceid/likes': (route) =>
      MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/policy/:policyid/remove-manager/service/:serviceid/likes/:uid': (route) =>
      MaterialPage(
        child: ServiceUserProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/create-rule': (route) => MaterialPage(
        child: CreateRuleScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/remove-rule': (route) => MaterialPage(
        child: RemoveRuleScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid': (route) => MaterialPage(
        child: RuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/edit': (route) =>
      MaterialPage(
        child: EditRuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools': (route) =>
      MaterialPage(
        child: RuleToolsScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/edit':
      (route) => MaterialPage(
            child: EditRuleScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions':
      (route) => MaterialPage(
            child: RuleMemberPermissionsScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions/edit/:rulememberid':
      (route) => MaterialPage(
            child: EditRuleMemberPermissionsScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
              ruleMemberId: route.pathParameters['rulememberid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member':
      (route) => MaterialPage(
            child: AddRuleMemberScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member':
      (route) => MaterialPage(
            child: RemoveRuleMemberScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/manager-permissions': (route) => MaterialPage(
        child: ManagerPermissionsScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/policy/:policyid/policy-tools/manager-permissions/edit/:managerid':
      (route) => MaterialPage(
            child: EditManagerPermissionsScreen(
              policyId: route.pathParameters['policyid']!,
              managerId: route.pathParameters['managerid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/manager-permissions/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/manager-permissions/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/policy/:policyid/policy-tools/manager-permissions/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list': (_) => const MaterialPage(
        child: ListUserPolicyScreen(),
      ),
  '/user/policy/list/:policyid': (route) => MaterialPage(
        child: PolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/edit': (route) => MaterialPage(
        child: EditPolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/rule/:ruleid': (route) => MaterialPage(
        child: RuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/user/policy/list/:policyid/rule/:ruleid/edit': (route) => MaterialPage(
        child: EditRuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools': (route) =>
      MaterialPage(
        child: RuleToolsScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/edit': (route) =>
      MaterialPage(
        child: EditRuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/rule-member-permissions':
      (route) => MaterialPage(
            child: RuleMemberPermissionsScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/rule-member-permissions/edit/:rulememberid':
      (route) => MaterialPage(
            child: EditRuleMemberPermissionsScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
              ruleMemberId: route.pathParameters['rulememberid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/add-rule-member':
      (route) => MaterialPage(
            child: AddRuleMemberScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/remove-rule-member':
      (route) => MaterialPage(
            child: RemoveRuleMemberScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/policy/list/:policyid/leave-policy': (route) => MaterialPage(
        child: ManagerLeaveScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/leave-policy/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/policy/list/:policyid/leave-policy/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/policy/list/:policyid/leave-policy/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/add-consumer': (route) => MaterialPage(
        child: AddConsumerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools': (route) => MaterialPage(
        child: PolicyToolsScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools/add-consumer': (route) =>
      MaterialPage(
        child: AddConsumerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools/remove-consumer': (route) =>
      MaterialPage(
        child: RemoveConsumerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools/edit': (route) => MaterialPage(
        child: EditPolicyScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools/create-rule': (route) =>
      MaterialPage(
        child: CreateRuleScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools/remove-rule': (route) =>
      MaterialPage(
        child: RemoveRuleScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid': (route) =>
      MaterialPage(
        child: RuleScreen(
          policyId: route.pathParameters['policyid']!,
          ruleId: route.pathParameters['ruleid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/edit':
      (route) => MaterialPage(
            child: EditRuleScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools':
      (route) => MaterialPage(
            child: RuleToolsScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/edit':
      (route) => MaterialPage(
            child: EditRuleScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions':
      (route) => MaterialPage(
            child: RuleMemberPermissionsScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions/edit/:rulememberid':
      (route) => MaterialPage(
            child: EditRuleMemberPermissionsScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
              ruleMemberId: route.pathParameters['rulememberid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/rule-member-permissions/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member':
      (route) => MaterialPage(
            child: AddRuleMemberScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member':
      (route) => MaterialPage(
            child: RemoveRuleMemberScreen(
              policyId: route.pathParameters['policyid']!,
              ruleId: route.pathParameters['ruleid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/add-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-rule/:ruleid/rule-tools/remove-rule-member/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/add-manager': (route) =>
      MaterialPage(
        child: AddManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools/remove-manager': (route) =>
      MaterialPage(
        child: RemoveManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/policy-tools/add-manager/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/add-manager/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/add-manager/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/add-manager/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/add-manager/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-manager/service/:serviceid':
      (route) => MaterialPage(
            child: ServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-manager/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-manager/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-manager/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/policy-tools/remove-manager/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/policy/list/:policyid/add-manager': (route) => MaterialPage(
        child: AddManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/remove-manager': (route) => MaterialPage(
        child: RemoveManagerScreen(
          policyId: route.pathParameters['policyid']!,
        ),
      ),
  '/user/policy/list/:policyid/add-manager/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/policy/list/:policyid/add-manager/service/:serviceid/edit': (route) =>
      MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/policy/list/:policyid/add-manager/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/add-manager/service/:serviceid/likes': (route) =>
      MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/policy/list/:policyid/add-manager/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
            ),
          ),
  '/user/policy/list/:policyid/remove-manager/service/:serviceid': (route) =>
      MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/policy/list/:policyid/remove-manager/service/:serviceid/edit':
      (route) => MaterialPage(
            child: EditServiceScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/remove-manager/service/:serviceid/add-to-cart':
      (route) => MaterialPage(
            child: AddToCartScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/remove-manager/service/:serviceid/likes':
      (route) => MaterialPage(
            child: ServiceLikesScreen(
              serviceId: route.pathParameters['serviceid']!,
            ),
          ),
  '/user/policy/list/:policyid/remove-manager/service/:serviceid/likes/:uid':
      (route) => MaterialPage(
            child: ServiceUserProfileScreen(
              uid: route.pathParameters['uid']!,
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
  '/service/:serviceid/edit': (route) => MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/service/:serviceid/add-to-cart': (route) => MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/service/:serviceid/likes': (route) => MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/service/:serviceid/likes/:uid': (route) => MaterialPage(
        child: ServiceUserProfileScreen(
          uid: route.pathParameters['uid']!,
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
        child: ServiceRemovePolicyScreen(
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
  '/user/service/list/:serviceid': (route) => MaterialPage(
        child: ServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/:serviceid/edit': (route) => MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/:serviceid/add-to-cart': (route) => MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/:serviceid/likes': (route) => MaterialPage(
        child: ServiceLikesScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/:serviceid/likes/:uid': (route) => MaterialPage(
        child: ServiceUserProfileScreen(
          uid: route.pathParameters['uid']!,
        ),
      ),
  '/user/service/list/:serviceid/service-tools': (route) => MaterialPage(
        child: ServiceToolsScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/:serviceid/service-tools/edit': (route) => MaterialPage(
        child: EditServiceScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/:serviceid/service-tools/add-policy': (route) =>
      MaterialPage(
        child: AddPolicyScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/:serviceid/service-tools/remove-policy': (route) =>
      MaterialPage(
        child: ServiceRemovePolicyScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/:serviceid/service-tools/add-forum': (route) =>
      MaterialPage(
        child: ServiceAddForumScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  '/user/service/list/:serviceid/service-tools/remove-forum': (route) =>
      MaterialPage(
        child: ServiceRemoveForumScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  // **************************************************
  // Member
  // **************************************************
  '/member/:memberid': (route) => MaterialPage(
        child: MemberScreen(
          memberId: route.pathParameters['memberid']!,
        ),
      ),
  '/member/:memberid/add-to-cart/:serviceid': (route) => MaterialPage(
        child: AddToCartScreen(
          serviceId: route.pathParameters['serviceid']!,
        ),
      ),
  // **************************************************
  // Manager
  // **************************************************
  '/manager/:managerid': (route) => MaterialPage(
        child: ManagerScreen(
          managerId: route.pathParameters['managerid']!,
        ),
      ),
  // **************************************************
  // User
  // **************************************************
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
});
