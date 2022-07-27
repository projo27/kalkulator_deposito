import 'package:flutter/material.dart';
import 'package:kalkulator_deposito/nominal_calculator.dart';
import 'package:kalkulator_deposito/util/number_conversion.dart';

enum ThePage { result, nominal }

enum Datetype { dateRange, period }

enum PeriodType { month, year }

class PeriodData {
  String description;
  int period;
  PeriodType type;

  PeriodData({
    required this.description,
    required this.period,
    required this.type,
  });

  int get dateCount {
    return period * _dateCountOfPeriodType(type);
  }

  int _dateCountOfPeriodType(PeriodType type) {
    switch (type) {
      case PeriodType.month:
        return 30;
      case PeriodType.year:
        return 365;
    }
  }
}

abstract class DepositoData {
  final num interest = 5.5; // persentase bunga deposito
  final num taxPercent = 20; // persentase pajak
  final Datetype dateType = Datetype.period;
  final DateRepository dateData =
      DatePeriod(period: 3, periodType: PeriodType.month);
  late final num? nominalFund; // modal deposito
  late final num? profitInterestPerMonth; // profit bunga dalam sebulan
  late final num? profitInterestTotal; // profit bunga total
  late final num? taxTotal; // pajak total
  late final num? profitNetto; // profit netto profitInterestTotal - taxTotal
  late final num? profitNominalTotal; // nominalFund + profitNetto

  String get profitInterestTotalFormula {
    return "${NumberConversion.toCurrency(nominalFund!)} x $interest % x (${dateData.dateCount} hari / ${dateData.annualDateCount} hari) =";
  }

  String get taxTotalFormula {
    return "${NumberConversion.toCurrency(profitInterestTotal!)} x $taxPercent % = ";
  }

  String get profitNettoFormula {
    return "${NumberConversion.toCurrency(profitInterestTotal!)} - ${NumberConversion.toCurrency(taxTotal!)} = ";
  }

  String get profitNominalTotalFormula {
    return "${NumberConversion.toCurrency(nominalFund!)} + ${NumberConversion.toCurrency(profitNetto!)} = ";
  }

  String get profitIntersetPerMonthFormula {
    return "${NumberConversion.toCurrency(nominalFund!)} x $interest % x (100% - $taxPercent %) x (${dateData.monthDateCount} hari / ${dateData.annualDateCount} hari) =";
  }
}

class ResultData extends DepositoData {
  ResultData({
    required num nominalFund,
    required num interest,
    required num taxPercent,
    required Datetype dateType,
    required DateRepository dateData,
    num? profitInterestPerMonth,
    num? profitInterestTotal,
    num? taxTotal,
    num? profitNetto,
    num? profitNominalTotal,
  }) : super();

  ResultData copywith({
    num? nominalFund,
    num? interest,
    Datetype? dateType,
    DateRepository? dateData,
    num? taxPercent,
    num? resultNominal,
    num? resultInterest,
    num? resultTax,
  }) {
    return ResultData(
      nominalFund: nominalFund ?? this.nominalFund!,
      interest: interest ?? this.interest,
      dateType: dateType ?? this.dateType,
      dateData: dateData ?? this.dateData,
      taxPercent: taxPercent ?? this.taxPercent,
    );
  }
}

class NominalData {
  num resultPerMonth;
  num interest;
  Datetype dateType;
  num taxPercent;
  num? resultNominal;
  num? resultInterest;
  num? resultTax;

  NominalData({
    required this.resultPerMonth,
    required this.interest,
    required this.dateType,
    required this.taxPercent,
    this.resultNominal,
    this.resultInterest,
    this.resultTax,
  });

  NominalData copywith({
    num? resultPerMonth,
    num? interest,
    Datetype? dateType,
    num? taxPercent,
    num? resultNominal,
    num? resultInterest,
    num? resultTax,
  }) {
    return NominalData(
      resultPerMonth: resultPerMonth ?? this.resultPerMonth,
      interest: interest ?? this.interest,
      dateType: dateType ?? this.dateType,
      taxPercent: taxPercent ?? this.taxPercent,
      resultNominal: resultNominal ?? this.resultNominal,
      resultInterest: resultInterest ?? this.resultInterest,
      resultTax: resultTax ?? this.resultTax,
    );
  }
}

abstract class DateRepository {
  int get dateCount;
  int annualDateCount = 365;
  int monthDateCount = 30;
}

class DateRange extends DateRepository {
  DateTime startDate;
  DateTime endDate;

  DateRange({
    required this.startDate,
    required this.endDate,
  });

  @override
  int get dateCount {
    return endDate.difference(startDate).inDays;
  }
}

class DatePeriod extends DateRepository {
  int period;
  PeriodType periodType;
  String? description;

  DatePeriod({
    required this.period,
    required this.periodType,
  }) {
    description = "$period  ${periodTypeToString(periodType)}";
  }

  @override
  int get dateCount {
    return period * _dateCountOfPeriodType(periodType);
  }

  int _dateCountOfPeriodType(PeriodType type) {
    switch (type) {
      case PeriodType.month:
        return 30;
      case PeriodType.year:
        return 365;
    }
  }

  String periodTypeToString(PeriodType type) {
    switch (type) {
      case PeriodType.month:
        return 'Bulan';
      case PeriodType.year:
        return 'Tahun';
    }
  }
}

final List<DatePeriod> periodData = [
  DatePeriod(period: 1, periodType: PeriodType.month),
  DatePeriod(period: 3, periodType: PeriodType.month),
  DatePeriod(period: 6, periodType: PeriodType.month),
  DatePeriod(period: 9, periodType: PeriodType.month),
  DatePeriod(period: 1, periodType: PeriodType.year),
  DatePeriod(period: 2, periodType: PeriodType.year),
  DatePeriod(period: 3, periodType: PeriodType.year),
];

class DataProvider extends ChangeNotifier {
  bool _isLoading = false;
  Datetype _dateType = Datetype.dateRange;
  DateRange _dateRange = DateRange(
    startDate: DateTime.now(),
    endDate: DateTime.now().add(const Duration(days: 365)),
  );

  DatePeriod _datePeriod = DatePeriod(
    period: 1,
    periodType: PeriodType.month,
  );

  ResultData _resultData = ResultData(
    nominalFund: 1000000000,
    interest: 5.50,
    dateType: Datetype.dateRange,
    taxPercent: 20,
  );

  NominalData _nominalData = NominalData(
    resultPerMonth: 3000000,
    interest: 5.50,
    dateType: Datetype.dateRange,
    taxPercent: 20,
    resultNominal: null,
  );

  ResultData get resultData => _resultData;
  NominalData get nominalData => _nominalData;
  Datetype get dateType => _dateType;
  DateRange get dateRange => _dateRange;
  DatePeriod get datePeriod => _datePeriod;
  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setDateType(Datetype dateType) {
    _dateType = dateType;
    notifyListeners();
  }

  void setDateRange(DateRange dateRange) {
    _dateRange = dateRange;
    notifyListeners();
  }

  void setDatePeriod(DatePeriod datePeriod) {
    _datePeriod = datePeriod;
    notifyListeners();
  }

  set resultData(data) {
    _resultData = data;
    notifyListeners();
  }

  set nominalData(NominalData data) {
    _nominalData = data;
    notifyListeners();
  }

  num calculateInterestPerAnual() {
    return _resultData.interest / _datePeriod.dateCount;
  }

  void calculateData() {
    _isLoading = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      calculateResultData();
      calculateResultNominal();
      _isLoading = false;
      notifyListeners();
    });
  }

  void calculateResultData() {
    num resultInterest = _resultData.nominalFund! *
        (_resultData.interest / 100) *
        (_datePeriod.dateCount / 365);
    num resultTax = resultInterest * _resultData.taxPercent / 100;
    num resultNominal = _resultData.nominalFund! + resultInterest - resultTax;

    _resultData = _resultData.copywith(
      resultInterest: resultInterest,
      resultNominal: resultNominal,
      resultTax: resultTax,
    );
  }

  void calculateResultNominal() {}
}
