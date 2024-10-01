import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/constants/constants.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/auth/controller/auth_controller.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
    as currency_text_input_formatter;

class EditServiceScreen extends ConsumerStatefulWidget {
  final String serviceId;
  const EditServiceScreen({super.key, required this.serviceId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditServiceScreenState();
}

class _EditServiceScreenState extends ConsumerState<EditServiceScreen> {
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
  bool isLoaded = false;

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

  void save(Service service) {
    final errorMessage = StringBuffer();
    RegExp doubleRegex = RegExp(
      r'(^\d*\.?\d*)$',
      caseSensitive: false,
      multiLine: false,
    );
    List<String>? tags = _stringTagController.getTags;

    // title
    if (_titleController.text.trim().isEmpty) {
      errorMessage.write('Title is required.');
    }

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

    if (errorMessage.isNotEmpty) {
      showSnackBar(context, errorMessage.toString(), true);
    } else {
      service = service.copyWith(
        title: _titleController.text.trim(),
        titleLowercase: _titleController.text.trim().toLowerCase(),
        description: _descriptionController.text.trim(),
        public: isPublic,
        tags: tags,
        type: selectedType,
        canBeOrdered: isOrderable,
        price: _priceController.text.isEmpty
            ? -1
            : double.parse(
                _priceController.text.replaceAll(RegExp(r'[^0-9.]'), '')),
        imageFileName: profileFileName,
        imageFileType: profileFileType,
        bannerFileName: bannerFileName,
        bannerFileType: bannerFileType,
      );

      if (selectedType == ServiceType.physical.value) {
        service = service.copyWith(
          quantity: _quantityController.text.isEmpty
              ? -1
              : int.parse(_quantityController.text),
          frequency: -1,
          frequencyUnit: '',
          length: _lengthController.text.isEmpty
              ? -1
              : double.parse(_lengthController.text),
          width: _widthController.text.isEmpty
              ? -1
              : double.parse(_widthController.text),
          height: _heightController.text.isEmpty
              ? -1
              : double.parse(_heightController.text),
          sizeUnit: selectedSizeUnit,
          weight: _weightController.text.isEmpty
              ? -1
              : double.parse(_weightController.text),
          weightUnit: selectedWeightUnit == '' ? null : selectedWeightUnit,
        );
      } else {
        service = service.copyWith(
          quantity: _quantityController.text.isEmpty
              ? -1
              : int.parse(_quantityController.text),
          frequency: _frequencyController.text.isEmpty
              ? -1
              : double.parse(_frequencyController.text),
          frequencyUnit:
              selectedFrequencyUnit == 'None' ? '' : selectedFrequencyUnit,
          sizeUnit: '',
          length: 0,
          width: 0,
          height: 0,
          weightUnit: '',
          weight: 0,
        );
      }
      ref.read(serviceControllerProvider.notifier).updateService(
          profileFile: profileFile,
          bannerFile: bannerFile,
          service: service,
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

    return ref
        .watch(
          getServiceByIdProvider(widget.serviceId),
        )
        .when(
          data: (service) {
            if (isLoaded == false) {
              _titleController.text = service!.title;
              _descriptionController.text = service.description;
              isPublic = service.public;
              isOrderable = service.canBeOrdered;
              selectedType = service.type;
              selectedFrequencyUnit =
                  service.frequencyUnit == '' ? 'None' : service.frequencyUnit;
              selectedSizeUnit = service.sizeUnit == ''
                  ? SizeUnit.meter.value
                  : service.sizeUnit;
              selectedWeightUnit = service.weightUnit == ''
                  ? WeightUnit.kilogram.value
                  : service.weightUnit;

              _priceController.text = service.price == -1 || service.price == 0
                  ? ''
                  : NumberFormat.currency(
                          symbol: '${service.currency} ',
                          locale: 'en_US',
                          decimalDigits: 2)
                      .format(service.price);
              _frequencyController.text =
                  service.frequency == -1 || service.frequency == 0
                      ? ''
                      : service.frequency.toString();
              _quantityController.text =
                  service.quantity == -1 || service.quantity == 0
                      ? ''
                      : service.quantity.toString();
              _lengthController.text =
                  service.length == -1 || service.length == 0
                      ? ''
                      : service.length.toString();
              _widthController.text = service.width == -1 || service.width == 0
                  ? ''
                  : service.width.toString();
              _heightController.text =
                  service.height == -1 || service.height == 0
                      ? ''
                      : service.height.toString();
              _weightController.text = service.weight.toString();
              isLoaded = true;
            }

            return Scaffold(
              key: _scaffold,
              backgroundColor: currentTheme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Text(
                  'Edit Service',
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
              body: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 10.0, right: 10.0, left: 10.0, bottom: 50.0),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
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
                                            : service!.banner.isEmpty ||
                                                    service.banner ==
                                                        Constants
                                                            .serviceBannerDefault
                                                ? const Center(
                                                    child: Icon(
                                                      Icons.camera_alt_outlined,
                                                      size: 40,
                                                    ),
                                                  )
                                                : Image.network(
                                                    service.banner,
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
                                          : service!.image ==
                                                  Constants.avatarDefault
                                              ? CircleAvatar(
                                                  backgroundImage:
                                                      Image.asset(service.image)
                                                          .image,
                                                  radius: 32,
                                                )
                                              : CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      service.image),
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
                                              .replaceAll(
                                                  RegExp(r'[^0-9.]'), '')) >
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
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
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
                                              .replaceAll(
                                                  RegExp(r'[^0-9.]'), '')) >
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
                            selectedType == ServiceType.physical.value
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                          decoration: selectedType ==
                                                  ServiceType.physical.value
                                              ? const InputDecoration(
                                                  hintText: '0')
                                              : const InputDecoration(
                                                  hintText: 'Unlimited'),
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
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
                                  )
                                : const SizedBox(),
                            selectedType == ServiceType.nonphysical.value
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Frequency',
                                        style: TextStyle(
                                          color: Pallete.greyColor,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          SizedBox(
                                            width: 60,
                                            child: TextFormField(
                                              controller: _frequencyController,
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Size',
                                            style: TextStyle(
                                              color: Pallete.greyColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 60,
                                                child: TextFormField(
                                                  controller: _lengthController,
                                                  decoration:
                                                      const InputDecoration(
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
                                                      overrideDecimalPoint:
                                                          true,
                                                      insertDecimalPoint: false,
                                                      insertDecimalDigits: true,
                                                    ),
                                                  ],
                                                  keyboardType:
                                                      const TextInputType
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
                                                  decoration:
                                                      const InputDecoration(
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
                                                      overrideDecimalPoint:
                                                          true,
                                                      insertDecimalPoint: false,
                                                      insertDecimalDigits: true,
                                                    ),
                                                  ],
                                                  keyboardType:
                                                      const TextInputType
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
                                                  decoration:
                                                      const InputDecoration(
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
                                                      overrideDecimalPoint:
                                                          true,
                                                      insertDecimalPoint: false,
                                                      insertDecimalDigits: true,
                                                    ),
                                                  ],
                                                  keyboardType:
                                                      const TextInputType
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
                                                items: sizeUnitValues.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Weight',
                                            style: TextStyle(
                                              color: Pallete.greyColor,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              SizedBox(
                                                width: 60,
                                                child: TextFormField(
                                                  controller: _weightController,
                                                  decoration:
                                                      const InputDecoration(
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
                                                      overrideDecimalPoint:
                                                          true,
                                                      insertDecimalPoint: false,
                                                      insertDecimalDigits: true,
                                                    ),
                                                  ],
                                                  keyboardType:
                                                      const TextInputType
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
                                                items: weightUnitValues.map<
                                                        DropdownMenuItem<
                                                            String>>(
                                                    (String value) {
                                                  return DropdownMenuItem<
                                                      String>(
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
                                                        RegExp(r'[^0-9.]'),
                                                        '')) >
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
                                                        RegExp(r'[^0-9.]'),
                                                        '')) >
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
                              initialTags:
                                  service!.tags.isNotEmpty ? service.tags : [],
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
                                        color: _priceController
                                                    .text.isNotEmpty &&
                                                double.parse(_priceController
                                                        .text
                                                        .replaceAll(
                                                            RegExp(r'[^0-9.]'),
                                                            '')) >
                                                    0
                                            ? Pallete.paidServiceTagColor
                                            : Pallete.freeServiceTagColor,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: _priceController
                                                    .text.isNotEmpty &&
                                                double.parse(_priceController
                                                        .text
                                                        .replaceAll(
                                                            RegExp(r'[^0-9.]'),
                                                            '')) >
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
                                                        color: _priceController
                                                                    .text
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
                              height: 50,
                            ),
                          ],
                        ),
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
