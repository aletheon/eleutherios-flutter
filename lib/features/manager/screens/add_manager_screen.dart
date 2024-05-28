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
import 'package:reddit_tutorial/features/manager/delegates/search_manager_delegate.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/favorite.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

final searchRadioProvider = StateProvider<String>((ref) => 'Private');

class AddManagerScreen extends ConsumerStatefulWidget {
  final String policyId;
  const AddManagerScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddManagerScreenState();
}

class _AddManagerScreenState extends ConsumerState<AddManagerScreen> {
  final GlobalKey _scaffold = GlobalKey();

  void addManagerService(WidgetRef ref, String policyId, String serviceId) {
    ref
        .read(managerControllerProvider.notifier)
        .createManager(policyId, serviceId, _scaffold.currentContext!);
  }

  void viewPolicy(WidgetRef ref, BuildContext context) {
    Routemaster.of(context).push('view');
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('service/$serviceId');
  }

  Widget showServiceList(WidgetRef ref, Policy policy, List<Service>? services,
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
                    addManagerService(ref, policy.policyId, service.serviceId),
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
                        onPressed: () => addManagerService(
                            ref, policy.policyId, service.serviceId),
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

  Widget showServices(WidgetRef ref, Policy policy, String searchType) {
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
            if (policy.managers.isEmpty) {
              return showServiceList(ref, policy, services, null);
            } else {
              List<Service> servicesNotInPolicy = [];
              for (var service in services) {
                bool foundService = false;
                for (String serviceId in policy.services) {
                  if (service.serviceId == serviceId) {
                    foundService = true;
                    break;
                  }
                }

                if (foundService == false) {
                  servicesNotInPolicy.add(service);
                }
              }

              if (servicesNotInPolicy.isNotEmpty) {
                return showServiceList(ref, policy, servicesNotInPolicy, null);
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('All of your services are in the policy'),
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
            if (policy.managers.isEmpty) {
              return showServiceList(ref, policy, services, null);
            } else {
              List<Service> servicesNotInPolicy = [];
              for (var service in services) {
                bool foundService = false;
                for (String serviceId in policy.services) {
                  if (service.serviceId == serviceId) {
                    foundService = true;
                    break;
                  }
                }

                if (foundService == false) {
                  servicesNotInPolicy.add(service);
                }
              }

              if (servicesNotInPolicy.isNotEmpty) {
                return showServiceList(ref, policy, servicesNotInPolicy, null);
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('All public services are in the policy'),
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
            if (policy.managers.isEmpty) {
              return showServiceList(ref, policy, null, favorites);
            } else {
              List<Favorite> favoritesNotInPolicy = [];
              for (var favorite in favorites) {
                bool foundService = false;
                for (String serviceId in policy.services) {
                  if (favorite.serviceId == serviceId) {
                    foundService = true;
                    break;
                  }
                }

                if (foundService == false) {
                  favoritesNotInPolicy.add(favorite);
                }
              }

              if (favoritesNotInPolicy.isNotEmpty) {
                return showServiceList(ref, policy, null, favoritesNotInPolicy);
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('All of your favorites are in the policy'),
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
    final policy =
        await ref.read(getPolicyByIdProvider2(widget.policyId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (policy!.uid != user.uid) {
      if (manager!.permissions.contains(ManagerPermissions.addmanager.name) ==
          false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to add a manager to this policy');
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
    final isLoading = ref.watch(managerControllerProvider);
    final policyProv = ref.watch(getPolicyByIdProvider(widget.policyId));
    final searchRadioProv = ref.watch(searchRadioProvider.notifier).state;
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return policyProv.when(
      data: (policy) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Add Manager',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: isLoading
              ? const Loader()
              : Column(
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
                              delegate: SearchManagerDelegate(
                                  ref,
                                  user,
                                  widget.policyId,
                                  ref
                                              .read(
                                                  searchRadioProvider.notifier)
                                              .state ==
                                          "Favorite"
                                      ? "Private"
                                      : ref
                                          .read(searchRadioProvider.notifier)
                                          .state),
                            );
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ],
                    ),
                    showServices(ref, policy!, searchRadioProv)
                  ],
                ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
