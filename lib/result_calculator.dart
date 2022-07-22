import 'dart:math';
import 'dart:ui';

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalkulator_deposito/const.dart';
import 'package:kalkulator_deposito/data_provider.dart';
import 'package:kalkulator_deposito/main.dart';
import 'package:kalkulator_deposito/util/currency_text_input_formatter.dart';
import 'package:kalkulator_deposito/util/number_conversion.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

class ResultCalculator extends StatefulWidget {
  const ResultCalculator({
    Key? key,
  }) : super(key: key);

  @override
  State<ResultCalculator> createState() => _ResultCalculatorState();
}

class _ResultCalculatorState extends State<ResultCalculator> {
  late TextEditingController _nominalFundCtrl, _interestCtrl, _taxPercentCtrl;

  CurrencyTextInputFormatter _nominalFundFormatter = CurrencyTextInputFormatter(
          decimalDigits: 0, locale: 'id_ID', symbol: ""),
      _interestFormatter = CurrencyTextInputFormatter(
          decimalDigits: 2, locale: 'id_ID', symbol: ""),
      _resultNominalFormatter = CurrencyTextInputFormatter(
          decimalDigits: 0, locale: 'id_ID', symbol: ""),
      _resultInterestFormatter = CurrencyTextInputFormatter(
          decimalDigits: 2, locale: 'id_ID', symbol: "");

  @override
  void initState() {
    super.initState();
    final DataProvider dataProvider = context.read<DataProvider>();
    final resultData = dataProvider.resultData;

    _nominalFundCtrl = TextEditingController(
      text: _nominalFundFormatter.format(resultData.nominalFund.toString()),
    );
    _interestCtrl = TextEditingController(
      text: resultData.interest.toString(),
      // text: _interestFormatter.format(resultData.interest.toString()),
    );
    _taxPercentCtrl = TextEditingController(
      text: resultData.taxPercent.toString(),
      // text: _interestFormatter.format(resultData.interest.toString()),
    );
  }

  @override
  void dispose() {
    _nominalFundCtrl.dispose();
    _interestCtrl.dispose();
    _taxPercentCtrl.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DataProvider data = Provider.of<DataProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Hasil Deposito',
          style: Textstyle.title.copyWith(
            color: Colour.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Menghitung hasil yang akan Anda dapatkan dari modal / nominal deposito yang diinput ',
          textAlign: TextAlign.center,
          style: Textstyle.caption,
        ),
        const SizedBox(height: 32),
        Focus(
          onFocusChange: (isTrue) {
            if (isTrue) {
              _nominalFundCtrl.text = data.resultData.nominalFund.toString();
            } else {
              _nominalFundCtrl.text = _nominalFundFormatter.format(
                data.resultData.nominalFund.toString(),
              );
            }
          },
          child: TextFormField(
            controller: _nominalFundCtrl,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor(
              'Modal / Nominal Deposito',
              '1.000.000',
              prefix: Text("Rp", style: Textstyle.bodyBold),
              isClearable: true,
              controller: _nominalFundCtrl,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (val) {
              data.resultData = data.resultData.copywith(
                nominalFund: num.parse(val),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Focus(
          onFocusChange: (isTrue) {
            if (isTrue) {
              _interestCtrl.text = data.resultData.interest.toString();
            } else {
              _interestCtrl.text = data.resultData.interest.toString();
            }
          },
          child: TextFormField(
            controller: _interestCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor(
              'Suku Bunga',
              '5,5 % ',
              prefix: Text("%", style: Textstyle.bodyBold),
              isClearable: true,
              controller: _interestCtrl,
            ),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.,]"))
            ],
            onChanged: (val) {
              data.resultData = data.resultData.copywith(
                interest: num.tryParse(val),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Focus(
          onFocusChange: (isTrue) {
            if (isTrue) {
              _interestCtrl.text = data.resultData.interest.toString();
            } else {
              _interestCtrl.text = data.resultData.interest.toString();
            }
          },
          child: TextFormField(
            controller: _taxPercentCtrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor('Pajak', '20 % ',
                prefix: Text("%", style: Textstyle.bodyBold),
                isClearable: true,
                controller: _taxPercentCtrl),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.,]"))
            ],
            onChanged: (val) {
              data.resultData = data.resultData.copywith(
                taxPercent: num.tryParse(val),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        data.dateType == Datetype.dateRange
            ? DateRangeBox(
                onIconPressed: () {
                  data.setDateType(Datetype.period);
                },
              )
            : PeriodListBox(
                onIconPressed: () {
                  data.setDateType(Datetype.dateRange);
                },
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
        actionsPadding: EdgeInsets.all(8),
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
                  value: NumberConversion.toCurrency(data.nominalFund),
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
                DetilItem(
                  label: "Profit Bunga (X = A x B x (D / E))",
                  formula:
                      "${NumberConversion.toCurrency(data.nominalFund)} x ${data.interest} % x ( ${dateRepo.dateCount} hari x  365 hari) =",
                  value: "${NumberConversion.toCurrency(data.resultInterest!)}",
                  valueColor: Colour.primary,
                ),
                DetilItem(
                  label: "Total Pajak (Y = (X x C))",
                  formula:
                      "${NumberConversion.toCurrency(data.resultInterest!)} x ${data.taxPercent} % = ",
                  value: "${NumberConversion.toCurrency(data.resultTax!)}",
                  valueColor: Colour.primary,
                ),
                DetilItem(
                  label: "Hasil Deposito (Z = (X - Y))",
                  formula:
                      "${NumberConversion.toCurrency(data.resultInterest!)} - ${NumberConversion.toCurrency(data.resultTax!)} = ",
                  value:
                      "${NumberConversion.toCurrency(data.resultInterest! - data.resultTax!)}",
                  valueColor: Colour.primary,
                ),
                DetilItem(
                  label: "Nominal Total (Return = (A + Z))",
                  formula:
                      "${NumberConversion.toCurrency(data.nominalFund)} + ${NumberConversion.toCurrency(data.resultInterest! - data.resultTax!)} = ",
                  value: "${NumberConversion.toCurrency(data.resultNominal!)}",
                  valueColor: Colour.primary,
                ),
                DetilItem(
                  label: "Asumsi Jumlah Hari Sebulan (P)",
                  value: "30 Hari",
                ),
                DetilItem(
                  label: "Profit Bunga per Bulan ",
                  desc: " (Q = (A x B x (100% - C) x (P / E)) ",
                  formula:
                      "${NumberConversion.toCurrency(data.nominalFund)} x ${data.interest}% x (100% - ${data.taxPercent}%) x (30 hari / 365 hari) =",
                  value:
                      "${NumberConversion.toCurrency((data.nominalFund * (data.interest / 100) * ((100 - data.taxPercent) / 100)) * (30 / 365))}",
                  valueColor: Colour.primary,
                ),
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
          "Nominal Saat Jatuh Tempo",
          style: Textstyle.subtitle.copyWith(color: Colour.textAccent),
        ),
        const SizedBox(height: 8),
        ResultText(
          value: data.resultData.resultNominal ?? 0,
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
          value: data.resultData.resultInterest ?? 0,
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
          value: data.resultData.resultTax ?? 0,
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

class ResultText extends StatelessWidget {
  const ResultText({
    Key? key,
    required this.value,
    this.style,
  }) : super(key: key);

  final num value;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colour.backgroundContainer,
      elevation: 4,
      child: InkWell(
        onTap: () {
          Clipboard.setData(
            ClipboardData(
              text: value.toString(),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Text coppied to clipboard",
                style: Textstyle.bodySmall.copyWith(color: Colour.text),
              ),
              backgroundColor: Colour.background.withOpacity(0.7),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            right: 8,
            left: 8,
            bottom: 6,
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                NumberConversion.toCurrency(value),
                style: style ??
                    Textstyle.title2.copyWith(
                      color: Colour.primary,
                    ),
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoaderShimmer extends StatelessWidget {
  const LoaderShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FadeShimmer(
          height: 32,
          width: MediaQuery.of(context).size.width,
          radius: 4,
          highlightColor: Colour.text,
          baseColor: Colors.white24,
          millisecondsDelay: 0,
        ),
        const SizedBox(height: 12),
        FadeShimmer(
          height: 32,
          width: MediaQuery.of(context).size.width,
          radius: 4,
          highlightColor: Colour.text,
          baseColor: Colors.white24,
          millisecondsDelay: 50,
        ),
        const SizedBox(height: 12),
        FadeShimmer(
          height: 32,
          width: MediaQuery.of(context).size.width,
          radius: 4,
          highlightColor: Colour.text,
          baseColor: Colors.white24,
          millisecondsDelay: 100,
        ),
      ],
    );
  }
}

class DetilItem extends StatelessWidget {
  DetilItem({
    Key? key,
    required this.label,
    required this.value,
    this.desc,
    this.formula,
    this.valueColor,
  }) : super(key: key);

  final String label;
  final String? desc;
  final String? formula;
  final String value;
  final Color? valueColor;
  final TextStyle _textStyleBody = Textstyle.bodyBold.copyWith(
    color: Colour.background,
  );
  final TextStyle _textStyleBodySmall =
      Textstyle.bodySmall.copyWith(color: Colour.background, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: _textStyleBodySmall.copyWith(color: Colors.grey[600])),
        if (desc != null)
          Text(desc!,
              style: _textStyleBodySmall.copyWith(color: Colors.grey[600])),
        if (formula != null)
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  formula!,
                  style: _textStyleBodySmall.copyWith(
                      fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ),
          ),
        Card(
          color: valueColor ?? Colour.text,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.centerRight,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: _textStyleBody,
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        )
        // Divider(
        //   thickness: 0.5,
        //   color: Colors.grey[400],
        //   // indent: MediaQuery.of(context).size.width,
        //   // indent: MediaQuery.of(context).size.width *
        //   //     (Random().nextDouble() * (0.6 - 0.1) + 0.1),
        // ),
      ],
    );
  }
}

var thousandFormatter = MaskTextInputFormatter(
  mask: '###.###.###',
  filter: {'#': RegExp(r'[0-9]')},
);
