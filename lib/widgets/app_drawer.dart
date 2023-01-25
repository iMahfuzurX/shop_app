//
// Created by iMahfuzurX on 1/24/2023.
//
import 'package:flutter/material.dart';
import 'package:shop_app/screens/orderpage_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('shop.io'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.shop),
            ),
            title: Text('Products'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: CircleAvatar(
              child: Icon(Icons.payment),
            ),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrderPageScreen.routeName);
            },
          ),
          Divider(),
        ],
      ),
    );
  }
}
