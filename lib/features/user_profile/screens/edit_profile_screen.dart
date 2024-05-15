import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_tutorial/models/user_model.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final fullNameController = TextEditingController();
  final personalWebsiteController = TextEditingController();
  final businessNameController = TextEditingController();
  final businessDescriptionController = TextEditingController();
  final businessWebsiteController = TextEditingController();
  bool isChecked = false;
  var isLoaded = false;

  File? bannerFile;
  File? profileFile;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void save(UserModel userModel) {
    if (fullNameController.text.trim().isNotEmpty) {
      userModel = userModel.copyWith(
        fullName: fullNameController.text.trim(),
        businessName: businessNameController.text.trim(),
        businessDescription: businessDescriptionController.text.trim(),
        personalWebsite: personalWebsiteController.text.trim(),
        businessWebsite: businessWebsiteController.text.trim(),
      );
      ref.read(userProfileControllerProvider.notifier).updateUser(
          profileFile: profileFile,
          bannerFile: bannerFile,
          userModel: userModel,
          context: context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    fullNameController.dispose();
    personalWebsiteController.dispose();
    businessNameController.dispose();
    businessDescriptionController.dispose();
    businessWebsiteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref
        .watch(
          getUserDataProvider(widget.uid),
        )
        .when(
          data: (user) {
            if (isLoaded == false) {
              fullNameController.text = user!.fullName;
              personalWebsiteController.text = user.personalWebsite;
              businessNameController.text = user.businessName;
              businessDescriptionController.text = user.businessDescription;
              businessWebsiteController.text = user.businessWebsite;
              isLoaded = true;
            }

            return Scaffold(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'Edit User',
                  style: TextStyle(
                    color: currentTheme.textTheme.bodyMedium!.color!,
                  ),
                ),
                shape: LinearBorder.bottom(
                  side: BorderSide(color: Pallete.forumColor, width: 0.65),
                ),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () => save(user!),
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
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 180,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () => selectBannerImage(),
                                  child: DottedBorder(
                                    color: currentTheme
                                        .textTheme.bodyMedium!.color!,
                                    borderType: BorderType.RRect,
                                    radius: const Radius.circular(10),
                                    dashPattern: const [6, 4],
                                    strokeCap: StrokeCap.round,
                                    child: Container(
                                      width: double.infinity,
                                      height: 150,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: bannerFile != null
                                          ? Image.file(bannerFile!)
                                          : user!.banner.isEmpty ||
                                                  user.banner ==
                                                      Constants.bannerDefault
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 40,
                                                  ),
                                                )
                                              : Image.network(
                                                  user.banner,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    return loadingProgress
                                                                ?.cumulativeBytesLoaded ==
                                                            loadingProgress
                                                                ?.expectedTotalBytes
                                                        ? child
                                                        : const CircularProgressIndicator();
                                                  },
                                                ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 20,
                                  child: GestureDetector(
                                    onTap: () => selectProfileImage(),
                                    child: profileFile != null
                                        ? CircleAvatar(
                                            backgroundImage:
                                                FileImage(profileFile!),
                                            radius: 32,
                                          )
                                        : user!.profilePic ==
                                                Constants.avatarDefault
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    Image.asset(user.profilePic)
                                                        .image,
                                                radius: 32,
                                              )
                                            : CircleAvatar(
                                                backgroundImage: NetworkImage(
                                                    user.profilePic),
                                                radius: 32,
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: fullNameController,
                            decoration: InputDecoration(
                              hintText: 'Full name',
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maxLength: 40,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: businessNameController,
                            decoration: InputDecoration(
                              hintText: 'Business name (Optional)',
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maxLength: 40,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: businessDescriptionController,
                            decoration: InputDecoration(
                              hintText: 'Business description (Optional)',
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maxLength: 280,
                            maxLines: 5,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: personalWebsiteController,
                            decoration: InputDecoration(
                              hintText: 'Personal website (Optional)',
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextField(
                            controller: businessWebsiteController,
                            decoration: InputDecoration(
                              hintText: 'Business website (Optional)',
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
