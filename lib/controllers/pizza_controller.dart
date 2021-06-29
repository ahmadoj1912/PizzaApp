import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class Modifier {
  final String name;
  final bool isRequired;
  final int singleOrMulti;
  List? options;

  Map toJson() {
    return {
      'name': name,
      'isRequired': isRequired,
      'singleOrMulti': singleOrMulti,
      'options': options,
    };
  }

  Modifier({
    required this.name,
    required this.isRequired,
    required this.singleOrMulti,
    this.options,
  });
}

class Pizza {
  final String? id;
  final String title;
  final String desc;
  final String image;
  final List<Modifier> modifiers;

  Pizza({
    this.id,
    required this.title,
    required this.desc,
    required this.image,
    this.modifiers = const [],
  });
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
            modifiers: item['modifiers']
                .map<Modifier>((e) => Modifier(
                      name: e['name'],
                      isRequired: e['isRequired'],
                      singleOrMulti: e['singleOrMulti'],
                      options: e['options'],
                    ))
                .toList(),
          ));
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

  Future<void> addPizza(
      Pizza item, File image, List<Modifier> modifiers) async {
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
        'modifiers': modifiers.map((i) => i.toJson()).toList(),
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
