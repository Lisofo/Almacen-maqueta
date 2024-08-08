import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maqueta_deposito/pages/dashboard.dart';
import 'package:maqueta_deposito/pages/inventario.dart';
import 'package:maqueta_deposito/pages/menu.dart';
import 'package:maqueta_deposito/pages/pedidos.dart';
import 'package:maqueta_deposito/pages/picking.dart';
import 'package:maqueta_deposito/pages/pedido_interno.dart';
import 'package:maqueta_deposito/pages/product_page.dart';
import 'package:maqueta_deposito/pages/seleccion_almacen.dart';
import 'package:maqueta_deposito/config/rutas/rebuild_notifier.dart';
import 'package:maqueta_deposito/pages/transferencia.dart';
import '../../pages/buscador_producto.dart';
import '../../pages/login.dart';


// Map<String, WidgetBuilder> getApplicationRoutes() {
//   return <String, WidgetBuilder>{
//     '/': (BuildContext context) => Login(),
//     'origen' : (BuildContext context) => SeleccionOrigen(),
//     'buscadorCliente' : (BuildContext context) => BuscadorCliente(),
//     'paginaCliente': (BuildContext context) => PaginaCliente(),
//     'pedidoInterno' : (BuildContext context) => PedidoInterno(),
//     'agregarAPedido' : (BuildContext context) => AgregarPedido(),
//     'paginaProducto' : (BuildContext context) => ProductPage(),
//     'nuevoPedido' : (BuildContext context) => NuevoPedido(),
//     'checkout' : (BuildContext context) => PaginaCheckout(),
//   };
// }

final loginNav = GlobalKey<NavigatorState>();
final origenNav = GlobalKey<NavigatorState>();
final clientSearchNav = GlobalKey<NavigatorState>();
final menuNav = GlobalKey<NavigatorState>();
final pickingKeyNav = GlobalKey<NavigatorState>();
final inventarioNav = GlobalKey<NavigatorState>();
final transferenciaNav = GlobalKey<NavigatorState>();
final dashboardNav = GlobalKey<NavigatorState>();

final rebuildNotifier = RebuildNotifier();

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    //todo cuando funcion login
    // String token = context.read<OrdenProvider>().token;
    // if (token == '') {
    //   return '/';
    // }
    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, child) => ValueListenableBuilder<bool>(
        valueListenable: rebuildNotifier,
        builder: (context, value, child) => child!,
        child: child,
      ),
      branches: [
        StatefulShellBranch(
          navigatorKey: loginNav,
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Login(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: menuNav,
          routes: [
            GoRoute(
              path: '/almacen',
              builder: (context, state) => const SeleccionAlmacen(),
              routes: [
                GoRoute(
                  path: 'menu',
                  builder: (context, state) => const MenuPage(),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: pickingKeyNav,
          routes: [
            GoRoute(
              path: '/pickingOrders',
              builder: (context, state) => const ListaPedidos(),
              routes: [
                GoRoute(
                  path: 'pickingInterno',
                  builder: (context, state) => const PedidoInterno(),
                  routes: [
                    GoRoute(
                      path: 'picking',
                      builder: (context, state) => const PickingPage(),
                    )
                  ],
                )
              ]
            ),
          ]
        ),
        StatefulShellBranch(
          navigatorKey: clientSearchNav,
          routes: [
            GoRoute(
              path: '/buscadorProducto',
              builder: (context, state) => BuscadorProducto(),
              routes: [
                GoRoute(
                  path: 'paginaProducto',
                  builder: (context, state) => const ProductPage(),
                ),
              ]
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: inventarioNav,
          routes: [
            GoRoute(
              path: '/inventario',
              builder: (context, state) => const InventarioPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: transferenciaNav,
          routes: [
            GoRoute(
              path: '/transferencia',
              builder: (context, state) => const TransferenciaPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: dashboardNav,
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardPage(),
            ),
          ],
        ),
      ]
    )  
  ]
);