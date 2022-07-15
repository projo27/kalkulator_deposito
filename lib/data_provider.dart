import 'package:flutter/material.dart';

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

class ResultData {
  num nominalFund;
  num interest;
  Datetype dateType;
  num taxPercent;
  num? resultNominal;
  num? resultInterest;
  num? resultTax;

  ResultData(
      {required this.nominalFund,
      required this.interest,
      required this.dateType,
      required this.taxPercent,
      this.resultNominal,
      this.resultInterest,
      this.resultTax});

  copywith({
    num? nominalFund,
    num? interest,
    Datetype? dateType,
    num? taxPercent,
    num? resultNominal,
    num? resultInterest,
    num? resultTax,
  }) {
    return ResultData(
      nominalFund: nominalFund ?? this.nominalFund,
      interest: interest ?? this.interest,
      dateType: dateType ?? this.dateType,
      taxPercent: taxPercent ?? this.taxPercent,
      resultNominal: resultNominal ?? this.resultNominal,
      resultInterest: resultInterest ?? this.resultInterest,
      resultTax: resultTax ?? this.resultTax,
    );
  }
}

class NominalData {
  num resultInterest;
  num interest;
  Datetype dateType;
  num taxPercent;
  num? nominalFund;
  num? resultNominal;
  num? resultTax;

  NominalData({
    required this.resultInterest,
    required this.interest,
    required this.dateType,
    required this.taxPercent,
    this.nominalFund,
    this.resultNominal,
    this.resultTax,
  });

  copywith({
    num? nominalFund,
    num? interest,
    Datetype? dateType,
    num? taxPercent,
    num? resultNominal,
    num? resultInterest,
    // num? nominalFund,
    // num? resultNominal,
    // num? resultTax,
  }) {
    return NominalData(
      nominalFund: nominalFund ?? this.nominalFund,
      interest: interest ?? this.interest,
      dateType: dateType ?? this.dateType,
      resultNominal: resultNominal ?? this.resultNominal,
      resultInterest: resultInterest ?? this.resultInterest,
      taxPercent: taxPercent ?? this.taxPercent,
    );
  }
}

class DateRange {
  DateTime startDate;
  DateTime endDate;

  DateRange({
    required this.startDate,
    required this.endDate,
  });
}

class DatePeriod {
  int period;
  PeriodType periodType;
  String? description;

  DatePeriod({
    required this.period,
    required this.periodType,
  }) {
    description = "${period.toString()}  ${periodTypeToString(periodType)}";
  }

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

class DataProvider extends ChangeNotifier {
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
    resultInterest: 0,
    resultNominal: null,
    interest: 0,
    dateType: Datetype.dateRange,
    taxPercent: 20,
  );

  ResultData get resultData => _resultData;
  NominalData get nominalData => _nominalData;
  Datetype get dateType => _dateType;
  DateRange get dateRange => _dateRange;
  DatePeriod get datePeriod => _datePeriod;

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

  void set resultData(data) {
    _resultData = data;
    notifyListeners();
  }

  void setNominalData(NominalData data) {
    _nominalData = data;
    notifyListeners();
  }
}
