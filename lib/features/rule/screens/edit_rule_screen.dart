import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mime/mime.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/manager/controller/manager_controller.dart';
import 'package:reddit_tutorial/features/policy/controller/policy_controller.dart';
import 'package:reddit_tutorial/features/rule/controller/rule_controller.dart';
import 'package:reddit_tutorial/models/rule.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:tuple/tuple.dart';

final instantiationTypeRadioProvider =
    StateProvider<String>((ref) => InstantiationType.consume.value);

class EditRuleScreen extends ConsumerStatefulWidget {
  final String policyId;
  final String ruleId;
  const EditRuleScreen(
      {super.key, required this.policyId, required this.ruleId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EditRuleScreenState();
}

class _EditRuleScreenState extends ConsumerState<EditRuleScreen> {
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

  void save(Rule rule) {
    List<String>? tags = _stringTagController.getTags;

    if (titleController.text.trim().isNotEmpty) {
      rule = rule.copyWith(
        title: titleController.text.trim(),
        titleLowercase: titleController.text.trim().toLowerCase(),
        description: descriptionController.text.trim(),
        instantiationType:
            ref.read(instantiationTypeRadioProvider.notifier).state,
        public: isChecked,
        tags: tags,
        imageFileName: profileFileName,
        imageFileType: profileFileType,
        bannerFileName: bannerFileName,
        bannerFileType: bannerFileType,
      );
      ref.read(ruleControllerProvider.notifier).updateRule(
          profileFile: profileFile,
          bannerFile: bannerFile,
          rule: rule,
          context: _scaffold.currentContext!);
    }
  }

  validateUser() async {
    final user = ref.read(userProvider)!;
    final policy =
        await ref.read(getPolicyByIdProvider2(widget.policyId)).first;
    final manager = await ref
        .read(
            getUserSelectedManagerProvider2(Tuple2(widget.policyId, user.uid)))
        .first;

    if (policy!.uid != user.uid) {
      if (manager!.permissions.contains(ManagerPermissions.editrule.value) ==
          false) {
        Future.delayed(Duration.zero, () {
          showSnackBar(context,
              'You do not have permission to make changes to this rule', true);
          Routemaster.of(context).pop();
        });
      }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      validateUser();
    });
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
    final instantiationTypeRadioProv =
        ref.watch(instantiationTypeRadioProvider.notifier).state;

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
              key: _scaffold,
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'Edit Rule ${rule!.title}',
                  style: TextStyle(
                    color: currentTheme.textTheme.bodyMedium!.color!,
                  ),
                ),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () => save(rule),
                    child: const Text('Save'),
                  ),
                ],
              ),
              body: isLoading
                  ? const Loader()
                  : Padding(
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: bannerFile != null
                                            ? Image.file(bannerFile!)
                                            : rule.banner.isEmpty ||
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
                                                        child,
                                                        loadingProgress) {
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
                                          : rule.image ==
                                                  Constants.avatarDefault
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
                                      BorderSide(color: Pallete.ruleTagColor),
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
                                      BorderSide(color: Pallete.ruleTagColor),
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
                                  rule!.tags.isNotEmpty ? rule.tags : [],
                              textSeparators: const [' ', ','],
                              letterCase: LetterCase.small,
                              validator: (String tag) {
                                if (_stringTagController.getTags!
                                    .contains(tag)) {
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
                                          color: Pallete.ruleTagColor),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Pallete.ruleTagColor),
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
                                                  children: inputFieldValues
                                                      .tags
                                                      .map((String tag) {
                                                    return Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .all(
                                                          Radius.circular(20.0),
                                                        ),
                                                        color: Pallete
                                                            .ruleTagColor,
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
                                                              style: const TextStyle(
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
                                                              color: Color
                                                                  .fromARGB(
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.build_outlined, size: 21),
                                const SizedBox(
                                  width: 12,
                                ),
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      "Create forum immediately when policy is consumed by a service.",
                                      textWidthBasis:
                                          TextWidthBasis.longestLine,
                                    ),
                                  ),
                                ),
                                Radio(
                                    value: InstantiationType.consume.value,
                                    groupValue: instantiationTypeRadioProv,
                                    onChanged: (newValue) {
                                      ref
                                          .read(instantiationTypeRadioProvider
                                              .notifier)
                                          .state = newValue.toString();
                                    }),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                const Icon(Icons.attach_money_outlined,
                                    size: 22),
                                const SizedBox(
                                  width: 12,
                                ),
                                Flexible(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: const Text(
                                      "Create forum when service consuming policy is ordered by another service.  For example a patient paying for a consultancy service from a doctor.",
                                      textWidthBasis:
                                          TextWidthBasis.longestLine,
                                    ),
                                  ),
                                ),
                                Radio(
                                    value: InstantiationType.order.value,
                                    groupValue: instantiationTypeRadioProv,
                                    onChanged: (newValue) {
                                      ref
                                          .read(instantiationTypeRadioProvider
                                              .notifier)
                                          .state = newValue.toString();
                                    }),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
