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
  final _priceController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _frequencyUnitController = TextEditingController();
  final _quantityController = TextEditingController();
  final _lengthController = TextEditingController();
  final _widthController = TextEditingController();
  final _heightController = TextEditingController();
  final _sizeUnitController = TextEditingController();
  final _weightController = TextEditingController();
  final _weightUnitController = TextEditingController();
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
  String selectedFrequency = 'None';
  String selectedSize = SizeUnit.meter.value;
  String selectedWeight = WeightUnit.kilogram.value;
  bool isChecked = true;
  var isLoaded = false;

  void save(Service service) {
    print('canBeOrdered $isChecked');
    print('price ${_priceController.text}');
    print('type $selectedType');
    print('frequency ${_frequencyController.text}');
    print('frequencyUnit $selectedFrequency');
    print('quantity ${_quantityController.text}');
    print('height ${_heightController.text}');
    print('length ${_lengthController.text}');
    print('width ${_widthController.text}');
    print('sizeUnit ${_sizeUnitController.text}');
    print('weight ${_weightController.text}');
    print('weightUnit ${_weightUnitController.text}');

    // price,
    // type,
    // frequency,
    // frequencyUnit,
    // quantity,
    // height,
    // length,
    // width,
    // sizeUnit,
    // weight,
    // weightUnit,

    service = service.copyWith(
      type: selectedType,
      canBeOrdered: isChecked,
      price: _priceController.text.isEmpty
          ? null
          : double.parse(_priceController.text),
    );
    if (selectedType == ServiceType.physical.value) {
      service = service.copyWith(
        quantity: int.parse(_quantityController.text),
        length: _lengthController.text.isEmpty
            ? null
            : double.parse(_lengthController.text),
        width: _widthController.text.isEmpty
            ? null
            : double.parse(_widthController.text),
        height: _heightController.text.isEmpty
            ? null
            : double.parse(_heightController.text),
        sizeUnit: selectedSize,
        weight: _weightController.text.isEmpty
            ? null
            : double.parse(_weightController.text),
        weightUnit: selectedWeight,
      );
    } else {
      service = service.copyWith(
        quantity: _quantityController.text.isEmpty
            ? null
            : int.parse(_quantityController.text),
        frequency: _frequencyController.text.isEmpty
            ? null
            : double.parse(_frequencyController.text),
        frequencyUnit: selectedFrequency == 'None' ? null : selectedFrequency,
      );
    }
    ref.read(serviceControllerProvider.notifier).updateService(
        profileFile: null,
        bannerFile: null,
        service: service,
        context: _scaffold.currentContext!);
  }

  @override
  void dispose() {
    super.dispose();
    _priceController.dispose();
    _frequencyController.dispose();
    _frequencyUnitController.dispose();
    _quantityController.dispose();
    _lengthController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    _sizeUnitController.dispose();
    _weightController.dispose();
    _weightUnitController.dispose();
  }

  void changeType(String type) async {
    setState(() {
      selectedType = type;
    });
  }

  void changeFrequency(String frequency) async {
    setState(() {
      selectedFrequency = frequency;
    });
  }

  void changeSize(String size) async {
    setState(() {
      selectedSize = size;
    });
  }

  void changeWeight(String weight) async {
    setState(() {
      selectedWeight = weight;
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
              _priceController.text =
                  service!.price == 0 ? '' : service.price.toString();
              _frequencyController.text =
                  service.frequency == 0 ? '' : service.frequency.toString();
              _frequencyUnitController.text = service.frequencyUnit.toString();
              _quantityController.text =
                  service.quantity == 0 ? '' : service.quantity.toString();
              _lengthController.text =
                  service.length == 0 ? '' : service.length.toString();
              _widthController.text =
                  service.width == 0 ? '' : service.width.toString();
              _heightController.text =
                  service.height == 0 ? '' : service.height.toString();
              _sizeUnitController.text = service.sizeUnit.toString();
              _weightController.text = service.weight.toString();
              _weightUnitController.text = service.weightUnit.toString();
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
                        child: Column(
                          children: [
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
                              controlAffinity: ListTileControlAffinity.trailing,
                              activeColor: Pallete.freeServiceColor,
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
                                        symbol: 'USD ',
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
                                              controller: _frequencyController,
                                              decoration: const InputDecoration(
                                                  hintText: 'None',
                                                  contentPadding:
                                                      EdgeInsets.fromLTRB(
                                                          6, 6, 6, 6)),
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
                                            value: selectedFrequency,
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
                                                              EdgeInsets
                                                                  .fromLTRB(6,
                                                                      6, 6, 6)),
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
                                                              EdgeInsets
                                                                  .fromLTRB(6,
                                                                      6, 6, 6)),
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
                                                              EdgeInsets
                                                                  .fromLTRB(6,
                                                                      6, 6, 6)),
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
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              DropdownButton(
                                                itemHeight: 65,
                                                value: selectedSize,
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
                                                              EdgeInsets
                                                                  .fromLTRB(6,
                                                                      6, 6, 6)),
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
                                                value: selectedWeight,
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
            );
          },
          error: (error, stackTrace) => ErrorText(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
