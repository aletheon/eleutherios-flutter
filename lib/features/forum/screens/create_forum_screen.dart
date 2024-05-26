import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/forum/controller/forum_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

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
  bool isChecked = false;

  void createForum() {
    if (titleController.text.trim().isNotEmpty) {
      ref.read(forumControllerProvider.notifier).createForum(
          widget.forumId,
          titleController.text.trim(),
          descriptionController.text.trim(),
          isChecked,
          _scaffold.currentContext!);
    }
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
      child: Column(
        children: [
          const SizedBox(
            height: 5,
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
                borderSide: const BorderSide(color: Colors.blue),
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
                borderSide: const BorderSide(color: Colors.blue),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            maxLines: 8,
            maxLength: 1000,
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
                  body: isLoading ? const Loader() : bodyOfScaffold());
            },
            error: (error, stackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          );
    } else {
      return Scaffold(
          backgroundColor: currentTheme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Create Forum',
              style: TextStyle(
                color: currentTheme.textTheme.bodyMedium!.color!,
              ),
            ),
          ),
          body: isLoading ? const Loader() : bodyOfScaffold());
    }
  }
}
