import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orders.dart' show Orders;
import '../widgets/app_drawer.dart';

import '../widgets/orderItem.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orderScreen';
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: ListView.builder(
        itemCount: ordersData.orders.length,
        itemBuilder: (ctx, index) => OrderItem(
          ordersData.orders[index],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
