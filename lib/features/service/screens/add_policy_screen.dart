import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class AddPolicyScreen extends ConsumerWidget {
  final String _serviceId;
  const AddPolicyScreen({super.key, required String serviceId})
      : _serviceId = serviceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Policy',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reddit_tutorial/core/common/error_text.dart';
// import 'package:reddit_tutorial/core/common/loader.dart';
// import 'package:reddit_tutorial/core/constants/constants.dart';
// import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
// import 'package:reddit_tutorial/features/favorite/controller/favorite_controller.dart';
// import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
// import 'package:reddit_tutorial/features/registrant/controller/registrant_controller.dart';
// import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
// import 'package:reddit_tutorial/models/favorite.dart';
// import 'package:reddit_tutorial/models/forum.dart';
// import 'package:reddit_tutorial/models/registrant.dart';
// import 'package:reddit_tutorial/models/service.dart';
// import 'package:reddit_tutorial/theme/pallete.dart';
// import 'package:routemaster/routemaster.dart';

// final searchRadioProvider = StateProvider<String>((ref) => 'Private');

// class AddPolicyScreen extends ConsumerWidget {
//   final String _serviceId;
//   const AddPolicyScreen({super.key, required String serviceId})
//       : _serviceId = serviceId;

//   void registerPolicy(
//       BuildContext context, WidgetRef ref, String serviceId, String policyId) {
//     ref
//         .read(serviceControllerProvider.notifier)
//         .addPolicy(serviceId, policyId, context);
//   }

//   void showServiceDetails(BuildContext context, String serviceId) {
//     Routemaster.of(context).push('service/$serviceId');
//   }

//   // Widget showServiceList(WidgetRef ref, Forum forum, List<Service>? services,
//   //     List<Favorite>? favorites) {
//   //   if (services != null) {
//   //     return Expanded(
//   //       child: ListView.builder(
//   //         itemCount: services.length,
//   //         itemBuilder: (BuildContext context, int index) {
//   //           final service = services[index];
//   //           return ListTile(
//   //             title: Text(service.title),
//   //             leading: service.image == Constants.avatarDefault
//   //                 ? CircleAvatar(
//   //                     backgroundImage: Image.asset(service.image).image,
//   //                   )
//   //                 : CircleAvatar(
//   //                     backgroundImage: NetworkImage(service.image),
//   //                   ),
//   //             trailing: TextButton(
//   //               onPressed: () => registerService(context, ref, forum.forumId,
//   //                   forum.uid, service.serviceId, service.uid),
//   //               child: const Text(
//   //                 'Add',
//   //               ),
//   //             ),
//   //             onTap: () => showServiceDetails(context, service.serviceId),
//   //           );
//   //         },
//   //       ),
//   //     );
//   //   } else {
//   //     return Expanded(
//   //       child: ListView.builder(
//   //         itemCount: favorites!.length,
//   //         itemBuilder: (BuildContext context, int index) {
//   //           final favorite = favorites[index];
//   //           return ref.watch(getServiceByIdProvider(favorite.serviceId)).when(
//   //                 data: (service) {
//   //                   return ListTile(
//   //                     title: Text(service.title),
//   //                     leading: service.image == Constants.avatarDefault
//   //                         ? CircleAvatar(
//   //                             backgroundImage: Image.asset(service.image).image,
//   //                           )
//   //                         : CircleAvatar(
//   //                             backgroundImage: NetworkImage(service.image),
//   //                           ),
//   //                     trailing: TextButton(
//   //                       onPressed: () => registerService(
//   //                           context,
//   //                           ref,
//   //                           forum.forumId,
//   //                           forum.uid,
//   //                           service.serviceId,
//   //                           service.uid),
//   //                       child: const Text(
//   //                         'Add',
//   //                       ),
//   //                     ),
//   //                     onTap: () =>
//   //                         showServiceDetails(context, service.serviceId),
//   //                   );
//   //                 },
//   //                 error: (error, stackTrace) =>
//   //                     ErrorText(error: error.toString()),
//   //                 loading: () => const Loader(),
//   //               );
//   //         },
//   //       ),
//   //     );
//   //   }
//   // }

//   // Widget showServices(WidgetRef ref, Forum forum, String searchType) {
//   //   final userFavoritesProv = ref.watch(userFavoritesProvider);
//   //   final userServicesProv = ref.watch(userServicesProvider);
//   //   final servicesProv = ref.watch(servicesProvider);
//   //   final user = ref.watch(userProvider)!;
//   //   final registrantsProv = ref.watch(getRegistrantsProvider(_forumId));

//   //   if (searchType == "Private") {
//   //     if (user.services.isEmpty) {
//   //       return const Center(
//   //         child: Padding(
//   //           padding: EdgeInsets.all(8.0),
//   //           child: Text("You haven't created any services"),
//   //         ),
//   //       );
//   //     } else {
//   //       return userServicesProv.when(
//   //         data: (services) {
//   //           if (forum.registrants.isEmpty) {
//   //             return showServiceList(ref, forum, services, null);
//   //           } else {
//   //             return registrantsProv.when(
//   //               data: (registrants) {
//   //                 List<Service> servicesNotInForum = [];
//   //                 for (var service in services) {
//   //                   List<Registrant> result = registrants
//   //                       .where((r) => r.serviceId == service.serviceId)
//   //                       .toList();
//   //                   if (result.isEmpty) {
//   //                     servicesNotInForum.add(service);
//   //                   }
//   //                 }

//   //                 if (servicesNotInForum.isNotEmpty) {
//   //                   return showServiceList(
//   //                       ref, forum, servicesNotInForum, null);
//   //                 } else {
//   //                   return const Center(
//   //                     child: Padding(
//   //                       padding: EdgeInsets.all(8.0),
//   //                       child: Text('All of your services are in the forum'),
//   //                     ),
//   //                   );
//   //                 }
//   //               },
//   //               error: (error, stackTrace) =>
//   //                   ErrorText(error: error.toString()),
//   //               loading: () => const Loader(),
//   //             );
//   //           }
//   //         },
//   //         error: (error, stackTrace) => ErrorText(error: error.toString()),
//   //         loading: () => const Loader(),
//   //       );
//   //     }
//   //   } else if (searchType == "Public") {
//   //     return servicesProv.when(
//   //       data: (services) {
//   //         if (services.isEmpty) {
//   //           return const Center(
//   //             child: Padding(
//   //               padding: EdgeInsets.all(8.0),
//   //               child: Text("There are no publc services"),
//   //             ),
//   //           );
//   //         } else {
//   //           if (forum.registrants.isEmpty) {
//   //             return showServiceList(ref, forum, services, null);
//   //           } else {
//   //             return registrantsProv.when(
//   //               data: (registrants) {
//   //                 List<Service> servicesNotInForum = [];
//   //                 for (var service in services) {
//   //                   List<Registrant> result = registrants
//   //                       .where((r) => r.serviceId == service.serviceId)
//   //                       .toList();
//   //                   if (result.isEmpty) {
//   //                     servicesNotInForum.add(service);
//   //                   }
//   //                 }

//   //                 if (servicesNotInForum.isNotEmpty) {
//   //                   return showServiceList(
//   //                       ref, forum, servicesNotInForum, null);
//   //                 } else {
//   //                   return const Center(
//   //                     child: Padding(
//   //                       padding: EdgeInsets.all(8.0),
//   //                       child: Text('All public services are in the forum'),
//   //                     ),
//   //                   );
//   //                 }
//   //               },
//   //               error: (error, stackTrace) =>
//   //                   ErrorText(error: error.toString()),
//   //               loading: () => const Loader(),
//   //             );
//   //           }
//   //         }
//   //       },
//   //       error: (error, stackTrace) => ErrorText(error: error.toString()),
//   //       loading: () => const Loader(),
//   //     );
//   //   } else {
//   //     if (user.favorites.isEmpty) {
//   //       return const Center(
//   //         child: Padding(
//   //           padding: EdgeInsets.all(8.0),
//   //           child: Text("You don't have any favorites"),
//   //         ),
//   //       );
//   //     } else {
//   //       return userFavoritesProv.when(
//   //         data: (favorites) {
//   //           if (forum.registrants.isEmpty) {
//   //             return showServiceList(ref, forum, null, favorites);
//   //           } else {
//   //             return registrantsProv.when(
//   //               data: (registrants) {
//   //                 List<Favorite> favoritesNotInForum = [];
//   //                 for (var favorite in favorites) {
//   //                   List<Registrant> result = registrants
//   //                       .where((r) => r.serviceId == favorite.serviceId)
//   //                       .toList();
//   //                   if (result.isEmpty) {
//   //                     favoritesNotInForum.add(favorite);
//   //                   }
//   //                 }

//   //                 if (favoritesNotInForum.isNotEmpty) {
//   //                   return showServiceList(
//   //                       ref, forum, null, favoritesNotInForum);
//   //                 } else {
//   //                   return const Center(
//   //                     child: Padding(
//   //                       padding: EdgeInsets.all(8.0),
//   //                       child: Text('All of your favorites are in the forum'),
//   //                     ),
//   //                   );
//   //                 }
//   //               },
//   //               error: (error, stackTrace) =>
//   //                   ErrorText(error: error.toString()),
//   //               loading: () => const Loader(),
//   //             );
//   //           }
//   //         },
//   //         error: (error, stackTrace) => ErrorText(error: error.toString()),
//   //         loading: () => const Loader(),
//   //       );
//   //     }
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final serviceProv = ref.watch(getServiceByIdProvider(_serviceId));
//     final searchRadioProv = ref.watch(searchRadioProvider.notifier).state;
//     final currentTheme = ref.watch(themeNotifierProvider);

//     return serviceProv.when(
//       data: (service) {
//         return Scaffold(
//           backgroundColor: currentTheme.backgroundColor,
//           appBar: AppBar(
//             title: Text(
//               'Add Policies',
//               style: TextStyle(
//                 color: currentTheme.textTheme.bodyMedium!.color!,
//               ),
//             ),
//             // actions: [
//             //   user.forumActivities
//             //           .where((a) => a == widget._forumId)
//             //           .toList()
//             //           .isNotEmpty
//             //       ? IconButton(
//             //           onPressed: () => viewForum(ref, context),
//             //           icon: const Icon(Icons.exit_to_app))
//             //       : const SizedBox(),
//             // ],
//           ),
//           body: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   const Text("Private"),
//                   Radio(
//                       value: "Private",
//                       groupValue: searchRadioProv,
//                       onChanged: (newValue) {
//                         ref.read(searchRadioProvider.notifier).state =
//                             newValue.toString();
//                       }),
//                   const Text("Public"),
//                   Radio(
//                       value: "Public",
//                       groupValue: searchRadioProv,
//                       onChanged: (newValue) {
//                         ref.read(searchRadioProvider.notifier).state =
//                             newValue.toString();
//                       }),
//                   const Text("Favorite"),
//                   Radio(
//                       value: "Favorite",
//                       groupValue: searchRadioProv,
//                       onChanged: (newValue) {
//                         ref.read(searchRadioProvider.notifier).state =
//                             newValue.toString();
//                       }),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(Icons.search),
//                   ),
//                 ],
//               ),
//               showServices(ref, service, searchRadioProv)
//             ],
//           ),
//         );
//       },
//       error: (error, stackTrace) => ErrorText(error: error.toString()),
//       loading: () => const Loader(),
//     );
//   }
// }

