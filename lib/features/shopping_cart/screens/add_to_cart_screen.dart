import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class AddToCartScreen extends ConsumerStatefulWidget {
  final String serviceId;
  const AddToCartScreen({super.key, required this.serviceId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddToCartScreenState();
}

class _AddToCartScreenState extends ConsumerState<AddToCartScreen> {
  final GlobalKey _scaffold = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);

    return Scaffold(
      key: _scaffold,
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Add to Cart ${widget.serviceId}',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12.0),
        child: Container(
          alignment: Alignment.topCenter,
          child: const Text(
            'No items in cart',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ),
    );
  }
}
