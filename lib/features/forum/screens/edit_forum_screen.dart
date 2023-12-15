import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditForumScreen extends ConsumerStatefulWidget {
  final String forumId;
  const EditForumScreen({super.key, required this.forumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditForumScreenState();
}

class _EditForumScreenState extends ConsumerState<EditForumScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
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

  void save(Forum forum) {
    if (titleController.text.trim().isNotEmpty) {
      forum = forum.copyWith(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          public: isChecked);
      ref.read(forumControllerProvider.notifier).updateForum(
          profileFile: profileFile,
          bannerFile: bannerFile,
          forum: forum,
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
    final isLoading = ref.watch(forumControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref
        .watch(
          getForumByIdProvider(widget.forumId),
        )
        .when(
          data: (forum) {
            if (isLoaded == false) {
              titleController.text = forum!.title;
              descriptionController.text = forum.description;
              isChecked = forum.public;
              isLoaded = true;
            }

            return Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: Text(
                  'Edit Forum',
                  style: TextStyle(
                    color: currentTheme.textTheme.bodyMedium!.color!,
                  ),
                ),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () => save(forum!),
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
                                          : forum!.banner.isEmpty ||
                                                  forum.banner ==
                                                      Constants
                                                          .forumBannerDefault
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 40,
                                                  ),
                                                )
                                              : Image.network(
                                                  forum.banner,
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
                                        : forum!.image ==
                                                Constants.avatarDefault
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    Image.asset(forum.image)
                                                        .image,
                                                radius: 32,
                                              )
                                            : CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(forum.image),
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
                            activeColor: Pallete.forumColor,
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
