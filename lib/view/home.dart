import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample/contraller/authcontraller.dart';
import 'package:sample/model/apicall.dart';
import 'package:sample/product.dart';
import 'package:sample/service/service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final logut = getIt<AuthController>();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("Products List"),
        actions: [
          IconButton(
            onPressed: () {
              logut.signOut();
              GoRouter.of(context).go('/Login');
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<List<Product>>(
        stream: ApiService.streamProducts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No products found'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Card(
                  elevation: 4, // Adds shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading:
                        product.thumbnail != null
                            ? ClipRRect(
                              borderRadius: BorderRadius.circular(
                                10,
                              ), // Round image corners
                              child: Image.network(
                                product.thumbnail!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Container(),
                    title: Text(
                      product.title ?? 'No title',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Brand: ${product.brand ?? 'Unknown'}\nPrice: \$${product.price ?? '0.00'}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      GoRouter.of(context).go('/details/${product.id}');
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
