import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/favorite/controller/favorite_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/features/rule_member/controller/rule_member_controller.dart';
import 'package:reddit_tutorial/features/rule_member/delegates/search_rule_member_delegate.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/favorite.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

final searchRadioProvider = StateProvider<String>((ref) => 'Private');

class AddRuleMemberScreen extends ConsumerStatefulWidget {
  final String policyId;
  final String ruleId;
  const AddRuleMemberScreen(
      {super.key, required this.policyId, required this.ruleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddRuleMemberScreenState();
}

class _AddRuleMemberScreenState extends ConsumerState<AddRuleMemberScreen> {
  final GlobalKey _scaffold = GlobalKey();

  void addRuleMemberService(WidgetRef ref, String ruleId, String serviceId) {
    ref
        .read(ruleMemberControllerProvider.notifier)
        .createRuleMember(ruleId, serviceId, _scaffold.currentContext!);
  }

  void viewRule(WidgetRef ref, BuildContext context) {
    Routemaster.of(context).push('view');
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  Widget showServiceList(WidgetRef ref, Rule rule, List<Service>? services,
      List<Favorite>? favorites) {
    if (services != null) {
      return Expanded(
        child: ListView.builder(
          itemCount: services.length,
          itemBuilder: (BuildContext context, int index) {
            final service = services[index];
            return ListTile(
              title: Text(service.title),
              leading: service.image == Constants.avatarDefault
                  ? CircleAvatar(
                      backgroundImage: Image.asset(service.image).image,
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(service.image),
                    ),
              trailing: TextButton(
                onPressed: () =>
                    addRuleMemberService(ref, rule.ruleId, service.serviceId),
                child: const Text(
                  'Add',
                ),
              ),
              onTap: () => showServiceDetails(context, service.serviceId),
            );
          },
        ),
      );
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: favorites!.length,
          itemBuilder: (BuildContext context, int index) {
            final favorite = favorites[index];
            return ref.watch(getServiceByIdProvider(favorite.serviceId)).when(
                  data: (service) {
                    return ListTile(
                      title: Text(service!.title),
                      leading: service.image == Constants.avatarDefault
                          ? CircleAvatar(
                              backgroundImage: Image.asset(service.image).image,
                            )
                          : CircleAvatar(
                              backgroundImage: NetworkImage(service.image),
                            ),
                      trailing: TextButton(
                        onPressed: () => addRuleMemberService(
                            ref, rule.ruleId, service.serviceId),
                        child: const Text(
                          'Add',
                        ),
                      ),
                      onTap: () =>
                          showServiceDetails(context, service.serviceId),
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                );
          },
        ),
      );
    }
  }

  Widget showServices(WidgetRef ref, Rule rule, String searchType) {
    final userFavoritesProv = ref.watch(userFavoritesProvider);
    final userServicesProv = ref.watch(userServicesProvider);
    final servicesProv = ref.watch(servicesProvider);
    final user = ref.watch(userProvider)!;

    if (searchType == "Private") {
      if (user.services.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("You haven't created any services"),
          ),
        );
      } else {
        return userServicesProv.when(
          data: (services) {
            if (rule.members.isEmpty) {
              return showServiceList(ref, rule, services, null);
            } else {
              List<Service> servicesNotInRule = [];
              for (var service in services) {
                bool foundService = false;
                for (String serviceId in rule.services) {
                  if (service.serviceId == serviceId) {
                    foundService = true;
                    break;
                  }
                }

                if (foundService == false) {
                  servicesNotInRule.add(service);
                }
              }

              if (servicesNotInRule.isNotEmpty) {
                return showServiceList(ref, rule, servicesNotInRule, null);
              } else {
                return Container(
                  alignment: Alignment.topCenter,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('All of your services are in the rule'),
                  ),
                );
              }
            }
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
      }
    } else if (searchType == "Public") {
      return servicesProv.when(
        data: (services) {
          if (services.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("There are no publc services"),
              ),
            );
          } else {
            if (rule.members.isEmpty) {
              return showServiceList(ref, rule, services, null);
            } else {
              List<Service> servicesNotInRule = [];
              for (var service in services) {
                bool foundService = false;
                for (String serviceId in rule.services) {
                  if (service.serviceId == serviceId) {
                    foundService = true;
                    break;
                  }
                }

                if (foundService == false) {
                  servicesNotInRule.add(service);
                }
              }

              if (servicesNotInRule.isNotEmpty) {
                return showServiceList(ref, rule, servicesNotInRule, null);
              } else {
                return Container(
                  alignment: Alignment.topCenter,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('All public services are in the rule'),
                  ),
                );
              }
            }
          }
        },
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader(),
      );
    } else {
      if (user.favorites.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("You don't have any favorites"),
          ),
        );
      } else {
        return userFavoritesProv.when(
          data: (favorites) {
            if (rule.members.isEmpty) {
              return showServiceList(ref, rule, null, favorites);
            } else {
              List<Favorite> favoritesNotInRule = [];
              for (var favorite in favorites) {
                bool foundService = false;
                for (String serviceId in rule.services) {
                  if (favorite.serviceId == serviceId) {
                    foundService = true;
                    break;
                  }
                }

                if (foundService == false) {
                  favoritesNotInRule.add(favorite);
                }
              }

              if (favoritesNotInRule.isNotEmpty) {
                return showServiceList(ref, rule, null, favoritesNotInRule);
              } else {
                return Container(
                  alignment: Alignment.topCenter,
                  child: const Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text('All of your favorites are in the rule'),
                  ),
                );
              }
            }
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
      }
    }
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final rule = await ref.read(getRuleByIdProvider2(widget.ruleId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (rule!.uid != user.uid) {
      if (manager!.permissions
              .contains(ManagerPermissions.addpotentialmember.name) ==
          false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to add a member to this rule');
          Routemaster.of(context).pop();
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ruleProv = ref.watch(getRuleByIdProvider(widget.ruleId));
    final searchRadioProv = ref.watch(searchRadioProvider.notifier).state;
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return ruleProv.when(
      data: (rule) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Add Potential Member',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
            // actions: [
            //   user.forumActivities
            //           .where((a) => a == widget._forumId)
            //           .toList()
            //           .isNotEmpty
            //       ? IconButton(
            //           onPressed: () => viewForum(ref, context),
            //           icon: const Icon(Icons.exit_to_app))
            //       : const SizedBox(),
            // ],
          ),
          body: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("Private"),
                  Radio(
                      value: "Private",
                      groupValue: searchRadioProv,
                      onChanged: (newValue) {
                        ref.read(searchRadioProvider.notifier).state =
                            newValue.toString();
                      }),
                  const Text("Public"),
                  Radio(
                      value: "Public",
                      groupValue: searchRadioProv,
                      onChanged: (newValue) {
                        ref.read(searchRadioProvider.notifier).state =
                            newValue.toString();
                      }),
                  const Text("Favorite"),
                  Radio(
                      value: "Favorite",
                      groupValue: searchRadioProv,
                      onChanged: (newValue) {
                        ref.read(searchRadioProvider.notifier).state =
                            newValue.toString();
                      }),
                  IconButton(
                    onPressed: () {
                      showSearch(
                        context: context,
                        delegate: SearchRuleMemberDelegate(
                            ref,
                            user,
                            widget.ruleId,
                            ref.read(searchRadioProvider.notifier).state ==
                                    "Favorite"
                                ? "Private"
                                : ref.read(searchRadioProvider.notifier).state),
                      );
                    },
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              showServices(ref, rule!, searchRadioProv)
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
