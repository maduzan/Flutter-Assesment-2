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
              return ListTile(
                leading:
                    product.thumbnail != null
                        ? Image.network(product.thumbnail!)
                        : Container(),
                title: Text(product.title ?? 'No title'),
                subtitle: Text(
                  'Brand: ${product.brand ?? 'Unknown'}\nPrice: \$${product.price ?? '0.00'}',
                ),
                onTap: () {
                  GoRouter.of(context).go('/details/${product.id}');
                },
              );
            },
          );
        },
      ),
    );
  }
}
