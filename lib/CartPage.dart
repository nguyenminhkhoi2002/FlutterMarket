import 'package:flutter/material.dart';
import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_market/Payment.dart';
import 'PersonalUser.dart';
import 'Data.dart';
import 'ProductDetail.dart';

class CartPage extends StatefulWidget {
  PersonalUser ps;
  BuildContext context;
  CartPage({Key? key, required this.ps, required this.context})
      : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String titleProduct = '';
  double total = 0;
  void _gotoProdcutDetail(String id, String title, double price, double rating,
      String urlimg, String description, int index, bool isAdded) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetail(
          id: id,
          title: title,
          price: price,
          rating: rating,
          image: urlimg,
          description: description,
          ps: widget.ps,
          index: index,
          isAdded: isAdded,
        ),
      ),
    );
    setState(() {
      widget.ps = result as PersonalUser;
    });
  }

  ListTile _tile(
      String id,
      String title,
      double? price,
      double rating,
      String urlimg,
      String description,
      BuildContext context,
      int index,
      bool isAdded) {
    CachedNetworkImage img = CachedNetworkImage(
      imageUrl: urlimg,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error, size: 70),
      height: 60,
      width: 60,
    );
    return ListTile(
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w400),
      ),
      subtitle: Text('$price \$'),
      leading: img,
      onTap: () {
        _gotoProdcutDetail(
            id, title, price!, rating, urlimg, description, index, isAdded);
      },
    );
  }

  Widget buildList() {
    List<Widget> list = [];
    for (int i = 1; i < widget.ps.cart.length; i++) {
      int k = widget.ps.cart[i];
      total+=double.tryParse(Data.ProductsList[k]['Price']!.toString())!;
      titleProduct += '${Data.ProductsList[k]['title'] as String}, ';
      list.add(_tile(
          Data.ProductsList[k]['id'] as String,
          Data.ProductsList[k]['title'] as String,
          double.tryParse(Data.ProductsList[k]['Price']!.toString()),
          double.parse(Data.ProductsList[k]['rating'] as String),
          Data.ProductsList[k]['image'] as String,
          Data.ProductsList[k]['Description'] as String,
          widget.context,
          k,
          true));
    }
    list.add(ElevatedButton(onPressed: null, child: Text('Total $total')));

    return ListView(
      children: list,
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(icon:Icon(Icons.paypal), onPressed: () {
            Navigator.push(context, 
            MaterialPageRoute(builder: (context) => Payment(orderAmount: total, nameGoods: titleProduct)));
          }),
        ],
        title: Text("Cart"),
      ),
      body: buildList(),
    );
  }
}
