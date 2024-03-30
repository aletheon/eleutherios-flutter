import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/registrant/controller/registrant_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/registrant.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditPermissionsScreen extends ConsumerStatefulWidget {
  final String forumId;
  final String registrantId;
  const EditPermissionsScreen(
      {super.key, required this.forumId, required this.registrantId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditPermissionsScreenState();
}

class _EditPermissionsScreenState extends ConsumerState<EditPermissionsScreen> {
  void save(Registrant registrant, List<String> permissions) {
    registrant = registrant.copyWith(permissions: permissions);
    ref
        .read(registrantControllerProvider.notifier)
        .updateRegistrant(registrant: registrant, context: context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final currentTheme = ref.watch(themeNotifierProvider);
    List<String> permissions = [];

    return ref.watch(getRegistrantByIdProvider(widget.registrantId)).when(
          data: (registrant) {
            permissions = registrant!.permissions;
            return ref.watch(getServiceByIdProvider(registrant.serviceId)).when(
                  data: (service) {
                    return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          'Edit Permissions',
                          style: TextStyle(
                            color: currentTheme.textTheme.bodyMedium!.color!,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => {
                              save(registrant, permissions),
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                      body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                service!.image == Constants.avatarDefault
                                    ? CircleAvatar(
                                        backgroundImage:
                                            Image.asset(service.image).image,
                                        radius: 25,
                                      )
                                    : CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(service.image),
                                        radius: 25,
                                      ),
                                const SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Text(
                                    service.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: RegistrantPermissions.values.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final permission =
                                      RegistrantPermissions.values[index];
                                  List<Widget> _icons = [];

                                  switch (permission.name) {
                                    case 'editforum':
                                      _icons.add(
                                        const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'addservice':
                                      _icons.add(
                                        const Icon(
                                          Icons.construction,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'removeservice':
                                      _icons.add(
                                        const Icon(
                                          Icons.construction,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'addforum':
                                      _icons.add(
                                        const Icon(
                                          Icons.forum,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'removeforum':
                                      _icons.add(
                                        const Icon(
                                          Icons.forum,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'createpost':
                                      _icons.add(
                                        const Icon(
                                          Icons.article,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    case 'removepost':
                                      _icons.add(
                                        const Icon(
                                          Icons.article,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      _icons.add(
                                        const Icon(
                                          Icons.remove,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                      break;
                                    default:
                                      _icons.add(
                                        const Icon(
                                          Icons.lock,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      );
                                  }

                                  final permissionIcon = CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Pallete.greyColor,
                                    child: CircleAvatar(
                                      radius: 13,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: _icons,
                                      ),
                                    ),
                                  );

                                  return CheckboxListTile(
                                    secondary: permissionIcon,
                                    title: Text(permission.value),
                                    value: permissions.contains(permission.name)
                                        ? true
                                        : false,
                                    onChanged: (isChecked) {
                                      setState(() {
                                        if (isChecked!) {
                                          permissions.add(permission.name);
                                        } else {
                                          permissions.remove(permission.name);
                                        }
                                      });
                                    },
                                    controlAffinity:
                                        ListTileControlAffinity.trailing,
                                    activeColor: Pallete.forumColor,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  error: (error, stackTrace) => ErrorText(
                    error: error.toString(),
                  ),
                  loading: () => const Loader(),
                );
          },
          error: (error, stackTrace) => ErrorText(
            error: error.toString(),
          ),
          loading: () => const Loader(),
        );
  }
}
