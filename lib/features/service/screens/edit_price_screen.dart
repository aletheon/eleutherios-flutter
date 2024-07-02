import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:textfield_tags/textfield_tags.dart';

class EditPriceScreen extends ConsumerStatefulWidget {
  final String serviceId;
  const EditPriceScreen({super.key, required this.serviceId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditPriceScreenState();
}

class _EditPriceScreenState extends ConsumerState<EditPriceScreen> {
  final GlobalKey _scaffold = GlobalKey();
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  late double _distanceToField;
  late StringTagController _stringTagController;
  bool isChecked = false;
  var isLoaded = false;

  void save(Service service) {
    List<String>? tags = _stringTagController.getTags;

    if (titleController.text.trim().isNotEmpty) {
      service = service.copyWith(
        title: titleController.text.trim(),
        titleLowercase: titleController.text.trim().toLowerCase(),
        description: descriptionController.text.trim(),
        public: isChecked,
        tags: tags,
      );
      // ref.read(serviceControllerProvider.notifier).updateService(
      //     service: service,
      //     context: _scaffold.currentContext!);
    }
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
    final isLoading = ref.watch(serviceControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);

    return ref
        .watch(
          getServiceByIdProvider(widget.serviceId),
        )
        .when(
          data: (service) {
            if (isLoaded == false) {
              titleController.text = service!.title;
              descriptionController.text = service.description;
              isChecked = service.public;
              isLoaded = true;
            }

            return Scaffold(
              key: _scaffold,
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'Edit Price',
                  style: TextStyle(
                    color: currentTheme.textTheme.bodyMedium!.color!,
                  ),
                ),
                centerTitle: false,
                actions: [
                  TextButton(
                    onPressed: () => save(service!),
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
                              activeColor: Pallete.freeServiceColor,
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
                                      color: Pallete.freeServiceTagColor),
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
                                  borderSide: BorderSide(
                                      color: Pallete.freeServiceTagColor),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              maxLines: 5,
                              maxLength: 1000,
                            ),
                            const SizedBox(
                              height: 10,
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
