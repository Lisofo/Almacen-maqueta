
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:maqueta_deposito/config/rutas/routes.dart';
import 'package:maqueta_deposito/widgets/indicator.dart';
import 'package:graphic/graphic.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int touchedIndex = -1;
  int totalDePedidos = 0;
  int pedidosPendientes = 20;
  int pedidosCompletados = 50;
  int pedidosEnEspera = 10;

  int numeroGuardado = 0;
  String? selectedValue;
  double percentCompletados = 0;
  double percentPendientes = 0;
  double percentEnEspera = 0;
  
  
  @override
  void initState() {
    totalDePedidos = pedidosCompletados + pedidosEnEspera + pedidosPendientes;
    actualizarPorcentajes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton.filledTonal(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(colors.primary),
            ),
            onPressed: () async {
              router.go('/almacen/menu');
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: Text(
            'Dashboard',
            style: TextStyle(fontSize: 24, color: colors.onPrimary),
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
                children: [
                  Text(
                    '$totalDePedidos Pedidos totales',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const Text(
                    'Estado de los Pedidos del dia:',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    
                    height: 400,
                    child: Chart(
                      rebuild: false,
                      data: getPieChartData(),
                      variables: {
                        'genre': Variable(
                          accessor: (Map map) => map['status'] as String,
                        ),
                        'sold': Variable(
                          accessor: (Map map) => map['value'] as num,
                        ),
                      },
                      transforms: [
                        Proportion(
                          variable: 'sold',
                          as: 'percent',
                        )
                      ],
                      marks: [
                        IntervalMark(
                          position: Varset('percent') / Varset('genre'),
                          label: LabelEncode(
                              encoder: (tuple) => Label(
                                    '${tuple['sold'].toString()}%',
                                    LabelStyle(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold
                                      ), 
                                      textAlign: TextAlign.center,
                                      align: Alignment.center,
                                    ),
                                  )),
                          color: ColorEncode(
                              variable: 'genre', values: [Colors.blue, Colors.yellow, Colors.purple]),
                          modifiers: [StackModifier()],
                          transition:
                              Transition(duration: const Duration(milliseconds: 300)),
                          entrance: {MarkEntrance.y},
                        )
                      ],
                      coord: PolarCoord(transposed: true, dimCount: 1),
                    ),
                  ),
                  Indicator(
                    color: Colors.blue,
                    text: '$pedidosCompletados Pedidos Completados',
                    isSquare: true,
                  ),
                  const SizedBox(height: 4),
                  Indicator(
                    color: Colors.yellow,
                    text: '$pedidosPendientes Pedidos Pendientes',
                    isSquare: true,
                  ),
                  const SizedBox(height: 4),
                  Indicator(
                    color: Colors.purple,
                    text: '$pedidosEnEspera Pedidos en espera de revision',
                    isSquare: true,
                  ),
                  const SizedBox(height: 18),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actionsAlignment: MainAxisAlignment.spaceEvenly,
                            surfaceTintColor: Colors.white,
                            title: const Text('Confirmación'),
                            content: const Text('Seleccione tipo de pedido y cantidad a agregar'),
                            actions: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  DropdownButton<String>(
                                    hint: const Text('Tipo de pedido'),
                                    value: selectedValue,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedValue = newValue;
                                      });
                                    },
                                    items: <String>['Completado', 'Pendiente', 'Para Revision']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  SizedBox(
                                    width: 160,
                                    child: TextField(
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: 'Ingrese cantidad',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        final intValue = int.tryParse(value);
                                        if (intValue != null) {
                                          setState(() {
                                            numeroGuardado = intValue;
                                          });
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        switch (selectedValue) {
                                          case 'Completado':
                                            pedidosCompletados += numeroGuardado;
                                            break;
                                          case 'Pendiente':
                                            pedidosPendientes += numeroGuardado;
                                            break;
                                          case 'Para Revision':
                                            pedidosEnEspera += numeroGuardado;
                                            break;
                                          default:
                                        }
                                        totalDePedidos = pedidosCompletados +
                                            pedidosEnEspera +
                                            pedidosPendientes;
                                        actualizarPorcentajes();
                                      });
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Confirmar'),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: const Text(
                      'Agregue Pedidos',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }


  List<Map<String, dynamic>> getPieChartData() {
    return [
      {'status': 'Completados', 'value': percentCompletados},
      {'status': 'Pendientes', 'value': percentPendientes},
      {'status': 'En Espera', 'value': percentEnEspera},
    ];
  }


  // List<PieChartSectionData> showingSections() {
  //   return List.generate(3, (i) {
  //     final isTouched = i == touchedIndex;
  //     final fontSize = isTouched ? 30.0 : 20.0;
  //     final radius = isTouched ? 120.0 : 100.0;
  //     const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
  //     switch (i) {
  //       case 0:
  //         return PieChartSectionData(
  //           color: Colors.blue,
  //           value: pedidosCompletados.toDouble(),
  //           title: '$percentCompletados%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //             fontSize: fontSize,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black,
  //             shadows: shadows,
  //           ),
  //         );
  //       case 1:
  //         return PieChartSectionData(
  //           color: Colors.yellow,
  //           value: pedidosPendientes.toDouble(),
  //           title: '$percentPendientes%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //             fontSize: fontSize,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black,
  //             shadows: shadows,
  //           ),
  //         );
  //       case 2:
  //         return PieChartSectionData(
  //           color: Colors.purple,
  //           value: pedidosEnEspera.toDouble(),
  //           title: '$percentEnEspera%',
  //           radius: radius,
  //           titleStyle: TextStyle(
  //             fontSize: fontSize,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.black,
  //             shadows: shadows,
  //           ),
  //         );
  //       // case 3:
  //       //   return PieChartSectionData(
  //       //     color: Colors.green,
  //       //     value: 15,
  //       //     title: '15%',
  //       //     radius: radius,
  //       //     titleStyle: TextStyle(
  //       //       fontSize: fontSize,
  //       //       fontWeight: FontWeight.bold,
  //       //       color: Colors.black,
  //       //       shadows: shadows,
  //       //     ),
  //       //   );
  //       default:
  //         throw Error();
  //     }
  //   });
  // }
  
  void actualizarPorcentajes() {
    percentCompletados = double.parse((100 * pedidosCompletados / totalDePedidos).toStringAsFixed(1));
    percentPendientes  = double.parse((100 * pedidosPendientes / totalDePedidos).toStringAsFixed(1));
    percentEnEspera = double.parse((100 * pedidosEnEspera / totalDePedidos).toStringAsFixed(1));
  }

}