import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample/model/apicall.dart';
import 'package:sample/product.dart';

class Details extends StatefulWidget {
  final int productId;

  const Details({super.key, required this.productId});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  late Future<Product> futureProduct;

  @override
  void initState() {
    super.initState();
    futureProduct = ApiService.fetchProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text("Product Details", style: TextStyle(color: Colors.white)),
        ),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go('/home');
          },
          icon: Icon(Icons.home),
        ),
      ),

      body: FutureBuilder<Product>(
        future: futureProduct,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No product'));
          }

          final product = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15), // Rounded edges

                    child: CarouselSlider(
                      options: CarouselOptions(
                        height: 450.0,
                        autoPlay: true,
                        enlargeCenterPage: true, // Highlights the center image
                      ),
                      items:
                          product.images?.map((image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 2,
                                        //spreadRadius: 2,
                                      ),
                                    ],
                                  ),

                                  child: Image.network(image),
                                );
                              },
                            );
                          }).toList(),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    product.title ?? 'No title',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Price: \$${product.price}',
                    style: const TextStyle(fontSize: 20, color: Colors.green),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Rating: ${product.rating}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    product.description ?? 'No description',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
