import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditRuleScreen extends ConsumerStatefulWidget {
  final String policyId;
  final String ruleId;
  const EditRuleScreen(
      {super.key, required this.policyId, required this.ruleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditRuleScreenState();
}

class _EditRuleScreenState extends ConsumerState<EditRuleScreen> {
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

  void save(Rule rule) {
    if (titleController.text.trim().isNotEmpty) {
      rule = rule.copyWith(
          title: titleController.text.trim(),
          description: descriptionController.text.trim(),
          public: isChecked);
      ref.read(ruleControllerProvider.notifier).updateRule(
          profileFile: profileFile,
          bannerFile: bannerFile,
          rule: rule,
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
    final isLoading = ref.watch(ruleControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref
        .watch(
          getRuleByIdProvider(widget.ruleId),
        )
        .when(
          data: (rule) {
            if (isLoaded == false) {
              titleController.text = rule!.title;
              descriptionController.text = rule.description;
              isChecked = rule.public;
              isLoaded = true;
            }

            return Scaffold(
              backgroundColor: currentTheme.backgroundColor,
              appBar: AppBar(
                title: Text(
                  'Edit Rule',
                  style: TextStyle(
                    color: currentTheme.textTheme.bodyMedium!.color!,
                  ),
                ),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () => save(rule!),
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
                                          : rule!.banner.isEmpty ||
                                                  rule.banner ==
                                                      Constants
                                                          .ruleBannerDefault
                                              ? const Center(
                                                  child: Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 40,
                                                  ),
                                                )
                                              : Image.network(
                                                  rule.banner,
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
                                        : rule!.image == Constants.avatarDefault
                                            ? CircleAvatar(
                                                backgroundImage:
                                                    Image.asset(rule.image)
                                                        .image,
                                                radius: 32,
                                              )
                                            : CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(rule.image),
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
                            activeColor: Pallete.ruleColor,
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
