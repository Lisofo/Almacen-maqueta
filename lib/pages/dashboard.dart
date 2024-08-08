import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:maqueta_deposito/config/rutas/routes.dart';
import 'package:maqueta_deposito/widgets/indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int touchedIndex = -1;
  
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton.filledTonal(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(colors.primary)
            ),
            onPressed: () async {
              router.go('/almacen/menu');
            },
            icon: const Icon(Icons.arrow_back,),
          ),
          title: Text('Dashboard',
            style: TextStyle(
              fontSize: 24,
              color: colors.onPrimary
            )
          ),
          elevation: 0,
          backgroundColor: colors.primary,
          iconTheme: IconThemeData(color: colors.onPrimary),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:[
                      const Text('Estado de los productos del dia:', style: TextStyle(fontSize: 25),),
                      Container(
                        height: 400,
                        child: PieChart(
                          PieChartData(
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                setState(() {
                                  if (!event.isInterestedForInteractions ||
                                      pieTouchResponse == null ||
                                      pieTouchResponse.touchedSection == null) {
                                    touchedIndex = -1;
                                    return;
                                  }
                                  touchedIndex = pieTouchResponse
                                      .touchedSection!.touchedSectionIndex;
                                });
                              },
                            ),
                            borderData: FlBorderData(
                              show: false,
                            ),
                            sectionsSpace: 0,
                            centerSpaceRadius: 60,
                            sections: showingSections(),
                          ),
                        ),
                      ),
                      const Indicator(
                        color: Colors.blue,
                        text: 'Pedidos Completados',
                        isSquare: true,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Indicator(
                        color: Colors.yellow,
                        text: 'Pedidos Pendientes',
                        isSquare: true,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      const Indicator(
                        color: Colors.purple,
                        text: 'Pedidos en espera de revision',
                        isSquare: true,
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      // const Indicator(
                      //   color: Colors.green,
                      //   text: 'Fourth',
                      //   isSquare: true,
                      // ),
                      const SizedBox(
                        height: 18,
                      ),
                    ],
                  ),
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 30.0 : 20.0;
      final radius = isTouched ? 120.0 : 100.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: 70,
            title: '70%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.yellow,
            value: 20,
            title: '20%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.purple,
            value: 10,
            title: '10%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              shadows: shadows,
            ),
          );
        // case 3:
        //   return PieChartSectionData(
        //     color: Colors.green,
        //     value: 15,
        //     title: '15%',
        //     radius: radius,
        //     titleStyle: TextStyle(
        //       fontSize: fontSize,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black,
        //       shadows: shadows,
        //     ),
        //   );
        default:
          throw Error();
      }
    });
  }
}