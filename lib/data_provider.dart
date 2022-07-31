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
  /// persentase bunga deposito
  num interest = 5.5;
  num taxPercent = 20;

  /// date type
  Datetype dateType = Datetype.period;
  DateRepository dateData = DatePeriod(
    period: 3,
    periodType: PeriodType.month,
  );

  /// modal deposito / rp yang didepositokan
  num? nominalFund;

  /// profit bunga dalam sebulan
  num? profitInterestPerMonth;

  /// profit bunga dalam setahun
  num? profitIntersetPerYear;

  /// profit bunga total
  num? profitInterestTotal;

  /// pajak total
  num? taxTotal;

  /// profit netto : profitInterestTotal - taxTotal
  num? profitNetto;

  /// nominalFund + profitNetto
  num? profitNominalTotal;

  String profitInterestTotalFormula(DateRepository dateData) {
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

  String profitIntersetPerMonthFormula(DateRepository dateData) {
    //(Q = A * B% * (100 - C) / 100 * (P / E))
    return "${NumberConversion.toCurrency(nominalFund!)} x $interest% x (100% - $taxPercent%) x (${dateData.monthDateCount} hari / ${dateData.annualDateCount}) hari =";
  }

  String nominalFundFormula(DateRepository dateData) {
    return "${NumberConversion.toCurrency(profitInterestPerMonth!)} / ($interest% x (100% - $taxPercent%) x (${dateData.monthDateCount} hari / ${dateData.annualDateCount}) hari) =";
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
  }) {
    this.nominalFund = nominalFund;
    this.interest = interest;
    this.taxPercent = taxPercent;
    this.dateType = dateType;
    this.dateData = dateData;
    this.profitInterestPerMonth = profitInterestPerMonth;
    this.profitInterestTotal = profitInterestTotal;
    this.taxTotal = taxTotal;
    this.profitNetto = profitNetto;
    this.profitNominalTotal = profitNominalTotal;
  }

  ResultData copywith({
    num? nominalFund,
    num? interest,
    num? taxPercent,
    Datetype? dateType,
    DateRepository? dateData,
    num? profitInterestPerMonth,
    num? profitInterestTotal,
    num? taxTotal,
    num? profitNetto,
    num? profitNominalTotal,
  }) {
    return ResultData(
      nominalFund: nominalFund ?? this.nominalFund!,
      interest: interest ?? this.interest,
      dateType: dateType ?? this.dateType,
      dateData: dateData ?? this.dateData,
      taxPercent: taxPercent ?? this.taxPercent,
      profitInterestPerMonth:
          profitInterestPerMonth ?? this.profitInterestPerMonth,
      profitInterestTotal: profitInterestTotal ?? this.profitInterestTotal,
      taxTotal: taxTotal ?? this.taxTotal,
      profitNetto: profitNetto ?? this.profitNetto,
      profitNominalTotal: profitNominalTotal ?? this.profitNominalTotal,
    );
  }
}

class NominalData extends DepositoData {
  NominalData({
    num? nominalFund,
    required num interest,
    required num taxPercent,
    required Datetype dateType,
    required DateRepository dateData,
    required num profitInterestPerMonth,
    num? profitInterestTotal,
    num? taxTotal,
    num? profitNetto,
    num? profitNominalTotal,
  }) {
    this.nominalFund = nominalFund;
    this.interest = interest;
    this.taxPercent = taxPercent;
    this.dateType = dateType;
    this.dateData = dateData;
    this.profitInterestPerMonth = profitInterestPerMonth;
    this.profitInterestTotal = profitInterestTotal;
    this.taxTotal = taxTotal;
    this.profitNetto = profitNetto;
    this.profitNominalTotal = profitNominalTotal;
  }

  NominalData copywith({
    num? nominalFund,
    num? interest,
    num? taxPercent,
    Datetype? dateType,
    DateRepository? dateData,
    num? profitInterestPerMonth,
    num? profitInterestTotal,
    num? taxTotal,
    num? profitNetto,
    num? profitNominalTotal,
  }) {
    return NominalData(
      nominalFund: nominalFund ?? this.nominalFund,
      interest: interest ?? this.interest,
      dateType: dateType ?? this.dateType,
      dateData: dateData ?? this.dateData,
      taxPercent: taxPercent ?? this.taxPercent,
      profitInterestPerMonth:
          profitInterestPerMonth ?? this.profitInterestPerMonth!,
      profitInterestTotal: profitInterestTotal ?? this.profitInterestTotal,
      taxTotal: taxTotal ?? this.taxTotal,
      profitNetto: profitNetto ?? this.profitNetto,
      profitNominalTotal: profitNominalTotal ?? this.profitNominalTotal,
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
    dateType: Datetype.period,
    dateData: DatePeriod(period: 3, periodType: PeriodType.month),
    taxPercent: 20,
  );

  NominalData _nominalData = NominalData(
    profitInterestPerMonth: 3000000,
    interest: 5.50,
    dateType: Datetype.dateRange,
    taxPercent: 20,
    dateData: DatePeriod(period: 3, periodType: PeriodType.month),
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

  void setDateType(Datetype dateType, {DepositoData? data = null}) {
    if (data != null) data.dateType = dateType;
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
    DateRepository dateR =
        dateType == Datetype.period ? _datePeriod : _dateRange;
    num profitInterestTotal = _resultData.nominalFund! *
        (_resultData.interest / 100) *
        (dateR.dateCount / dateR.annualDateCount);
    num taxTotal = profitInterestTotal * _resultData.taxPercent / 100;
    num profitNetto = profitInterestTotal - taxTotal;
    num profitNominalTotal = _resultData.nominalFund! + profitNetto;
    num profitInterestPerMonth = _resultData.nominalFund! *
        (_resultData.interest / 100) *
        ((100 - _resultData.taxPercent) / 100) *
        dateR.monthDateCount /
        dateR.annualDateCount;

    _resultData = _resultData.copywith(
      profitInterestTotal: profitInterestTotal,
      profitNominalTotal: profitNominalTotal,
      profitInterestPerMonth: profitInterestPerMonth,
      profitNetto: profitNetto,
      taxTotal: taxTotal,
    );
  }

  void calculateResultNominal() {
    DateRepository dateR =
        dateType == Datetype.period ? _datePeriod : _dateRange;
    num nominalFund = (_nominalData.profitInterestPerMonth ?? 0) /
        ((_nominalData.interest / 100) *
            ((100 - _nominalData.taxPercent) / 100) *
            (dateR.monthDateCount / dateR.annualDateCount));
    num profitInterestTotal = (nominalFund) *
        ((_nominalData.interest / 100) *
            (dateR.dateCount / dateR.annualDateCount));
    num taxTotal = profitInterestTotal * _nominalData.taxPercent / 100;
    num profitNetto = profitInterestTotal - taxTotal;
    num profitNominalTotal = nominalFund + profitNetto;

    _nominalData = _nominalData.copywith(
      nominalFund: nominalFund,
      profitInterestTotal: profitInterestTotal,
      profitNominalTotal: profitNominalTotal,
      profitNetto: profitNetto,
      taxTotal: taxTotal,
    );
  }
}
