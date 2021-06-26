import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Pizza {
  final String? id;
  final String title;
  final String desc;
  final String image;
  final List size;
  final double smallSize;
  final double meduimSize;
  final double largeSize;
  final List toppings;

  Pizza(
      {this.id,
      required this.title,
      required this.desc,
      required this.image,
      required this.size,
      this.smallSize = 0.0,
      this.meduimSize = 0.0,
      this.largeSize = 0.0,
      required this.toppings});
}

class PizzaController extends GetxController with StateMixin {
  List<Pizza> _items = [];
  final _isLoading = RxBool(false);

  List<Pizza> get items => _items;
  RxBool get isLoading => _isLoading;

  void onInit() async {
    await fetchProducts();
    super.onInit();
  }

  String toppingToValue(int topping) {
    if (topping == 1) {
      return 'mushroom';
    }
    if (topping == 2) {
      return 'Sausage';
    }
    if (topping == 3) {
      return 'Bacon';
    }
    if (topping == 4) {
      return 'Chicken';
    }
    if (topping == 5) {
      return 'Black Olives';
    }
    return '';
  }

  Future<void> fetchProducts() async {
    try {
      change(_items, status: RxStatus.loading());
      final fbs = FirebaseFirestore.instance;
      List<Pizza> loadedData = [];
      final data = await fbs
          .collection('Pizzas')
          .orderBy('created_at', descending: true)
          .get();

      if (data.size > 0) {
        data.docs.forEach((item) {
          loadedData.add(Pizza(
              id: item.id,
              title: item['title'],
              desc: item['description'],
              image: item['image'],
              size: item['sizes'],
              smallSize: item['smallPrice'],
              meduimSize: item['meduimPrice'],
              largeSize: item['largePrice'],
              toppings: item['toppings']));
        });
        _items = loadedData;
        change(_items, status: RxStatus.success());
      } else {
        loadedData.clear();
        _items = loadedData;
        change(_items, status: RxStatus.empty());
      }
    } catch (error) {
      change(_items, status: RxStatus.error(error.toString()));
    }
  }

  Future<void> addPizza(Pizza item, File image, double smallPrice,
      double meduimPrice, double largePrice) async {
    try {
      _isLoading.value = true;
      final fileName = path.basename(image.path);

      final ref =
          FirebaseStorage.instance.ref().child('pizza-images').child(fileName);
      await ref.putFile(image).whenComplete(() => print('Image Uploaded'));

      final String imageUrl = await ref.getDownloadURL();

      final fbs = FirebaseFirestore.instance;
      await fbs.collection('Pizzas').add({
        'title': item.title,
        'description': item.desc,
        'image': imageUrl,
        'sizes': item.size,
        'smallPrice': smallPrice,
        'meduimPrice': meduimPrice,
        'largePrice': largePrice,
        'toppings': item.toppings,
        'created_at': Timestamp.now(),
      });
    } catch (error) {
      throw error;
    } finally {
      await fetchProducts();
      _isLoading.value = false;
      Get.back();
    }
  }
}
