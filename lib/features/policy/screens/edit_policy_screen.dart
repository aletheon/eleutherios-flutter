import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/models/policy.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditPolicyScreen extends ConsumerStatefulWidget {
  final String policyId;
  const EditPolicyScreen({super.key, required this.policyId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditPolicyScreenState();
}

class _EditPolicyScreenState extends ConsumerState<EditPolicyScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isChecked = false;
  var isLoaded = false;

  File? bannerFile;
  File? profileFile;
  String? bannerFileName;
  String? profileFileName;
  String? profileFileType;
  String? bannerFileType;

  void selectBannerImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
        bannerFileName = bannerFile!.path.split('/').last;
        bannerFileType = lookupMimeType(bannerFile!.path);
      });
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();

    if (res != null) {
      setState(() {
        profileFile = File(res.files.first.path!);
        profileFileName = profileFile!.path.split('/').last;
        profileFileType = lookupMimeType(profileFile!.path);
      });
    }
  }

  void save(Policy policy) {
    if (titleController.text.trim().isNotEmpty) {
      policy = policy.copyWith(
        title: titleController.text.trim(),
        titleLowercase: titleController.text.trim().toLowerCase(),
        description: descriptionController.text.trim(),
        public: isChecked,
        imageFileName: profileFileName,
        imageFileType: profileFileType,
        bannerFileName: bannerFileName,
        bannerFileType: bannerFileType,
      );
      ref.read(policyControllerProvider.notifier).updatePolicy(
          profileFile: profileFile,
          bannerFile: bannerFile,
          policy: policy,
          context: context);
    }
  }

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(policyControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref
        .watch(
          getPolicyByIdProvider(widget.policyId),
        )
        .when(
          data: (policy) {
            if (isLoaded == false) {
              titleController.text = policy!.title;
              descriptionController.text = policy.description;
              isChecked = policy.public;
              isLoaded = true;
            }

            return Scaffold(
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'Edit Policy',
                  style: TextStyle(
                    color: currentTheme.textTheme.bodyMedium!.color!,
                  ),
                ),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () => save(policy!),
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
                                          : policy!.banner.isEmpty ||
                                                  policy.banner ==
                                                      Constants
                                                          .policyBannerDefault
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 40,
                                                  ),
                                                )
                                              : Image.network(
                                                  policy.banner,
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
                                        : policy!.image ==
                                                Constants.avatarDefault
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    Image.asset(policy.image)
                                                        .image,
                                                radius: 32,
                                              )
                                            : CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(policy.image),
                                                radius: 32,
                                              ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          CheckboxListTile(
                            title: const Text(
                              "Public",
                              style: TextStyle(color: Pallete.greyColor),
                            ),
                            value: isChecked,
                            onChanged: (newValue) {
                              setState(() {
                                isChecked = newValue!;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                            activeColor: Pallete.policyColor,
                          ),
                          TextField(
                            controller: titleController,
                            decoration: InputDecoration(
                              hintText: 'Title',
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
                            controller: descriptionController,
                            decoration: InputDecoration(
                              hintText: 'Description',
                              filled: true,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(18),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maxLines: 8,
                            maxLength: 1000,
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
