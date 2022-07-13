import 'package:flutter/material.dart';
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
    return Scaffold(
      backgroundColor: Colour.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: (0.2 * MediaQuery.of(context).size.width / 2),
                      vertical: 48),
                  child: content,
                ),
              ),
            ),
          ),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colour.primaryContainer,
                borderRadius: const BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
              margin: const EdgeInsets.all(20),
              height: 60,
              width: 0.8 * MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _page == ThePage.result
                        ? null
                        : () {
                            setPage(ThePage.result);
                          },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Icon(Icons.money),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: Colour.backgroundContainer,
                        onSurface: Colour.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12)),
                    // color: Colour.background,
                  ),
                  // const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _page == ThePage.nominal
                        ? null
                        : () {
                            setPage(ThePage.nominal);
                          },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Icon(Icons.attach_money),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colour.backgroundContainer,
                      onSurface: Colour.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    // color: Colour.primary,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class PeriodListBox extends StatelessWidget {
  PeriodListBox({Key? key, this.onIconPressed}) : super(key: key);
  final Function()? onIconPressed;

  TextEditingController periodCtrl = TextEditingController();

  final List<DatePeriod> _periodData = [
    DatePeriod(period: 1, periodType: PeriodType.month),
    DatePeriod(period: 3, periodType: PeriodType.month),
    DatePeriod(period: 6, periodType: PeriodType.month),
    DatePeriod(period: 1, periodType: PeriodType.year),
    DatePeriod(period: 3, periodType: PeriodType.year),
  ];

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
                return ListTile(
                  title: Text(
                    _periodData[idx].description ?? "",
                    style: Textstyle.body.copyWith(color: Colour.textAccent),
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
                  selected: data.datePeriod.description ==
                      _periodData[idx].description,
                  selectedTileColor: Colour.primary,
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
  const DateRangeBox({Key? key, this.onIconPressed}) : super(key: key);
  final Function()? onIconPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor('Awal Pendanaan', '31/08/2022'),
            // inputFormatters: [DecimalInputFormatter()],
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: TextFormField(
            textAlign: TextAlign.right,
            style: Textstyle.bodyBold.copyWith(color: Colour.primary),
            cursorColor: Colour.primary,
            decoration: inputDecor('Akhir Pendanaan', '31/08/2023'),
            // inputFormatters: [DecimalInputFormatter()],
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
