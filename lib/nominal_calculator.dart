import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalkulator_deposito/const.dart';
import 'package:kalkulator_deposito/data_provider.dart';
import 'package:kalkulator_deposito/main.dart';
import 'package:kalkulator_deposito/util/number_conversion.dart';
import 'package:provider/provider.dart';

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
      text: NumberConversion.toCurrency(nominalData.resultPerMonth, symbol: ''),
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
                  data.nominalData.resultPerMonth.toString();
            } else {
              _resultPerMonthCtrl.text = NumberConversion.toCurrency(
                  data.nominalData.resultPerMonth,
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
                  resultPerMonth: 0,
                );
              },
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (val) {
              data.nominalData = data.nominalData.copywith(
                resultPerMonth: num.parse(val),
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
                interest: num.parse(val),
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
                taxPercent: num.parse(val),
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
          elevation: 4,
          color: Colour.text,
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(12),
            child: data.isLoading ? const LoaderShimmer() : Result(),
          ),
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
  final TextStyle _textStyleBodySmall =
      Textstyle.bodySmall.copyWith(color: Colour.background, fontSize: 14);

  showInfo(BuildContext context, ResultData data, DateRepository dateRepo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        actionsPadding: const EdgeInsets.all(8),
        backgroundColor: Colors.grey[300],
        title: Text(
          'Rincian Hasil Deposito',
          style: Textstyle.subtitle.copyWith(color: Colour.background),
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DetilItem(
                  label: "Pokok / Modal (A)",
                  value: NumberConversion.toCurrency(data.nominalFund!),
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
                  label: "Jumlah Hari (D)",
                  value: dateRepo.dateCount.toString() + " Hari",
                ),
                DetilItem(
                  label: "Jumlah Hari Setahun (E)",
                  value: "365 Hari",
                ),
                // SizedBox(
                //   height: 24,
                //   child: Divider(
                //     thickness: 3,
                //     color: Colour.background,
                //   ),
                // ),
                // DetilItem(
                //   label: "Profit Bunga (X = A x B x (D / E))",
                //   formula:
                //       "${NumberConversion.toCurrency(data.nominalFund!)} x ${data.interest} % x ( ${dateRepo.dateCount} hari x  365 hari) =",
                //   value: "${NumberConversion.toCurrency(data.resultInterest!)}",
                //   valueColor: Colour.primary,
                // ),
                // DetilItem(
                //   label: "Total Pajak (Y = (X x C))",
                //   formula:
                //       "${NumberConversion.toCurrency(data.resultInterest!)} x ${data.taxPercent} % = ",
                //   value: "${NumberConversion.toCurrency(data.resultTax!)}",
                //   valueColor: Colour.primary,
                // ),
                // DetilItem(
                //   label: "Hasil Deposito (Z = (X - Y))",
                //   formula:
                //       "${NumberConversion.toCurrency(data.resultInterest!)} - ${NumberConversion.toCurrency(data.resultTax!)} = ",
                //   value:
                //       "${NumberConversion.toCurrency(data.resultInterest! - data.resultTax!)}",
                //   valueColor: Colour.primary,
                // ),
                // DetilItem(
                //   label: "Nominal Total (Return = (A + Z))",
                //   formula:
                //       "${NumberConversion.toCurrency(data.nominalFund!)} + ${NumberConversion.toCurrency(data.resultInterest! - data.resultTax!)} = ",
                //   value: "${NumberConversion.toCurrency(data.resultNominal!)}",
                //   valueColor: Colour.primary,
                // ),
                // DetilItem(
                //   label: "Asumsi Jumlah Hari Sebulan (P)",
                //   value: "30 Hari",
                // ),
                // DetilItem(
                //   label: "Profit Bunga Deposito per Bulan ",
                //   desc: " (Q = (A x B x (100% - C) x (P / E)) ",
                //   formula:
                //       "${NumberConversion.toCurrency(data.nominalFund!)} x ${data.interest}% x (100% - ${data.taxPercent}%) x (30 hari / 365 hari) =",
                //   value:
                //       "${NumberConversion.toCurrency((data.nominalFund! * (data.interest / 100) * ((100 - data.taxPercent) / 100)) * (30 / 365))}",
                //   valueColor: Colour.primary,
                // ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton.icon(
            icon: Icon(
              Icons.share,
              color: Colour.background,
              size: 16,
            ),
            label: Text('SHARE', style: _textStyleBody),
            onPressed: () => Navigator.pop(context),
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
        Text(
          "Modal Deposito yg Dibutuhkan",
          style: Textstyle.subtitle.copyWith(color: Colour.textAccent),
        ),
        const SizedBox(height: 8),
        ResultText(
          value: data.nominalData.resultNominal ?? 0,
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
          value: data.nominalData.resultInterest ?? 0,
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
          value: data.nominalData.resultTax ?? 0,
          style: Textstyle.title2.copyWith(
            color: Colour.primary,
          ),
        ),
        const Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {
                showInfo(
                  context,
                  data.resultData,
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
              onPressed: () {},
              icon: const Icon(
                Icons.share,
                size: 24,
              ),
              color: Colour.backgroundContainer,
            ),
          ],
        ),
      ],
    );
  }
}
