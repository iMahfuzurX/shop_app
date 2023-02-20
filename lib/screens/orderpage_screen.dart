//
// Created by iMahfuzurX on 1/24/2023.
//
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import '../widgets/order_item.dart';

class OrderPageScreen extends StatefulWidget {
  static final String routeName = '/order-page';

  const OrderPageScreen({Key? key}) : super(key: key);

  @override
  State<OrderPageScreen> createState() => _OrderPageScreenState();
}

class _OrderPageScreenState extends State<OrderPageScreen> {
  Future? _orders;

  Future<void> _loadOrders() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    _orders = _loadOrders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _orders,
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              //error occurred
              return Center(child: Text('An error occured'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, orderData, child) => (orderData.orders.isEmpty)
                    ? Center(
                        child: Text('No items available'),
                      )
                    : ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) =>
                            OrderItem(order: orderData.orders[i]),
                      ),
              );
            }
          }
        },
      ),
    );
  }
}
