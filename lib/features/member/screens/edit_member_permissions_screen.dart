import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/features/member/controller/member_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/member.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:tuple/tuple.dart';

class EditMemberPermissionsScreen extends ConsumerStatefulWidget {
  final String forumId;
  final String memberId;
  const EditMemberPermissionsScreen(
      {super.key, required this.forumId, required this.memberId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditMemberPermissionsScreenState();
}

class _EditMemberPermissionsScreenState
    extends ConsumerState<EditMemberPermissionsScreen> {
  final GlobalKey _scaffold = GlobalKey();
  void save(Member member, List<String> permissions) {
    member = member.copyWith(permissions: permissions);
    ref
        .read(memberControllerProvider.notifier)
        .updateMember(member: member, context: _scaffold.currentContext!);
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final forum = await ref.read(getForumByIdProvider2(widget.forumId)).first;
    final member = await ref
        .read(getUserSelectedMemberProvider2(Tuple2(widget.forumId, user.uid)))
        .first;

    if (forum!.uid != user.uid) {
      if (member!.permissions
              .contains(MemberPermissions.editmemberpermissions.value) ==
          false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to make changes to member permissions');
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
    final isLoading = ref.watch(memberControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    List<String> permissions = [];

    return ref.watch(getMemberByIdProvider(widget.memberId)).when(
          data: (member) {
            permissions = member!.permissions;
            return ref.watch(getServiceByIdProvider(member.serviceId)).when(
                  data: (service) {
                    return Scaffold(
                      key: _scaffold,
                      appBar: AppBar(
                        title: Text(
                          'Edit Member Permissions',
                          style: TextStyle(
                            color: currentTheme.textTheme.bodyMedium!.color!,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => {
                              save(member, permissions),
                            },
                            child: const Text('Save'),
                          ),
                        ],
                      ),
                      body: isLoading
                          ? const Loader()
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      service!.image == Constants.avatarDefault
                                          ? CircleAvatar(
                                              backgroundImage:
                                                  Image.asset(service.image)
                                                      .image,
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
                                      itemCount:
                                          MemberPermissions.values.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final permission =
                                            MemberPermissions.values[index];
                                        List<Widget> _icons = [];

                                        switch (permission.value) {
                                          case 'editforum':
                                            _icons.add(
                                              const Icon(
                                                Icons.edit,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            );
                                            break;
                                          case 'addmember':
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
                                          case 'removemember':
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
                                          case 'createforum':
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
                                          case 'addtocart':
                                            _icons.add(
                                              const Icon(
                                                Icons.shopping_cart,
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
                                          case 'removefromcart':
                                            _icons.add(
                                              const Icon(
                                                Icons.shopping_cart,
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
                                          case 'editmemberpermissions':
                                            _icons.add(
                                              const Icon(
                                                Icons.auto_fix_normal,
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
                                          value: permissions
                                                  .contains(permission.value)
                                              ? true
                                              : false,
                                          onChanged: (isChecked) {
                                            setState(() {
                                              if (isChecked!) {
                                                permissions
                                                    .add(permission.value);
                                              } else {
                                                permissions
                                                    .remove(permission.value);
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
