import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalkulator_deposito/const.dart';
import 'package:kalkulator_deposito/data_provider.dart';
import 'package:kalkulator_deposito/main.dart';
import 'package:kalkulator_deposito/result_calculator.dart';
import 'package:kalkulator_deposito/util/number_conversion.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

class NominalCalculator extends StatefulWidget {
  const NominalCalculator({
    Key? key,
  }) : super(key: key);

  @override
  State<NominalCalculator> createState() => _NominalCalculatorState();
}

class _NominalCalculatorState extends State<NominalCalculator> {
  late TextEditingController _resultPerMonthCtrl,
      _interestCtrl,
      _taxPercentCtrl;

  @override
  void initState() {
    super.initState();
    final DataProvider dataProvider = context.read<DataProvider>();
    final nominalData = dataProvider.nominalData;

    _resultPerMonthCtrl = TextEditingController(
      text: NumberConversion.toCurrency(nominalData.profitInterestPerMonth ?? 0,
          symbol: ''),
    );
    _interestCtrl = TextEditingController(
      text: nominalData.interest.toString(),
    );
    _taxPercentCtrl = TextEditingController(
      text: nominalData.taxPercent.toString(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _resultPerMonthCtrl.dispose();
    _interestCtrl.dispose();
    _taxPercentCtrl.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider data = context.watch<DataProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Modal Deposito',
          style: Textstyle.title.copyWith(
            color: Colour.primary,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Menghitung berapa modal yang Anda butuhkan untuk mendapatkan hasil yang diinginkan tiap bulan',
          textAlign: TextAlign.center,
          style: Textstyle.caption,
        ),
        const SizedBox(height: 32),
        Focus(
          onFocusChange: (isTrue) {
            if (isTrue) {
              _resultPerMonthCtrl.text =
                  data.nominalData.profitInterestPerMonth.toString();
            } else {
              _resultPerMonthCtrl.text = NumberConversion.toCurrency(
                  data.nominalData.profitInterestPerMonth!,
                  symbol: '');
            }
          },
          child: TextFormField(
            controller: _resultPerMonthCtrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor(
              'Profit Deposito Per Bulan',
              '1.000.000',
              prefix: Text("Rp", style: Textstyle.bodyBold),
              isClearable: true,
              onClear: () {
                _resultPerMonthCtrl.clear();
                data.nominalData = data.nominalData.copywith(
                  profitInterestPerMonth: 0,
                );
              },
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (val) {
              data.nominalData = data.nominalData.copywith(
                profitInterestPerMonth: num.tryParse(val.isEmpty ? "0" : val),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Focus(
          onFocusChange: (isTrue) {
            if (isTrue) {
              _interestCtrl.text = data.nominalData.interest.toString();
            } else {
              _interestCtrl.text = data.nominalData.interest.toString();
            }
          },
          child: TextFormField(
            controller: _interestCtrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor(
              'Suku Bunga Deposito',
              '5.5',
              prefix: Text("%", style: Textstyle.bodyBold),
              isClearable: true,
              onClear: () {
                _interestCtrl.clear();
                data.nominalData = data.nominalData.copywith(
                  interest: 5.5,
                );
              },
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.,]"))
            ],
            onChanged: (val) {
              data.nominalData = data.nominalData.copywith(
                interest: num.tryParse(val.isEmpty ? "0" : val),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Focus(
          onFocusChange: (isTrue) {
            if (isTrue) {
              _taxPercentCtrl.text = data.nominalData.taxPercent.toString();
            } else {
              _taxPercentCtrl.text = data.nominalData.taxPercent.toString();
            }
          },
          child: TextFormField(
            controller: _taxPercentCtrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor(
              'Pajak Deposito',
              '20',
              prefix: Text("%", style: Textstyle.bodyBold),
              isClearable: true,
              onClear: () {
                _taxPercentCtrl.clear();
                data.nominalData = data.nominalData.copywith(
                  taxPercent: 20,
                );
              },
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.,]"))
            ],
            onChanged: (val) {
              data.nominalData = data.nominalData.copywith(
                taxPercent: num.tryParse(val.isEmpty ? "0" : val),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        data.dateType == Datetype.dateRange
            ? DateRangeBox(
                onIconPressed: () => data.setDateType(Datetype.period),
              )
            : PeriodListBox(
                onIconPressed: () => data.setDateType(Datetype.dateRange),
              ),
        const SizedBox(height: 24),
        Card(
          margin: const EdgeInsets.all(0),
          elevation: 4,
          color: Colour.text,
          child: data.isLoading ? const LoaderShimmer() : Result(),
        ),
        const SizedBox(height: 40)
      ],
    );
  }
}

class Result extends StatelessWidget {
  Result({Key? key}) : super(key: key);
  final TextStyle _textStyleBody = Textstyle.bodyBold.copyWith(
    color: Colour.background,
  );

  ScreenshotController screenshotControllerDetail = ScreenshotController(),
      screenshotControllerResult = ScreenshotController();

  showInfo(BuildContext context, NominalData data, DateRepository dateRepo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(4),
        titlePadding: const EdgeInsets.all(20),
        backgroundColor: Colors.grey[300],
        title: Text(
          'Rincian Hasil Deposito',
          style: Textstyle.subtitle.copyWith(color: Colour.background),
        ),
        content: DetailWindow(
          data: data,
          dateRepo: dateRepo,
          screenshotController: screenshotControllerDetail,
        ),
        actions: [
          TextButton.icon(
            icon: Icon(
              Icons.share,
              color: Colour.background,
              size: 16,
            ),
            label: Text('SHARE', style: _textStyleBody),
            onPressed: () async =>
                screenshotAndShare(context, screenshotControllerDetail),
          ),
          TextButton.icon(
            icon: Icon(
              Icons.thumb_up,
              color: Colour.background,
              size: 16,
            ),
            label: Text('OK', style: _textStyleBody),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    DataProvider data = context.read<DataProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Screenshot(
          controller: screenshotControllerResult,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 12),
            color: Colour.text,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Pokok / Modal Deposito Setahun",
                  style: Textstyle.subtitle.copyWith(color: Colour.textAccent),
                ),
                const SizedBox(height: 8),
                ResultText(
                  value: data.nominalData.nominalFund ?? 0,
                  style: Textstyle.title.copyWith(
                    color: Colour.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Total Akumulasi Bunga",
                  style: Textstyle.subtitle.copyWith(color: Colour.textAccent),
                ),
                const SizedBox(height: 8),
                ResultText(
                  value: data.nominalData.profitInterestTotal ?? 0,
                  style: Textstyle.title2.copyWith(
                    color: Colour.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Total Pajak",
                  style: Textstyle.subtitle.copyWith(color: Colour.textAccent),
                ),
                const SizedBox(height: 8),
                ResultText(
                  value: data.nominalData.taxTotal ?? 0,
                  style: Textstyle.title2.copyWith(
                    color: Colour.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  showInfo(
                    context,
                    data.nominalData,
                    data.dateType == Datetype.period
                        ? data.datePeriod
                        : data.dateRange,
                  );
                },
                icon: const Icon(
                  Icons.info_outline,
                  size: 24,
                ),
                color: Colour.backgroundContainer,
              ),
              IconButton(
                onPressed: () {
                  screenshotAndShare(context, screenshotControllerResult);
                },
                icon: const Icon(
                  Icons.share,
                  size: 24,
                ),
                color: Colour.backgroundContainer,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class DetailWindow extends StatelessWidget {
  const DetailWindow({
    Key? key,
    required this.data,
    required this.dateRepo,
    required this.screenshotController,
  }) : super(key: key);

  final DepositoData data;
  final DateRepository dateRepo;
  final ScreenshotController screenshotController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Screenshot(
          controller: screenshotController,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DetilItem(
                label: "Profit Bunga Deposito per Bulan (Q)",
                // formula: data.profitIntersetPerMonthFormula(dateRepo),
                value: NumberConversion.toCurrency(
                  data.profitInterestPerMonth!,
                ),
              ),
              DetilItem(
                label: "Suku Bunga (B)",
                value: data.interest.toString() + " %",
              ),
              DetilItem(
                label: "Pajak (C)",
                value: data.taxPercent.toString() + " %",
              ),
              DetilItem(
                label: "Asumsi Jumlah Hari Sebulan (P)",
                value: "30 Hari",
              ),
              DetilItem(
                label: "Jumlah Hari (D)",
                value: dateRepo.dateCount.toString() + " Hari",
              ),
              DetilItem(
                label: "Jumlah Hari Setahun (E)",
                value: "365 Hari",
              ),
              DetilItem(
                label: "Pokok / Modal",
                desc: "(A = Q / (B% x (100% - C%) x (P / E)))",
                formula: data.nominalFundFormula(dateRepo),
                value: NumberConversion.toCurrency(data.nominalFund!),
                valueColor: Colour.primary,
              ),
              DetilItem(
                label: "Profit Bunga (X = A x B x (D / E))",
                formula: data.profitInterestTotalFormula(dateRepo),
                value: NumberConversion.toCurrency(data.profitInterestTotal!),
                valueColor: Colour.primary,
              ),
              DetilItem(
                label: "Total Pajak (Y = (X x C))",
                formula: data.taxTotalFormula,
                value: NumberConversion.toCurrency(data.taxTotal!),
                valueColor: Colour.primary,
              ),
              DetilItem(
                label: "Hasil Deposito (Z = (X - Y))",
                formula: data.profitNettoFormula,
                value: NumberConversion.toCurrency(data.profitNetto!),
                valueColor: Colour.primary,
              ),
              DetilItem(
                label: "Nominal Total (Return = (A + Z))",
                formula: data.profitNominalTotalFormula,
                value: NumberConversion.toCurrency(data.profitNominalTotal!),
                valueColor: Colour.primary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
