import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class SearchHomeDelegate extends SearchDelegate {
  final WidgetRef ref;
  SearchHomeDelegate(this.ref);

  String _searchType = SearchType.forum.value;

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push('/policy/$policyId');
  }

  void showForumDetails(BuildContext context, String forumId) {
    Routemaster.of(context).push('/forum/$forumId');
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('/service/$serviceId');
  }

  void changeSearchType(String searchType) {
    _searchType = searchType;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => changeSearchType(SearchType.policy.value),
        icon: _searchType == SearchType.policy.value
            ? Icon(
                Icons.account_balance,
                color: Pallete.policyColor,
              )
            : const Icon(Icons.account_balance),
      ),
      IconButton(
        onPressed: () => changeSearchType(SearchType.forum.value),
        icon: _searchType == SearchType.forum.value
            ? Icon(
                Icons.sms,
                color: Pallete.forumColor,
              )
            : const Icon(Icons.sms),
      ),
      IconButton(
        onPressed: () => changeSearchType(SearchType.service.value),
        icon: _searchType == SearchType.service.value
            ? Icon(
                Icons.construction,
                color: Pallete.freeServiceColor,
              )
            : const Icon(Icons.construction),
      ),
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (_searchType == SearchType.policy.value) {
      return ref.watch(searchPoliciesProvider(query.toLowerCase())).when(
            data: (policies) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: policies.length,
                  itemBuilder: (BuildContext context, int index) {
                    final policy = policies[index];
                    return ListTile(
                      leading: policy.image == Constants.avatarDefault
                          ? CircleAvatar(
                              backgroundImage: Image.asset(policy.image).image,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(policy.image),
                            ),
                      title: Text(policy.title),
                      onTap: () => showPolicyDetails(context, policy.policyId),
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              print(error.toString());
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          );
    } else if (_searchType == SearchType.forum.value) {
      return ref.watch(searchForumsProvider(query.toLowerCase())).when(
            data: (forums) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: forums.length,
                  itemBuilder: (BuildContext context, int index) {
                    final forum = forums[index];
                    return ListTile(
                      leading: forum.image == Constants.avatarDefault
                          ? CircleAvatar(
                              backgroundImage: Image.asset(forum.image).image,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(forum.image),
                            ),
                      title: Text(forum.title),
                      onTap: () => showForumDetails(context, forum.forumId),
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              print(error.toString());
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          );
    } else {
      return ref.watch(searchServicesProvider(query.toLowerCase())).when(
            data: (services) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (BuildContext context, int index) {
                    final service = services[index];
                    return ListTile(
                      leading: service.image == Constants.avatarDefault
                          ? CircleAvatar(
                              backgroundImage: Image.asset(service.image).image,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(service.image),
                            ),
                      title: Text(service.title),
                      onTap: () =>
                          showServiceDetails(context, service.serviceId),
                    );
                  },
                ),
              );
            },
            error: (error, stackTrace) {
              print(error.toString());
              return ErrorText(error: error.toString());
            },
            loading: () => const Loader(),
          );
    }
  }
}
