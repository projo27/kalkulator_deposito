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
            child: data.isLoading ? const LoaderShimmer() : const Result(),
          ),
        ),
        const SizedBox(height: 40)
      ],
    );
  }
}

class Result extends StatelessWidget {
  const Result({Key? key}) : super(key: key);

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
        Card(
          color: Colour.backgroundContainer,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 4,
              right: 8,
              left: 8,
              bottom: 6,
            ),
            child: Text(
              NumberConversion.toCurrency(data.resultData.resultNominal ?? 0),
              style: Textstyle.title.copyWith(
                color: Colour.primary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Total Akumulasi Bunga",
          style: Textstyle.subtitle.copyWith(color: Colour.textAccent),
        ),
        const SizedBox(height: 8),
        Card(
          color: Colour.backgroundContainer,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 4,
              right: 8,
              left: 8,
              bottom: 6,
            ),
            child: Text(
              NumberConversion.toCurrency(data.resultData.resultInterest ?? 0),
              style: Textstyle.title2.copyWith(
                color: Colour.primary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Total Pajak",
          style: Textstyle.subtitle.copyWith(color: Colour.textAccent),
        ),
        const SizedBox(height: 8),
        Card(
          color: Colour.backgroundContainer,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 4,
              right: 8,
              left: 8,
              bottom: 6,
            ),
            child: Text(
              NumberConversion.toCurrency(data.resultData.resultTax ?? 0),
              style: Textstyle.title2.copyWith(
                color: Colour.primary,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),
        const Divider(),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () {},
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

var thousandFormatter = MaskTextInputFormatter(
  mask: '###.###.###',
  filter: {'#': RegExp(r'[0-9]')},
);
