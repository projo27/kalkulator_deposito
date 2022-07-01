import 'package:flutter/material.dart';
import 'package:kalkulator_deposito/const.dart';

class NominalCalculator extends StatelessWidget {
  const NominalCalculator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Hasil Perbulan',
            style: Textstyle.title,
          ),
          Text(
            'Menghitung berapa modal yang Anda butuhkan untuk mendapatkan hasil yang diinginkan',
            textAlign: TextAlign.center,
            style: Textstyle.body,
          ),
        ],
      ),
    );
  }
}
