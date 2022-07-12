import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kalkulator_deposito/const.dart';
import 'package:kalkulator_deposito/data_provider.dart';
import 'package:kalkulator_deposito/main.dart';
import 'package:kalkulator_deposito/util/currency_text_input_formatter.dart';
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
  late TextEditingController _nominalFundCtrl,
      _interestCtrl,
      _resultNominalCtrl,
      _resultInterestCtrl;

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
    _resultNominalCtrl = TextEditingController(
      text: _resultNominalFormatter.format(
        (resultData.resultNominal ?? 0).toString(),
      ),
    );
    _resultInterestCtrl = TextEditingController(
      text: _resultInterestFormatter.format(
        (resultData.resultInterest ?? 0).toString(),
      ),
    );
  }

  @override
  void dispose() {
    _nominalFundCtrl.dispose();
    _interestCtrl.dispose();
    _resultNominalCtrl.dispose();
    _resultInterestCtrl.dispose();

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
            decoration: inputDecor('Modal / Nominal Deposito', '1.000.000',
                prefix: Text("Rp", style: Textstyle.bodyBold)),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            onChanged: (val) {
              data.resultData = data.resultData.copywith(
                nominalFund: num.parse(val),
              );
              // print(data.resultData.nominalFund);
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
            decoration: inputDecor('Suku Bunga', '5,5 % ',
                prefix: Text("%", style: Textstyle.bodyBold),
                isClearable: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.,]"))
              //_interestFormatter
            ],
            onChanged: (val) {
              data.resultData = data.resultData.copywith(
                interest: num.tryParse(val),
              );
              // print(data.resultData.interest);
            },
          ),
        ),
        const SizedBox(height: 12),
        const DateRangeBox(),
        const SizedBox(height: 12),
        TextFormField(
          controller: _resultNominalCtrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          style: Textstyle.bodyBold.copyWith(color: Colour.primary),
          cursorColor: Colour.primary,
          decoration: inputDecor('Nominal Jatuh Tempo', '1.000.000',
              prefix: Text("Rp", style: Textstyle.bodyBold)),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _resultNominalFormatter
          ],
          onChanged: (val) {
            data.resultData = data.resultData.copywith(
              resultNominal: _resultNominalFormatter.getUnformattedValue(),
            );
            print(data.resultData.resultNominal);
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _resultInterestCtrl,
          keyboardType: TextInputType.number,
          textAlign: TextAlign.right,
          style: Textstyle.bodyBold.copyWith(color: Colour.primary),
          cursorColor: Colour.primary,
          decoration: inputDecor(
            'Total Akumulasi Bunga',
            '',
            prefix: Text("Rp", style: Textstyle.bodyBold),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _resultInterestFormatter
          ],
          onChanged: (val) {
            data.resultData = data.resultData.copywith(
              resultInterest: _resultInterestFormatter.getUnformattedValue(),
            );
            print(data.resultData.resultInterest);
          },
        ),
        Text(data.resultData.nominalFund.toString()),
        const SizedBox(height: 40),
        SizedBox(
          height: 60,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: Icon(
              Icons.calculate,
              color: Colour.textAccent,
            ),
            label: Text(
              "HITUNG",
              style: Textstyle.bodyBold.copyWith(color: Colour.textAccent),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colour.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
            ),
          ),
        ),
        const SizedBox(height: 42)
      ],
    );
  }
}

var thousandFormatter = MaskTextInputFormatter(
  mask: '###.###.###',
  filter: {'#': RegExp(r'[0-9]')},
);
