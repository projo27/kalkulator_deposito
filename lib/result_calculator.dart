import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalkulator_deposito/const.dart';
import 'package:kalkulator_deposito/data_provider.dart';
import 'package:kalkulator_deposito/main.dart';
import 'package:kalkulator_deposito/util/currency_text_input_formatter.dart';
import 'package:kalkulator_deposito/util/number_conversion.dart';
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

  final CurrencyTextInputFormatter _nominalFundFormatter =
      CurrencyTextInputFormatter(decimalDigits: 0, locale: 'id_ID', symbol: "");

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
              onClear: () {
                _nominalFundCtrl.clear();
                data.resultData = data.resultData.copywith(
                  nominalFund: null,
                );
              },
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
              onClear: () {
                _interestCtrl.clear();
                data.resultData = data.resultData.copywith(
                  interest: null,
                );
              },
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
            decoration: inputDecor(
              'Pajak',
              '20 % ',
              prefix: Text("%", style: Textstyle.bodyBold),
              isClearable: true,
              onClear: () {
                _taxPercentCtrl.clear();
                data.resultData = data.resultData.copywith(
                  taxPercent: null,
                );
              },
            ),
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
                  // "${NumberConversion.toCurrency(data.nominalFund!)} + ${NumberConversion.toCurrency(data.resultInterest! - data.resultTax!)} = ",
                  value: NumberConversion.toCurrency(data.profitNominalTotal!),
                  valueColor: Colour.primary,
                ),
                DetilItem(
                  label: "Asumsi Jumlah Hari Sebulan (P)",
                  value: "30 Hari",
                ),
                DetilItem(
                  label: "Profit Bunga Deposito per Bulan (Q = (P / E) x Z) ",
                  formula: data.profitIntersetPerMonthFormula(dateRepo),
                  value: NumberConversion.toCurrency(
                    data.profitInterestPerMonth!,
                  ),
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
          value: data.resultData.profitNominalTotal ?? 0,
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
          value: data.resultData.profitInterestTotal ?? 0,
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
          value: data.resultData.taxTotal ?? 0,
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
