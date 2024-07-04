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
  String selectedType = ServiceType.physical.value;
  String selectedFrequencyUnit = FrequencyUnit.hour.value;
  String selectedSizeUnit = SizeUnit.meter.value;
  String selectedWeightUnit = WeightUnit.kilogram.value;
  bool isChecked = true;
  var isLoaded = false;

  void save(Service service) {
    // if (titleController.text.trim().isNotEmpty) {
    //   service = service.copyWith(
    //     title: titleController.text.trim(),
    //     titleLowercase: titleController.text.trim().toLowerCase(),
    //     public: isChecked,
    //   );
    //   // ref.read(serviceControllerProvider.notifier).updateService(
    //   //     service: service,
    //   //     context: _scaffold.currentContext!);
    // }
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
              _lengthController.text = service.length.toString();
              _widthController.text = service.width.toString();
              _heightController.text = service.height.toString();
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
                              height: 20,
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
                                  isDense: true,
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
                            const SizedBox(
                              height: 10,
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Frequency',
                                  style: TextStyle(
                                    color: Pallete.greyColor,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  width: 80,
                                  child: TextFormField(
                                    controller: _frequencyController,
                                    decoration:
                                        const InputDecoration(hintText: 'None'),
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
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
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
