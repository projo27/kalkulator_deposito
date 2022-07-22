import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kalkulator_deposito/const.dart';
import 'package:kalkulator_deposito/data_provider.dart';
import 'package:kalkulator_deposito/nominal_calculator.dart';
import 'package:kalkulator_deposito/result_calculator.dart';
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
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('id', 'ID'),
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
      body: SizedBox(
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
                            (0.2 * MediaQuery.of(context).size.width / 2),
                        vertical: 48),
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
                        width: 0.8 * MediaQuery.of(context).size.width,
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
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Icon(
                                  Icons.money,
                                  color: Colour.text,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                  primary: Colour.backgroundContainer,
                                  onSurface: Colour.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 12)),
                              // color: Colour.background,
                            ),
                            const SizedBox(width: 64),
                            ElevatedButton(
                              onPressed: _page == ThePage.nominal
                                  ? null
                                  : () {
                                      setPage(ThePage.nominal);
                                    },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Icon(
                                  Icons.attach_money,
                                  color: Colour.text,
                                ),
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

  void _showDateRangePicker(BuildContext context, DataProvider data) {
    showDateRangePicker(
      context: context,
      firstDate: data.dateRange.startDate,
      lastDate: data.dateRange.endDate,
      locale: const Locale("id", "ID"),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colour.background,
            colorScheme: ColorScheme.light(primary: Colour.background),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        data.dateRange.startDate = value.start;
        data.dateRange.endDate = value.end;
      }
    });
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
            onTap: () {
              _showDateRangePicker(context, data);
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
            onTap: () {
              _showDateRangePicker(context, data);
            },
          ),
        ),
        const SizedBox(width: 5),
        IconButton(
          onPressed: this.onIconPressed,
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
