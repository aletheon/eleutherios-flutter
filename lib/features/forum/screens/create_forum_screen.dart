import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateForumScreen extends ConsumerStatefulWidget {
  final String? forumId;
  const CreateForumScreen({super.key, this.forumId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateForumScreenState();
}

class _CreateForumScreenState extends ConsumerState<CreateForumScreen> {
  final GlobalKey _scaffold = GlobalKey();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late double _distanceToField;
  late StringTagController _stringTagController;
  bool isChecked = false;

  void createForum() {
    List<String>? tags = _stringTagController.getTags;

    if (titleController.text.trim().isNotEmpty) {
      ref.read(forumControllerProvider.notifier).createForum(
          widget.forumId,
          titleController.text.trim(),
          descriptionController.text.trim(),
          isChecked,
          tags,
          _scaffold.currentContext!);
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

  Widget bodyOfScaffold() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
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
                  borderSide: BorderSide(
                    color: Pallete.forumTagColor,
                  ),
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
                  borderSide: BorderSide(color: Pallete.forumTagColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              maxLines: 3,
              maxLength: 1000,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldTags<String>(
              textfieldTagsController: _stringTagController,
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
                    _stringTagController.getFocusNode?.requestFocus();
                  },
                  controller: inputFieldValues.textEditingController,
                  focusNode: inputFieldValues.focusNode,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(
                        RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
                  ],
                  decoration: InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Pallete.forumTagColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Pallete.forumTagColor),
                    ),
                    hintText:
                        inputFieldValues.tags.isNotEmpty ? '' : "Enter tag",
                    errorText: inputFieldValues.error,
                    prefixIconConstraints:
                        BoxConstraints(maxWidth: _distanceToField * 0.8),
                    prefixIcon: inputFieldValues.tags.isNotEmpty
                        ? SingleChildScrollView(
                            controller: inputFieldValues.tagScrollController,
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
                                  children:
                                      inputFieldValues.tags.map((String tag) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0),
                                        ),
                                        color: Pallete.forumTagColor,
                                      ),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          InkWell(
                                            child: Text(
                                              '#$tag',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            onTap: () {
                                              // print("$tag selected");
                                            },
                                          ),
                                          const SizedBox(width: 4.0),
                                          InkWell(
                                            child: const Icon(
                                              Icons.cancel,
                                              size: 14.0,
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            onTap: () {
                                              inputFieldValues
                                                  .onTagRemoved(tag);
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
                    List<String>? tags = _stringTagController.getTags;

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
              height: 20,
            ),
            ElevatedButton(
              onPressed: createForum,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                backgroundColor: Pallete.forumColor,
              ),
              child: const Text(
                'Create Forum',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(forumControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    if (widget.forumId != null) {
      return ref.watch(getForumByIdProvider(widget.forumId!)).when(
            data: (forum) {
              return Scaffold(
                key: _scaffold,
                backgroundColor: currentTheme.scaffoldBackgroundColor,
                appBar: AppBar(
                  title: Text(
                    'Create Forum in ${forum!.title}',
                    softWrap: true,
                    maxLines: 5,
                    style: TextStyle(
                      color: currentTheme.textTheme.bodyMedium!.color!,
                    ),
                  ),
                ),
                body: Stack(
                  children: <Widget>[
                    bodyOfScaffold(),
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
    } else {
      return Scaffold(
        key: _scaffold,
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Create Forum',
            style: TextStyle(
              color: currentTheme.textTheme.bodyMedium!.color!,
            ),
          ),
        ),
        body: Stack(
          children: <Widget>[
            bodyOfScaffold(),
            Container(
              child: isLoading ? const Loader() : Container(),
            )
          ],
        ),
      );
    }
  }
}
