import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample/contraller/authcontraller.dart';
import 'package:sample/contraller/serchContraller.dart';
import 'package:sample/model/apicall.dart';
import 'package:sample/product.dart';
import 'package:sample/service/service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late ProductSearchController searchController;
  @override
  void initState() {
    super.initState();
    searchController = ProductSearchController();
  }

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
          IconButton(
            onPressed: () {
              GoRouter.of(context).go('/view');
            },
            icon: Icon(Icons.person_off_outlined),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search product...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (query) {
                searchController.searchSink.add(query); // 🔥 RxDart input
              },
            ),
          ),

          Expanded(
            child: StreamBuilder<List<Product>>(
              stream: searchController.filteredProductsStream,
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
                          borderRadius: BorderRadius.circular(
                            15,
                          ), // Rounded corners
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
          ),
        ],
      ),
    );
  }
}
