import 'package:covid_app/Model/WorldStatesModel.dart';
import 'package:covid_app/Services/states_services.dart';
import 'package:covid_app/View/countries_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WorldStatesScreen extends StatefulWidget {
  const WorldStatesScreen({super.key});

  @override
  State<WorldStatesScreen> createState() => _WorldStatesScreenState();
}

class _WorldStatesScreenState extends State<WorldStatesScreen>
    with TickerProviderStateMixin {
  // Animation code same as the splash screen
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  final colorList = <Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // Added for better alignment
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * .01,
              ),
              FutureBuilder(
                future: statesServices.fetchWorkedStatesRecords(),
                builder: (context, AsyncSnapshot<WorldStatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                      flex: 1,
                      child: Center(
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50.0,
                          controller: _controller,
                        ),
                      ),
                    );
                  } else {
                    return Expanded(
                      child: SingleChildScrollView(  // To avoid overflow on small screens
                        child: Column(
                          children: [
                            // Pie chart
                            PieChart(
                              dataMap: {
                                "Total": double.parse(
                                    snapshot.data!.cases!.toString()),
                                "Recovered": double.parse(
                                    snapshot.data!.recovered!.toString()),
                                "Deaths": double.parse(
                                    snapshot.data!.deaths!.toString()),
                              },
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                              chartRadius:
                              MediaQuery.of(context).size.width / 3.2,
                              legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left,
                              ),
                              animationDuration:
                              const Duration(milliseconds: 1200),
                              chartType: ChartType.ring,
                              colorList: colorList,
                            ),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height * .06,
                            ),
                            // Data Card
                            Card(
                              child: Column(
                                children: [
                                  ReuseableRow(
                                      title: 'Total',
                                      value:
                                      snapshot.data!.cases.toString()),
                                  ReuseableRow(
                                      title: 'Deaths',
                                      value:
                                      snapshot.data!.deaths.toString()),
                                  ReuseableRow(
                                      title: 'Recovered',
                                      value: snapshot.data!.recovered
                                          .toString()),
                                  ReuseableRow(
                                      title: 'Active',
                                      value:
                                      snapshot.data!.active.toString()),
                                  ReuseableRow(
                                      title: 'Critical',
                                      value:
                                      snapshot.data!.critical.toString()),
                                  ReuseableRow(
                                      title: 'Today Recovered',
                                      value: snapshot.data!.todayRecovered
                                          .toString()),
                                  ReuseableRow(
                                      title: 'Today Deaths',
                                      value: snapshot.data!.todayDeaths
                                          .toString()),
                                ],
                              ),
                            ),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height * .03,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CountriesListScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: const Color(0xff1aa260),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Track Countries',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReuseableRow extends StatelessWidget {
  final String title, value;

  ReuseableRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
