import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/consumer/delegates/search_consumer_delegate.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

final searchRadioProvider = StateProvider<String>((ref) => 'Private');

class AddConsumerScreen extends ConsumerStatefulWidget {
  final String policyId;
  const AddConsumerScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddConsumerScreenState();
}

class _AddConsumerScreenState extends ConsumerState<AddConsumerScreen> {
  final GlobalKey _scaffold = GlobalKey();

  void addPolicyToService(WidgetRef ref, String serviceId) {
    ref.read(policyControllerProvider.notifier).addPolicyToService(
        serviceId, widget.policyId, _scaffold.currentContext!);
  }

  void showServiceDetails(BuildContext context, String serviceId) {
    Routemaster.of(context).push('/service/$serviceId');
  }

  Widget showServiceList(WidgetRef ref, List<Service> services) {
    return Expanded(
      child: ListView.builder(
        itemCount: services.length,
        itemBuilder: (BuildContext context, int index) {
          final service = services[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ListTile(
                title: Row(
                  children: [
                    Text(service.title),
                    const SizedBox(
                      width: 5,
                    ),
                    service.public
                        ? const Icon(
                            Icons.lock_open_outlined,
                            size: 18,
                          )
                        : const Icon(Icons.lock_outlined,
                            size: 18, color: Pallete.greyColor),
                  ],
                ),
                leading: service.image == Constants.avatarDefault
                    ? CircleAvatar(
                        backgroundImage: Image.asset(service.image).image,
                      )
                    : CircleAvatar(
                        backgroundImage: NetworkImage(service.image),
                      ),
                trailing: TextButton(
                  onPressed: () => addPolicyToService(ref, service.serviceId),
                  child: const Text(
                    'Add',
                  ),
                ),
                onTap: () => showServiceDetails(context, service.serviceId),
              ),
              service.tags.isNotEmpty
                  ? Padding(
                      padding:
                          const EdgeInsets.only(top: 0, right: 20, left: 10),
                      child: Wrap(
                        alignment: WrapAlignment.end,
                        direction: Axis.horizontal,
                        children: service.tags.map((e) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: FilterChip(
                              visualDensity: const VisualDensity(
                                  vertical: -4, horizontal: -4),
                              onSelected: (value) {},
                              backgroundColor: service.price == -1
                                  ? Pallete.freeServiceTagColor
                                  : Pallete.paidServiceTagColor,
                              label: Text(
                                '#$e',
                                style: const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  Widget showServices(WidgetRef ref, Policy policy, String searchType) {
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
          data: (userServices) {
            if (policy.consumers.isEmpty) {
              return showServiceList(ref, userServices);
            } else {
              List<Service> servicesNotInPolicy = [];
              for (Service s in userServices) {
                bool result = false;
                for (String p in s.policies) {
                  if (p == policy.policyId) {
                    result = true;
                    break;
                  }
                }
                if (result == false) {
                  servicesNotInPolicy.add(s);
                }
              }

              if (servicesNotInPolicy.isNotEmpty) {
                return showServiceList(ref, servicesNotInPolicy);
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
    } else {
      return servicesProv.when(
        data: (services) {
          if (services.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("There are no public services"),
              ),
            );
          } else {
            List<Service> servicesNotInPolicy = [];
            for (Service s in services) {
              bool result = false;
              for (String p in s.policies) {
                if (p == policy.policyId) {
                  result = true;
                  break;
                }
              }
              if (result == false) {
                servicesNotInPolicy.add(s);
              }
            }

            if (servicesNotInPolicy.isNotEmpty) {
              return showServiceList(ref, servicesNotInPolicy);
            } else {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('All public services are in the policy'),
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

  validateUser() async {
    final user = ref.read(userProvider)!;
    final policy =
        await ref.read(getPolicyByIdProvider2(widget.policyId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (policy != null) {
      if (policy.uid != user.uid) {
        if (manager != null) {
          if (manager.permissions
                  .contains(ManagerPermissions.addconsumer.value) ==
              false) {
            Future.delayed(Duration.zero, () {
              showSnackBar(
                  context,
                  'You do not have permission to add a consumer to this policy',
                  true);
              Routemaster.of(context).pop();
            });
          }
        } else {
          Future.delayed(Duration.zero, () {
            showSnackBar(context, 'Manager does not exist', true);
            Routemaster.of(context).pop();
          });
        }
      }
    } else {
      Future.delayed(Duration.zero, () {
        showSnackBar(context, 'Policy does not exist', true);
        Routemaster.of(context).pop();
      });
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
    final isLoading = ref.watch(policyControllerProvider);
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
              'Add Consumer',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: Stack(
            children: <Widget>[
              Column(
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
                      IconButton(
                        onPressed: () {
                          showSearch(
                            context: context,
                            delegate: SearchConsumerDelegate(ref, user, policy!,
                                ref.read(searchRadioProvider.notifier).state),
                          );
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  showServices(ref, policy!, searchRadioProv)
                ],
              ),
              Container(
                child: isLoading ? const Loader() : Container(),
              )
            ],
          ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
