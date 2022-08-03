// ignore_for_file: must_be_immutable

import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:kalkulator_deposito/const.dart';
import 'package:kalkulator_deposito/data_provider.dart';
import 'package:kalkulator_deposito/nominal_calculator.dart';
import 'package:kalkulator_deposito/result_calculator.dart';
import 'package:kalkulator_deposito/util/number_conversion.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Apps());
}

class Apps extends StatelessWidget {
  const Apps({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<DataProvider>(create: (_) => DataProvider())
      ],
      builder: (context, child) => MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('id', 'ID'),
        ],
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: Colour.primary),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ThePage _page = ThePage.nominal;
  Widget content = const ResultCalculator();

  @override
  void initState() {
    super.initState();
    _page = ThePage.result;
  }

  getContent(ThePage page) {
    switch (page) {
      case ThePage.nominal:
        return const NominalCalculator();
      case ThePage.result:
        return const ResultCalculator();
    }
  }

  setPage(ThePage page) {
    setState(() {
      _page = page;
      content = getContent(page);
    });
  }

  @override
  Widget build(BuildContext context) {
    DataProvider data = context.watch<DataProvider>();
    return Scaffold(
      backgroundColor: Colour.background,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height - 60,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal:
                            (0.15 * MediaQuery.of(context).size.width / 2),
                        vertical: 48,
                      ),
                      child: content,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colour.background.withOpacity(0),
                        Colour.backgroundContainer
                      ],
                    ),
                  ),
                  // color: LinearGradient(colors: [Colour.primary, Colour.secondary]),
                  height: 120,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colour.text,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                          ),
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          width: 0.85 * MediaQuery.of(context).size.width,
                          height: 72,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: _page == ThePage.result
                                    ? null
                                    : () {
                                        setPage(ThePage.result);
                                      },
                                child: Image.asset(
                                  'assets/images/rp_icon_result.png',
                                  color: _page == ThePage.result
                                      ? Colors.grey[400]
                                      : Colors.grey[50],
                                ),
                                // Icon(
                                //   Icons.money,
                                //   color: Colour.text,
                                // ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colour.backgroundContainer,
                                  onSurface: Colour.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                // color: Colour.background,
                              ),
                              const SizedBox(width: 64),
                              ElevatedButton(
                                onPressed: _page == ThePage.nominal
                                    ? null
                                    : () {
                                        setPage(ThePage.nominal);
                                      },
                                child: Image.asset(
                                  'assets/images/rp_icon_nominal.png',
                                  color: _page == ThePage.nominal
                                      ? Colors.grey[400]
                                      : Colors.grey[50],
                                ),
                                style: ElevatedButton.styleFrom(
                                  primary: Colour.backgroundContainer,
                                  onSurface: Colour.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12),
                                ),
                                // color: Colour.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              data.calculateData();
                            },
                            icon: Icon(
                              Icons.calculate,
                              color: Colour.backgroundContainer,
                            ),
                            label: Text(
                              "HITUNG",
                              style: Textstyle.bodyBold
                                  .copyWith(color: Colour.backgroundContainer),
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
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 18,
                top: 18,
                child: Icon(
                  Icons.feedback,
                  color: Colour.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PeriodListBox extends StatelessWidget {
  PeriodListBox({Key? key, this.onIconPressed}) : super(key: key);
  final Function()? onIconPressed;

  TextEditingController periodCtrl = TextEditingController();

  final List<DatePeriod> _periodData = periodData;

  showPeriodList(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (context, idx) {
                DataProvider data = context.watch<DataProvider>();
                bool selected =
                    data.datePeriod.description == _periodData[idx].description;
                return ListTile(
                  title: Text(
                    _periodData[idx].description ?? "",
                    style: Textstyle.body.copyWith(
                      color: selected ? Colors.white : Colour.textAccent,
                    ),
                  ),
                  onTap: () {
                    data.setDatePeriod(
                      DatePeriod(
                        period: _periodData[idx].period,
                        periodType: _periodData[idx].periodType,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  selected: selected,
                  selectedTileColor: Colour.primaryContainer,
                );
              },
              itemCount: _periodData.length,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DataProvider data = context.read<DataProvider>();
    periodCtrl.text = data.datePeriod.description ?? "";

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: periodCtrl,
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor('Periode', '1 Tahun'),
            readOnly: true,
            onTap: () {
              showPeriodList(context);
            },
            // inputFormatters: [DecimalInputFormatter()],
          ),
        ),
        IconButton(
          onPressed: onIconPressed,
          icon: Icon(
            Icons.date_range_outlined,
            color: Colour.text,
          ),
          color: Colour.text,
        ),
      ],
    );
  }
}

class DateRangeBox extends StatelessWidget {
  DateRangeBox({Key? key, this.onIconPressed}) : super(key: key);
  final Function()? onIconPressed;

  TextEditingController dateStartCtrl = TextEditingController(),
      dateEndCtrl = TextEditingController();

  Future<DateTimeRange?> _showDateRangePicker(BuildContext context) async {
    DataProvider data = context.read<DataProvider>();
    return await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365 * 50)),
      lastDate: DateTime.now().add(const Duration(days: 50 * 365)),
      initialDateRange: DateTimeRange(
        start: data.dateRange.startDate,
        end: data.dateRange.endDate,
      ),
      locale: const Locale("id", "ID"),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colour.background,
            colorScheme: ColorScheme.light(primary: Colour.background),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    DataProvider data = context.watch<DataProvider>();

    dateStartCtrl.text = DateFormat("dd/MM/yyy").format(
      data.dateRange.startDate,
    );
    dateEndCtrl.text = DateFormat("dd/MM/yyy").format(
      data.dateRange.endDate,
    );

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            controller: dateStartCtrl,
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor('Awal Pendanaan', '31/08/2022'),
            readOnly: true,
            onTap: () async {
              DateTimeRange? dtr = await _showDateRangePicker(context);
              if (dtr != null) {
                data.setDateRange(
                  DateRange(startDate: dtr.start, endDate: dtr.end),
                );
              }
            },
            // inputFormatters: [DecimalInputFormatter()],
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: TextFormField(
            controller: dateEndCtrl,
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor('Akhir Pendanaan', '31/08/2023'),
            readOnly: true,
            onTap: () async {
              DateTimeRange? dtr = await _showDateRangePicker(context);
              if (dtr != null) {
                data.setDateRange(
                  DateRange(startDate: dtr.start, endDate: dtr.end),
                );
              }
            },
          ),
        ),
        const SizedBox(width: 5),
        IconButton(
          onPressed: onIconPressed,
          icon: Icon(
            Icons.access_time_rounded,
            color: Colour.text,
          ),
          color: Colour.text,
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
    return Container(
      margin: const EdgeInsets.all(12),
      child: Column(
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
      ),
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
