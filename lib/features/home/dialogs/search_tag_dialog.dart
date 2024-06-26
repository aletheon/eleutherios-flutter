import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:textfield_tags/textfield_tags.dart';

class SearchTagDialog extends ConsumerStatefulWidget {
  final String searchType;
  final List<String> initialTags;
  const SearchTagDialog(
      {super.key, required this.searchType, required this.initialTags});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SearchTagDialogState();
}

class _SearchTagDialogState extends ConsumerState<SearchTagDialog> {
  late double _distanceToField;
  late StringTagController _stringTagController;

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
  Widget build(BuildContext context) {
    return Dialog(
      //shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      //backgroundColor: Colors.transparent,
      child: _buildChild(context),
    );
  }

  _buildChild(BuildContext context) => Container(
        height: 150,
        decoration: const BoxDecoration(
            // color: Colors.redAccent,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          children: <Widget>[
            TextFieldTags<String>(
              textfieldTagsController: _stringTagController,
              initialTags: widget.initialTags,
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
                      borderSide: BorderSide(
                        color: widget.searchType == SearchType.policy.name
                            ? Pallete.policyTagColor
                            : widget.searchType == SearchType.forum.name
                                ? Pallete.forumTagColor
                                : Pallete.freeServiceTagColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.searchType == SearchType.policy.name
                            ? Pallete.policyTagColor
                            : widget.searchType == SearchType.forum.name
                                ? Pallete.forumTagColor
                                : Pallete.freeServiceTagColor,
                      ),
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
                                        color: widget.searchType ==
                                                SearchType.policy.name
                                            ? Pallete.policyTagColor
                                            : widget.searchType ==
                                                    SearchType.forum.name
                                                ? Pallete.forumTagColor
                                                : Pallete.freeServiceTagColor,
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
                        context: context,
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
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    return Navigator.of(context)
                        .pop(_stringTagController.getTags);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Pallete.policyColor,
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      );
}




  

    // return Dialog(
    //                 context: context,
    //                 barrierDismissible: true,
    //                 builder: (context) {
    //                   return AlertDialog(
    //                     content: TextFieldTags<String>(
    //                       textfieldTagsController: _stringTagController,
    //                       textSeparators: const [' ', ','],
    //                       letterCase: LetterCase.small,
    //                       validator: (String tag) {
    //                         if (_stringTagController.getTags!.contains(tag)) {
    //                           return 'You\'ve already entered that';
    //                         }
    //                         return null;
    //                       },
    //                       inputFieldBuilder: (context, inputFieldValues) {
    //                         return TextField(
    //                           onTap: () {
    //                             _stringTagController.getFocusNode
    //                                 ?.requestFocus();
    //                           },
    //                           controller:
    //                               inputFieldValues.textEditingController,
    //                           focusNode: inputFieldValues.focusNode,
    //                           inputFormatters: [
    //                             FilteringTextInputFormatter.deny(
    //                                 RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
    //                           ],
    //                           decoration: InputDecoration(
    //                             isDense: true,
    //                             border: OutlineInputBorder(
    //                               borderSide:
    //                                   BorderSide(color: Pallete.forumTagColor),
    //                             ),
    //                             focusedBorder: OutlineInputBorder(
    //                               borderSide:
    //                                   BorderSide(color: Pallete.forumTagColor),
    //                             ),
    //                             hintText: inputFieldValues.tags.isNotEmpty
    //                                 ? ''
    //                                 : "Enter tag",
    //                             errorText: inputFieldValues.error,
    //                             prefixIconConstraints: BoxConstraints(
    //                                 maxWidth: _distanceToField * 0.8),
    //                             prefixIcon: inputFieldValues.tags.isNotEmpty
    //                                 ? SingleChildScrollView(
    //                                     controller: inputFieldValues
    //                                         .tagScrollController,
    //                                     scrollDirection: Axis.vertical,
    //                                     child: Padding(
    //                                       padding: const EdgeInsets.only(
    //                                         top: 8,
    //                                         bottom: 8,
    //                                         left: 8,
    //                                       ),
    //                                       child: Wrap(
    //                                           runSpacing: 4.0,
    //                                           spacing: 4.0,
    //                                           children: inputFieldValues.tags
    //                                               .map((String tag) {
    //                                             return Container(
    //                                               decoration: BoxDecoration(
    //                                                 borderRadius:
    //                                                     const BorderRadius.all(
    //                                                   Radius.circular(20.0),
    //                                                 ),
    //                                                 color:
    //                                                     Pallete.forumTagColor,
    //                                               ),
    //                                               margin: const EdgeInsets
    //                                                   .symmetric(
    //                                                   horizontal: 5.0),
    //                                               padding: const EdgeInsets
    //                                                   .symmetric(
    //                                                   horizontal: 10.0,
    //                                                   vertical: 5.0),
    //                                               child: Row(
    //                                                 mainAxisAlignment:
    //                                                     MainAxisAlignment.start,
    //                                                 mainAxisSize:
    //                                                     MainAxisSize.min,
    //                                                 children: [
    //                                                   InkWell(
    //                                                     child: Text(
    //                                                       '#$tag',
    //                                                       style:
    //                                                           const TextStyle(
    //                                                               color: Colors
    //                                                                   .white),
    //                                                     ),
    //                                                     onTap: () {
    //                                                       // print("$tag selected");
    //                                                     },
    //                                                   ),
    //                                                   const SizedBox(
    //                                                       width: 4.0),
    //                                                   InkWell(
    //                                                     child: const Icon(
    //                                                       Icons.cancel,
    //                                                       size: 14.0,
    //                                                       color: Color.fromARGB(
    //                                                           255,
    //                                                           233,
    //                                                           233,
    //                                                           233),
    //                                                     ),
    //                                                     onTap: () {
    //                                                       inputFieldValues
    //                                                           .onTagRemoved(
    //                                                               tag);
    //                                                     },
    //                                                   )
    //                                                 ],
    //                                               ),
    //                                             );
    //                                           }).toList()),
    //                                     ),
    //                                   )
    //                                 : null,
    //                           ),
    //                           onChanged: inputFieldValues.onTagChanged,
    //                           onSubmitted: (tag) {
    //                             List<String>? tags =
    //                                 _stringTagController.getTags;

    //                             if (tags != null && tags.length >= 5) {
    //                               showDialog(
    //                                 context: context,
    //                                 barrierDismissible: true,
    //                                 builder: (context) {
    //                                   String message =
    //                                       "You have reached the limit of 5 tags";

    //                                   return AlertDialog(
    //                                     content: Text(message),
    //                                     actions: [
    //                                       TextButton(
    //                                         onPressed: () {
    //                                           Navigator.of(context).pop();
    //                                         },
    //                                         child: const Text('Close'),
    //                                       ),
    //                                     ],
    //                                   );
    //                                 },
    //                               );
    //                             } else {
    //                               inputFieldValues.onTagSubmitted(tag);
    //                             }
    //                           },
    //                         );
    //                       },
    //                     ),
    //                     actions: [
    //                       TextButton(
    //                         onPressed: () {
    //                           Navigator.of(context)
    //                               .pop(_stringTagController.getTags);
    //                         },
    //                         child: const Text('Close'),
    //                       ),
    //                     ],
    //                   );
    //                 },
    //               );
    // return Container();