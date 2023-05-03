import 'package:flutter/material.dart';
import 'dart:core';
import 'package:cached_network_image/cached_network_image.dart';
import 'ProductDetail.dart';
import 'Data.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'PersonalUser.dart';
class ProductView extends StatelessWidget{
  PersonalUser ps;
  BuildContext context;
  ProductView({Key? key, required this.context,required this.ps}) : super(key: key);
  


  Widget buildProductView(String id, String title, double? price, double rating,
       String image, String? description,BuildContext context,int index) {
        
    CachedNetworkImage img = CachedNetworkImage(
      imageUrl: image,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error, size: 70),
      height: 70,
      width: 70,
    );
    

    return Card(

      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetail(
                      id: id,
                      title: title,
                      price: price,
                      rating: rating,
                      image: image,
                      description: description,
                      ps: ps,
                      index: index,
                      isAdded: ps.cart.contains(index) ? true : false,
                    )),
          );
        },
        child: Container(alignment: Alignment.topCenter,
        width: 188,
        height: 188,
        child: Column(children:[img, Text(title,softWrap: true,),Text("Price: $price\$"),buildRatingView(rating)]))
      ),
    );
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


  @override
  Widget build(BuildContext context,) {
    // TODO: implement build
    
    return LazyLoadScrollView(
      onEndOfPage: () => print('No more items'),
      child: Wrap(
        children: List.generate(Data.ProductsList.length, (index) => buildProductView(Data.ProductsList[index]['id'] as String, Data.ProductsList[index]['title'] as String,double.tryParse(Data.ProductsList[index]['Price']!.toString()), double.parse(Data.ProductsList[index]['rating'] as String), Data.ProductsList[index]['image'] as String,Data.ProductsList[index]['Description'] as String,context,index))
      ),
    );
  }
}

