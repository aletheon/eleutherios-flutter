import 'package:currency_text_input_formatter/currency_text_input_formatter.dart'
    as currency_text_input_formatter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:number_text_input_formatter/number_text_input_formatter.dart';
import 'package:reddit_tutorial/core/common/error_text.dart';
import 'package:reddit_tutorial/core/common/loader.dart';
import 'package:reddit_tutorial/core/enums/enums.dart';
import 'package:reddit_tutorial/core/utils.dart';
import 'package:reddit_tutorial/features/service/controller/service_controller.dart';
import 'package:reddit_tutorial/models/service.dart';
import 'package:reddit_tutorial/theme/pallete.dart';

class EditPriceScreen extends ConsumerStatefulWidget {
  final String serviceId;
  const EditPriceScreen({super.key, required this.serviceId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditPriceScreenState();
}

class _EditPriceScreenState extends ConsumerState<EditPriceScreen> {
  final GlobalKey _scaffold = GlobalKey();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _quantityController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final NumberFormat numFormat = NumberFormat("######.0#", "en_US");
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
  bool isChecked = true;
  var isLoaded = false;

  void save(Service service) {
    final errorMessage = StringBuffer();
    RegExp doubleRegex = RegExp(
      r'(^\d*\.?\d*)$',
      caseSensitive: false,
      multiLine: false,
    );

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
        type: selectedType,
        canBeOrdered: isChecked,
        price: _priceController.text.isEmpty
            ? -1
            : double.parse(
                _priceController.text.replaceAll(RegExp(r'[^0-9.]'), '')),
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
          profileFile: null,
          bannerFile: null,
          service: service,
          context: _scaffold.currentContext!);
    }
  }

  @override
  void dispose() {
    super.dispose();
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

    return ref
        .watch(
          getServiceByIdProvider(widget.serviceId),
        )
        .when(
          data: (service) {
            if (isLoaded == false) {
              selectedType = service!.type;
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
                  'Edit Price & Type',
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
                      padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Type',
                                    style: TextStyle(
                                      color: Pallete.greyColor,
                                      fontSize: 16,
                                    ),
                                  ),
                                  DropdownButton(
                                    itemHeight: 65,
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
                                value: isChecked,
                                onChanged: (newValue) {
                                  setState(() {
                                    isChecked = newValue!;
                                  });
                                },
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.trailing,
                                activeColor: Pallete.freeServiceColor,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                      decoration: const InputDecoration(
                                          hintText: 'Free'),
                                      inputFormatters: <TextInputFormatter>[
                                        currency_text_input_formatter
                                                .CurrencyTextInputFormatter
                                            .currency(
                                          //locale: 'ko',
                                          decimalDigits: 2,
                                          symbol: '${service!.currency} ',
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
                                                controller:
                                                    _frequencyController,
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
                                                    overrideDecimalPoint: true,
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
                                              value: selectedFrequencyUnit,
                                              onChanged: (String? frequency) {
                                                if (frequency is String) {
                                                  changeFrequency(frequency);
                                                }
                                              },
                                              items: frequencyUnitValues.map<
                                                      DropdownMenuItem<String>>(
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
                                                    controller:
                                                        _lengthController,
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
                                                        maxValue:
                                                            '1000000000.00',
                                                        decimalSeparator: '.',
                                                        // groupDigits: 3,
                                                        // groupSeparator: ',',
                                                        allowNegative: false,
                                                        overrideDecimalPoint:
                                                            true,
                                                        insertDecimalPoint:
                                                            false,
                                                        insertDecimalDigits:
                                                            true,
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
                                                    controller:
                                                        _widthController,
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
                                                        maxValue:
                                                            '1000000000.00',
                                                        decimalSeparator: '.',
                                                        // groupDigits: 3,
                                                        // groupSeparator: ',',
                                                        allowNegative: false,
                                                        overrideDecimalPoint:
                                                            true,
                                                        insertDecimalPoint:
                                                            false,
                                                        insertDecimalDigits:
                                                            true,
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
                                                    controller:
                                                        _heightController,
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
                                                        maxValue:
                                                            '1000000000.00',
                                                        decimalSeparator: '.',
                                                        // groupDigits: 3,
                                                        // groupSeparator: ',',
                                                        allowNegative: false,
                                                        overrideDecimalPoint:
                                                            true,
                                                        insertDecimalPoint:
                                                            false,
                                                        insertDecimalDigits:
                                                            true,
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
                                                    controller:
                                                        _weightController,
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
                                                        maxValue:
                                                            '1000000000.00',
                                                        decimalSeparator: '.',
                                                        groupDigits: 3,
                                                        groupSeparator: ',',
                                                        allowNegative: false,
                                                        overrideDecimalPoint:
                                                            true,
                                                        insertDecimalPoint:
                                                            false,
                                                        insertDecimalDigits:
                                                            true,
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
                                    )
                            ],
                          ),
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
