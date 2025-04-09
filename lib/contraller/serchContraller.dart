import 'package:rxdart/rxdart.dart';
import 'package:sample/model/apicall.dart';
import 'package:sample/product.dart';

class ProductSearchController {
  final BehaviorSubject<String> _searchSubject = BehaviorSubject<String>();
  final BehaviorSubject<List<Product>> _filteredSubject =
      BehaviorSubject<List<Product>>();

  Stream<List<Product>> get filteredProductsStream => _filteredSubject.stream;
  Sink<String> get searchSink => _searchSubject.sink;

  List<Product> _allProducts = [];

  ProductSearchController() {
    _searchSubject
        .debounceTime(Duration(milliseconds: 300))
        .listen(_filterProducts);

    ApiService.streamProducts().listen((products) {
      _allProducts = products;
      _filterProducts(_searchSubject.valueOrNull ?? '');
    });
  }

  void _filterProducts(String query) {
    final filtered =
        _allProducts
            .where(
              (product) =>
                  product.title!.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
    _filteredSubject.add(filtered);
  }

  void dispose() {
    _searchSubject.close();
    _filteredSubject.close();
  }
}
