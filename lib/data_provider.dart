import 'package:flutter/material.dart';

enum Datetype { dateRange, period }

enum PeriodType { month, year }

class ResultData {
  num nominalFund;
  num interest;
  Datetype dateType;
  num? resultNominal;
  num? resultInterest;

  ResultData({
    required this.nominalFund,
    required this.interest,
    required this.dateType,
    this.resultNominal,
    this.resultInterest,
  });

  copywith({
    num? nominalFund,
    num? interest,
    Datetype? dateType,
    num? resultNominal,
    num? resultInterest,
  }) {
    return ResultData(
      nominalFund: nominalFund ?? this.nominalFund,
      interest: interest ?? this.interest,
      dateType: dateType ?? this.dateType,
      resultNominal: resultNominal ?? this.resultNominal,
      resultInterest: resultInterest ?? this.resultInterest,
    );
  }
}

class NominalData {
  double resultInterest;
  double interest;
  Datetype dateType;
  double? nominalFund;
  double? resultNominal;

  NominalData({
    required this.resultInterest,
    required this.resultNominal,
    required this.interest,
    required this.dateType,
    this.nominalFund,
  });

  copywith({
    double? nominalFund,
    double? interest,
    Datetype? dateType,
    double? resultNominal,
    double? resultInterest,
  }) {
    return NominalData(
      nominalFund: nominalFund ?? this.nominalFund,
      interest: interest ?? this.interest,
      dateType: dateType ?? this.dateType,
      resultNominal: resultNominal ?? this.resultNominal,
      resultInterest: resultInterest ?? this.resultInterest,
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

  DatePeriod({
    required this.period,
    required this.periodType,
  });
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
    resultNominal: null,
    resultInterest: null,
  );

  NominalData _nominalData = NominalData(
    resultInterest: 0,
    resultNominal: null,
    interest: 0,
    dateType: Datetype.dateRange,
    nominalFund: null,
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
