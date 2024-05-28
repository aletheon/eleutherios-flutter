import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

final GlobalKey _scaffold = GlobalKey();

class ServiceRemovePolicyScreen extends ConsumerWidget {
  final String _serviceId;
  const ServiceRemovePolicyScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  void removeServicePolicy(WidgetRef ref, String policyId) async {
    ref.read(policyControllerProvider.notifier).removePolicyFromService(
        _serviceId, policyId, _scaffold.currentContext!);
  }

  void showPolicyDetails(BuildContext context, String policyId) {
    Routemaster.of(context).push('policy/$policyId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(policyControllerProvider);
    final serviceProv = ref.watch(getForumByIdProvider(_serviceId));
    final serviceConsumerPoliciesProv =
        ref.watch(getServiceConsumerPoliciesProvider(_serviceId));
    final currentTheme = ref.watch(themeNotifierProvider);

    return serviceProv.when(
      data: (service) {
        return Scaffold(
          key: _scaffold,
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Remove Policy',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: isLoading
              ? const Loader()
              : serviceConsumerPoliciesProv.when(
                  data: (serviceConsumerPolicies) {
                    if (serviceConsumerPolicies.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Container(
                          alignment: Alignment.topCenter,
                          child: const Text(
                            'No policies',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView.builder(
                          itemCount: serviceConsumerPolicies.length,
                          itemBuilder: (BuildContext context, int index) {
                            final policy = serviceConsumerPolicies[index];

                            return ListTile(
                              title: Text(
                                policy.title,
                                textWidthBasis: TextWidthBasis.longestLine,
                              ),
                              leading: policy.image == Constants.avatarDefault
                                  ? CircleAvatar(
                                      backgroundImage:
                                          Image.asset(policy.image).image,
                                    )
                                  : CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(policy.image),
                                    ),
                              trailing: TextButton(
                                onPressed: () => removeServicePolicy(
                                  ref,
                                  policy.policyId,
                                ),
                                child: const Text(
                                  'Remove',
                                ),
                              ),
                              onTap: () =>
                                  showPolicyDetails(context, policy.policyId),
                            );
                          },
                        ),
                      );
                    }
                  },
                  error: (error, stackTrace) =>
                      ErrorText(error: error.toString()),
                  loading: () => const Loader(),
                ),
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
