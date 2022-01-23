import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/helpers/custom_route.dart';
import 'package:shopping_app/providers/auth.dart';
import 'package:shopping_app/screens/auth_screen.dart';
import 'package:shopping_app/screens/edit_product_screen.dart';
import 'package:shopping_app/screens/splash_screen.dart';

import './screens/cart_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (ctx) => Products('', '', []),
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items),
          ),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (ctx) => Orders('', '', []),
            update: (ctx, auth, previousProducts) => Orders(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.orders),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
              title: 'MyShop',
              theme: ThemeData(
                  primarySwatch: Colors.purple,
                  accentColor: Colors.deepOrange,
                  fontFamily: 'Lato',
                  pageTransitionsTheme: PageTransitionsTheme(builders: {
                    TargetPlatform.android: CustomPageTransitionBuilder(),
                    TargetPlatform.iOS: CustomPageTransitionBuilder()
                  })),
              home: auth.isAuth
                  ? ProductsOverviewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authResultSnapshot) =>
                          authResultSnapshot.connectionState ==
                                  ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen(),
                    ),
              routes: {
                ProductsOverviewScreen.routeName: (ctx) =>
                    ProductsOverviewScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen()
              }),
        ));
  }
}
