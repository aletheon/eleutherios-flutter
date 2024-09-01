import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/models/forum.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:textfield_tags/textfield_tags.dart';

class EditForumScreen extends ConsumerStatefulWidget {
  final String forumId;
  const EditForumScreen({super.key, required this.forumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditForumScreenState();
}

class _EditForumScreenState extends ConsumerState<EditForumScreen> {
  final GlobalKey _scaffold = GlobalKey();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late double _distanceToField;
  late StringTagController _stringTagController;
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

  void save(Forum forum) {
    List<String>? tags = _stringTagController.getTags;

    if (titleController.text.trim().isNotEmpty) {
      forum = forum.copyWith(
        title: titleController.text.trim(),
        titleLowercase: titleController.text.trim().toLowerCase(),
        description: descriptionController.text.trim(),
        public: isChecked,
        tags: tags,
        imageFileName: profileFileName,
        imageFileType: profileFileType,
        bannerFileName: bannerFileName,
        bannerFileType: bannerFileType,
      );
      ref.read(forumControllerProvider.notifier).updateForum(
          profileFile: profileFile,
          bannerFile: bannerFile,
          forum: forum,
          context: _scaffold.currentContext!);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    super.initState();
    _stringTagController = StringTagController();
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
              key: _scaffold,
              backgroundColor: currentTheme.scaffoldBackgroundColor,
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
              body: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
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
                                    BorderSide(color: Pallete.forumTagColor),
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
                                    BorderSide(color: Pallete.forumTagColor),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            maxLines: 5,
                            maxLength: 1000,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFieldTags<String>(
                            textfieldTagsController: _stringTagController,
                            initialTags:
                                forum!.tags.isNotEmpty ? forum.tags : [],
                            textSeparators: const [' ', ','],
                            letterCase: LetterCase.small,
                            validator: (String tag) {
                              if (_stringTagController.getTags!.contains(tag)) {
                                return 'You\'ve already entered that';
                              }
                              return null;
                            },
                            inputFieldBuilder: (context, inputFieldValues) {
                              return TextField(
                                onTap: () {
                                  _stringTagController.getFocusNode
                                      ?.requestFocus();
                                },
                                controller:
                                    inputFieldValues.textEditingController,
                                focusNode: inputFieldValues.focusNode,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                                ],
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Pallete.forumTagColor),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Pallete.forumTagColor),
                                  ),
                                  hintText: inputFieldValues.tags.isNotEmpty
                                      ? ''
                                      : "Enter tag",
                                  errorText: inputFieldValues.error,
                                  prefixIconConstraints: BoxConstraints(
                                      maxWidth: _distanceToField * 0.8),
                                  prefixIcon: inputFieldValues.tags.isNotEmpty
                                      ? SingleChildScrollView(
                                          controller: inputFieldValues
                                              .tagScrollController,
                                          scrollDirection: Axis.vertical,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 8,
                                              bottom: 8,
                                              left: 8,
                                            ),
                                            child: Wrap(
                                                runSpacing: 4.0,
                                                spacing: 4.0,
                                                children: inputFieldValues.tags
                                                    .map((String tag) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          const BorderRadius
                                                              .all(
                                                        Radius.circular(20.0),
                                                      ),
                                                      color:
                                                          Pallete.forumTagColor,
                                                    ),
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5.0),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 5.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        InkWell(
                                                          child: Text(
                                                            '#$tag',
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          onTap: () {
                                                            // print("$tag selected");
                                                          },
                                                        ),
                                                        const SizedBox(
                                                            width: 4.0),
                                                        InkWell(
                                                          child: const Icon(
                                                            Icons.cancel,
                                                            size: 14.0,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    233,
                                                                    233,
                                                                    233),
                                                          ),
                                                          onTap: () {
                                                            inputFieldValues
                                                                .onTagRemoved(
                                                                    tag);
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                }).toList()),
                                          ),
                                        )
                                      : null,
                                ),
                                onChanged: inputFieldValues.onTagChanged,
                                onSubmitted: (tag) {
                                  List<String>? tags =
                                      _stringTagController.getTags;

                                  if (tags != null && tags.length >= 5) {
                                    showDialog(
                                      context: _scaffold.currentContext!,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        String message =
                                            "You have reached the limit of 5 tags";

                                        return AlertDialog(
                                          content: Text(message),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Close'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  } else {
                                    inputFieldValues.onTagSubmitted(tag);
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
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
