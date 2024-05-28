import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/consumer/delegates/search_consumer_delegate.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

final searchRadioProvider = StateProvider<String>((ref) => 'Private');
final GlobalKey _scaffold = GlobalKey();

class AddConsumerScreen extends ConsumerWidget {
  final String _policyId;
  const AddConsumerScreen({super.key, required String policyId})
      : _policyId = policyId;

  void addPolicyToService(WidgetRef ref, String serviceId) {
    ref
        .read(policyControllerProvider.notifier)
        .addPolicyToService(serviceId, _policyId, _scaffold.currentContext!);
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
              onPressed: () => addPolicyToService(ref, service.serviceId),
              child: const Text(
                'Add',
              ),
            ),
            onTap: () => showServiceDetails(context, service.serviceId),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(serviceControllerProvider);
    final policyProv = ref.watch(getPolicyByIdProvider(_policyId));
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
                        IconButton(
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: SearchConsumerDelegate(
                                  ref,
                                  user,
                                  policy!,
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
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
