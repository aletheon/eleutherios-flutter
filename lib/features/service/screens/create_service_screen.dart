import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
    as currency_text_input_formatter;

class CreateServiceScreen extends ConsumerStatefulWidget {
  const CreateServiceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CreateServiceScreenState();
}

class _CreateServiceScreenState extends ConsumerState<CreateServiceScreen> {
  final GlobalKey _scaffold = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _quantityController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  List<String> serviceTypeValues = [
    ServiceType.physical.value,
    ServiceType.nonphysical.value
  ];
  List<String> frequencyUnitValues = [
    'None',
    FrequencyUnit.minute.value,
    FrequencyUnit.hour.value,
    FrequencyUnit.day.value,
    FrequencyUnit.week.value,
    FrequencyUnit.month.value,
    FrequencyUnit.year.value,
  ];
  List<String> sizeUnitValues = [
    SizeUnit.nanometer.value,
    SizeUnit.millimeter.value,
    SizeUnit.centimeter.value,
    SizeUnit.meter.value,
    SizeUnit.inch.value,
    SizeUnit.foot.value,
    SizeUnit.yard.value,
  ];
  List<String> weightUnitValues = [
    WeightUnit.picogram.value,
    WeightUnit.nanogram.value,
    WeightUnit.microgram.value,
    WeightUnit.milligram.value,
    WeightUnit.gram.value,
    WeightUnit.kilogram.value,
    WeightUnit.tonne.value,
  ];
  String selectedType = ServiceType.nonphysical.value;
  String selectedFrequencyUnit = 'None';
  String selectedSizeUnit = SizeUnit.meter.value;
  String selectedWeightUnit = WeightUnit.kilogram.value;
  late double _distanceToField;
  late StringTagController _stringTagController;
  final NumberFormat numFormat = NumberFormat("######.0#", "en_US");
  bool isPublic = false;
  bool isOrderable = false;

  void createService() {
    final errorMessage = StringBuffer();
    RegExp doubleRegex = RegExp(
      r'(^\d*\.?\d*)$',
      caseSensitive: false,
      multiLine: false,
    );
    String type = selectedType;
    bool canBeOrdered = isOrderable;
    double price = _priceController.text.isEmpty
        ? -1
        : double.parse(
            _priceController.text.replaceAll(RegExp(r'[^0-9.]'), ''));
    int quantity = _quantityController.text.isEmpty
        ? -1
        : int.parse(_quantityController.text);
    double frequency = -1;
    String frequencyUnit = '';
    double length = _lengthController.text.isEmpty
        ? -1
        : double.parse(_lengthController.text);
    double width = _widthController.text.isEmpty
        ? -1
        : double.parse(_widthController.text);
    double height = _heightController.text.isEmpty
        ? -1
        : double.parse(_heightController.text);
    String sizeUnit = selectedSizeUnit;
    double weight = _weightController.text.isEmpty
        ? -1
        : double.parse(_weightController.text);
    String? weightUnit = selectedWeightUnit == '' ? null : selectedWeightUnit;

    // validate physical properties
    if (selectedType == ServiceType.physical.value) {
      // length
      if (_lengthController.text.isEmpty ||
          doubleRegex.hasMatch(_lengthController.text) == false ||
          double.parse(_lengthController.text) <= 0) {
        errorMessage.write('Length is required in the format 9.99.\n');
      }

      // width
      if (_widthController.text.isEmpty ||
          doubleRegex.hasMatch(_widthController.text) == false ||
          double.parse(_widthController.text) <= 0) {
        errorMessage.write('Width is required in the format 9.99.\n');
      }

      // height
      if (_heightController.text.isEmpty ||
          doubleRegex.hasMatch(_heightController.text) == false ||
          double.parse(_heightController.text) <= 0) {
        errorMessage.write('Height is required in the format 9.99.\n');
      }

      // weight
      if (_weightController.text.isEmpty ||
          doubleRegex.hasMatch(_weightController.text) == false ||
          double.parse(_weightController.text) <= 0) {
        errorMessage.write('Weight is required in the format 9.99.\n');
      }
    }

    // validate price
    if (_priceController.text.isNotEmpty) {
      if (!doubleRegex
          .hasMatch(_priceController.text.replaceAll(RegExp(r'[^0-9.]'), ''))) {
        errorMessage.write('Price is invalid and must be in the format 9.99.');
      }
    }

    // title
    if (_titleController.text.trim().isEmpty) {
      errorMessage.write('Title is required.');
    }

    if (errorMessage.isNotEmpty) {
      showSnackBar(context, errorMessage.toString(), true);
    } else {
      List<String>? tags = _stringTagController.getTags;
      ref.read(serviceControllerProvider.notifier).createService(
          _titleController.text.trim(),
          _descriptionController.text.trim(),
          isPublic,
          tags,
          type,
          canBeOrdered,
          price,
          quantity,
          frequency,
          frequencyUnit,
          length,
          width,
          height,
          weight,
          sizeUnit,
          weightUnit,
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
    _priceController.text = '';
    _frequencyController.text = '';
    _quantityController.text = '';
    _lengthController.text = '';
    _widthController.text = '';
    _heightController.text = '';
    _weightController.text = '';
  }

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _frequencyController.dispose();
    _quantityController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _weightController.dispose();
  }

  void changeType(String type) async {
    setState(() {
      selectedType = type;
    });
  }

  void changeFrequency(String frequencyUnit) async {
    setState(() {
      selectedFrequencyUnit = frequencyUnit;
    });
  }

  void changeSize(String sizeUnit) async {
    setState(() {
      selectedSizeUnit = sizeUnit;
    });
  }

  void changeWeight(String weightUnit) async {
    setState(() {
      selectedWeightUnit = weightUnit;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(serviceControllerProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider)!;

    return Scaffold(
      key: _scaffold,
      backgroundColor: currentTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Create Service',
          style: TextStyle(
            color: currentTheme.textTheme.bodyMedium!.color!,
          ),
        ),
      ),
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CheckboxListTile(
                        title: const Text(
                          "Public",
                          style: TextStyle(color: Pallete.greyColor),
                        ),
                        value: isPublic,
                        onChanged: (newValue) {
                          setState(() {
                            isPublic = newValue!;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: _priceController.text.isNotEmpty &&
                                double.parse(_priceController.text
                                        .replaceAll(RegExp(r'[^0-9.]'), '')) >
                                    0
                            ? Pallete.paidServiceColor
                            : Pallete.freeServiceColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Type',
                            style: TextStyle(
                              color: Pallete.greyColor,
                              fontSize: 16,
                            ),
                          ),
                          DropdownButton(
                            //itemHeight: 55,
                            value: selectedType,
                            onChanged: (String? selectedType) {
                              if (selectedType is String) {
                                changeType(selectedType);
                              }
                            },
                            items: serviceTypeValues
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      CheckboxListTile(
                        title: const Text(
                          "Orderable",
                          style: TextStyle(color: Pallete.greyColor),
                        ),
                        value: isOrderable,
                        onChanged: (newValue) {
                          setState(() {
                            isOrderable = newValue!;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.trailing,
                        activeColor: _priceController.text.isNotEmpty &&
                                double.parse(_priceController.text
                                        .replaceAll(RegExp(r'[^0-9.]'), '')) >
                                    0
                            ? Pallete.paidServiceColor
                            : Pallete.freeServiceColor,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                              color: Pallete.greyColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: TextField(
                              controller: _priceController,
                              decoration:
                                  const InputDecoration(hintText: 'Free'),
                              inputFormatters: <TextInputFormatter>[
                                currency_text_input_formatter
                                    .CurrencyTextInputFormatter.currency(
                                  //locale: 'ko',
                                  decimalDigits: 2,
                                  symbol: '${user.stripeCurrency} ',
                                ),
                              ],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Quantity',
                            style: TextStyle(
                              color: Pallete.greyColor,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _quantityController,
                              decoration:
                                  selectedType == ServiceType.physical.value
                                      ? const InputDecoration(hintText: '0')
                                      : const InputDecoration(
                                          hintText: 'Unlimited'),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(6),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'[-]')),
                                FilteringTextInputFormatter.deny(
                                    RegExp(r'[ ]')),
                              ],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      selectedType == ServiceType.nonphysical.value
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  'Frequency',
                                  style: TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      child: TextFormField(
                                        controller: _frequencyController,
                                        decoration: const InputDecoration(
                                          hintText: 'None',
                                          contentPadding:
                                              EdgeInsets.fromLTRB(6, 6, 6, 6),
                                        ),
                                        inputFormatters: <TextInputFormatter>[
                                          NumberTextInputFormatter(
                                            integerDigits: 10,
                                            decimalDigits: 2,
                                            maxValue: '1000000000.00',
                                            decimalSeparator: '.',
                                            groupDigits: 3,
                                            groupSeparator: ',',
                                            allowNegative: false,
                                            overrideDecimalPoint: true,
                                            insertDecimalPoint: false,
                                            insertDecimalDigits: true,
                                          ),
                                        ],
                                        keyboardType: const TextInputType
                                            .numberWithOptions(
                                          decimal: true,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    DropdownButton(
                                      itemHeight: 65,
                                      value: selectedFrequencyUnit,
                                      onChanged: (String? frequency) {
                                        if (frequency is String) {
                                          changeFrequency(frequency);
                                        }
                                      },
                                      items: frequencyUnitValues
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Size',
                                      style: TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: TextFormField(
                                            controller: _lengthController,
                                            decoration: const InputDecoration(
                                              hintText: 'L',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      6, 6, 6, 6),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              NumberTextInputFormatter(
                                                integerDigits: 10,
                                                decimalDigits: 2,
                                                maxValue: '1000000000.00',
                                                decimalSeparator: '.',
                                                // groupDigits: 3,
                                                // groupSeparator: ',',
                                                allowNegative: false,
                                                overrideDecimalPoint: true,
                                                insertDecimalPoint: false,
                                                insertDecimalDigits: true,
                                              ),
                                            ],
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              decimal: true,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: TextFormField(
                                            controller: _widthController,
                                            decoration: const InputDecoration(
                                              hintText: 'W',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      6, 6, 6, 6),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              NumberTextInputFormatter(
                                                integerDigits: 10,
                                                decimalDigits: 2,
                                                maxValue: '1000000000.00',
                                                decimalSeparator: '.',
                                                // groupDigits: 3,
                                                // groupSeparator: ',',
                                                allowNegative: false,
                                                overrideDecimalPoint: true,
                                                insertDecimalPoint: false,
                                                insertDecimalDigits: true,
                                              ),
                                            ],
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              decimal: true,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        SizedBox(
                                          width: 60,
                                          child: TextFormField(
                                            controller: _heightController,
                                            decoration: const InputDecoration(
                                              hintText: 'H',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      6, 6, 6, 6),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              NumberTextInputFormatter(
                                                integerDigits: 10,
                                                decimalDigits: 2,
                                                maxValue: '1000000000.00',
                                                decimalSeparator: '.',
                                                // groupDigits: 3,
                                                // groupSeparator: ',',
                                                allowNegative: false,
                                                overrideDecimalPoint: true,
                                                insertDecimalPoint: false,
                                                insertDecimalDigits: true,
                                              ),
                                            ],
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              decimal: true,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        DropdownButton(
                                          itemHeight: 65,
                                          value: selectedSizeUnit,
                                          onChanged: (String? size) {
                                            if (size is String) {
                                              changeSize(size);
                                            }
                                          },
                                          items: sizeUnitValues
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      'Weight',
                                      style: TextStyle(
                                        color: Pallete.greyColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 60,
                                          child: TextFormField(
                                            controller: _weightController,
                                            decoration: const InputDecoration(
                                              hintText: 'None',
                                              contentPadding:
                                                  EdgeInsets.fromLTRB(
                                                      6, 6, 6, 6),
                                            ),
                                            inputFormatters: <TextInputFormatter>[
                                              NumberTextInputFormatter(
                                                integerDigits: 10,
                                                decimalDigits: 2,
                                                maxValue: '1000000000.00',
                                                decimalSeparator: '.',
                                                groupDigits: 3,
                                                groupSeparator: ',',
                                                allowNegative: false,
                                                overrideDecimalPoint: true,
                                                insertDecimalPoint: false,
                                                insertDecimalDigits: true,
                                              ),
                                            ],
                                            keyboardType: const TextInputType
                                                .numberWithOptions(
                                              decimal: true,
                                            ),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        DropdownButton(
                                          itemHeight: 65,
                                          value: selectedWeightUnit,
                                          onChanged: (String? weight) {
                                            if (weight is String) {
                                              changeWeight(weight);
                                            }
                                          },
                                          items: weightUnitValues
                                              .map<DropdownMenuItem<String>>(
                                                  (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _priceController.text.isNotEmpty &&
                                      double.parse(_priceController.text
                                              .replaceAll(
                                                  RegExp(r'[^0-9.]'), '')) >
                                          0
                                  ? Pallete.paidServiceTagColor
                                  : Pallete.freeServiceTagColor,
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
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          filled: true,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(18),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: _priceController.text.isNotEmpty &&
                                      double.parse(_priceController.text
                                              .replaceAll(
                                                  RegExp(r'[^0-9.]'), '')) >
                                          0
                                  ? Pallete.paidServiceTagColor
                                  : Pallete.freeServiceTagColor,
                            ),
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
                                borderSide: BorderSide(
                                  color: _priceController.text.isNotEmpty &&
                                          double.parse(_priceController.text
                                                  .replaceAll(
                                                      RegExp(r'[^0-9.]'), '')) >
                                              0
                                      ? Pallete.paidServiceTagColor
                                      : Pallete.freeServiceTagColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: _priceController.text.isNotEmpty &&
                                          double.parse(_priceController.text
                                                  .replaceAll(
                                                      RegExp(r'[^0-9.]'), '')) >
                                              0
                                      ? Pallete.paidServiceTagColor
                                      : Pallete.freeServiceTagColor,
                                ),
                              ),
                              hintText: inputFieldValues.tags.isNotEmpty
                                  ? ''
                                  : "Enter tag",
                              errorText: inputFieldValues.error,
                              prefixIconConstraints: BoxConstraints(
                                  maxWidth: _distanceToField * 0.8),
                              prefixIcon: inputFieldValues.tags.isNotEmpty
                                  ? SingleChildScrollView(
                                      controller:
                                          inputFieldValues.tagScrollController,
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
                                                      const BorderRadius.all(
                                                    Radius.circular(20.0),
                                                  ),
                                                  color: _priceController.text
                                                              .isNotEmpty &&
                                                          double.parse(_priceController
                                                                  .text
                                                                  .replaceAll(
                                                                      RegExp(
                                                                          r'[^0-9.]'),
                                                                      '')) >
                                                              0
                                                      ? Pallete
                                                          .paidServiceTagColor
                                                      : Pallete
                                                          .freeServiceTagColor,
                                                ),
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 5.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    InkWell(
                                                      child: Text(
                                                        '#$tag',
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
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
                        onPressed: createService,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: _priceController.text.isNotEmpty &&
                                  double.parse(_priceController.text
                                          .replaceAll(RegExp(r'[^0-9.]'), '')) >
                                      0
                              ? Pallete.paidServiceColor
                              : Pallete.freeServiceColor,
                        ),
                        child: const Text(
                          'Create Service',
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
