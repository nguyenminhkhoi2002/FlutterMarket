import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'PersonalUser.dart';
class ProductDetail extends StatelessWidget {
  PersonalUser ps;
final String id;
String title;
double? price;
double rating;
String image;
String? description;
int index;
bool isAdded ;
ProductDetail({Key? key, required this.id, required this.title, this.price, required this.rating, required this.image,required this.description,required this.ps,required this.index,required this.isAdded,}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    CachedNetworkImage image = CachedNetworkImage(
      imageUrl: this.image,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error, size: 70),
      height: 250,
      width: 250,
    );
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
      ),
      body: Center(
        child: Column(
          children: [
            image,
            Text(this.title),
            Text("Price: ${this.price}\$"),
            buildRatingView(this.rating),
            Text(this.description!),buildButton(isAdded, context)
            
          ],
        ),
      ),
    );
  }
  ElevatedButton buildButton(bool isad,BuildContext context){
    if(!isad){
    return ElevatedButton(onPressed: () async{
              await ps.addToCart(this.index);
              Navigator.pop(context);
            }, child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.add_shopping_cart),Text('Add to cart')],));
    }
    
     return ElevatedButton(onPressed: () async{
              await ps.removeFromCart(this.index);
              Navigator.pop(context,ps);
            }, child: Row(mainAxisAlignment: MainAxisAlignment.center,children: [Icon(Icons.remove_shopping_cart_outlined),Text('Remove from cart')],));
  }
   Row buildRatingView(double rating) {
    List<Widget> stars = [];
    for(int i = 1; i < rating; i++){
      stars.add(const Icon(
        Icons.star,
        color: Colors.red,
      ));
    }
    if (rating - rating.floor() >= 0.5) {
      stars.add(const Icon(
        Icons.star_half,
        color: Colors.red,
      ));
    }
    while (stars.length < 5) {
      stars.add(const Icon(
        Icons.star_border,
        color: Colors.red,
      ));
    }
    stars.add(Text(' $rating'));
    return Row(children: stars);

  }
  


  
}