import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:get/get.dart';
import 'package:pizza/controllers/pizza_controller.dart';

final pizzaController = Get.put(PizzaController());

class AddPizzaScreen extends StatefulWidget {
  const AddPizzaScreen({Key? key}) : super(key: key);
  static const routeName = '/add-pizza';

  @override
  _AddPizzaScreenState createState() => _AddPizzaScreenState();
}

class _AddPizzaScreenState extends State<AddPizzaScreen> {
  bool _isSmall = false;
  bool _isMeduim = false;
  bool _isLarge = false;
  late File _selectedImage;
  Pizza item = Pizza(title: '', desc: '', image: '', size: [],
      //smallSize: 0.0,
      //meduimSize: 0.0,
      //largeSize: 0.0,
      toppings: []);

  double _smallPrice = 0.0;
  double _meduimPrice = 0.0;
  double _largePrice = 0.0;

  final _formKey = GlobalKey<FormBuilderState>();
  final _title = FocusNode();
  final _desc = FocusNode();
  final _sizes = FocusNode();
  final _image = FocusNode();
  final _toppings = FocusNode();
  final _small = FocusNode();
  final _meduim = FocusNode();
  final _large = FocusNode();

  @override
  void dispose() {
    _title.dispose();
    _desc.dispose();
    _sizes.dispose();
    _image.dispose();
    _toppings.dispose();
    _small.dispose();
    _meduim.dispose();
    _large.dispose();

    super.dispose();
  }

  Future<void> validateInputAndSave() async {
    bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      _formKey.currentState!.save();
      await pizzaController.addPizza(
          item, _selectedImage, _smallPrice, _meduimPrice, _largePrice);
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Pizza'),
        ),
        body: Obx(
          () => pizzaController.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.all(0),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: FormBuilder(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            FormBuilderTextField(
                              name: 'Title',
                              focusNode: _title,
                              keyboardType: TextInputType.text,
                              onSaved: (value) {
                                item = Pizza(
                                    title: value!,
                                    desc: item.desc,
                                    image: item.image,
                                    size: item.size,
                                    toppings: item.toppings);
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'Can\'t be Empty '),
                                FormBuilderValidators.minLength(context, 5,
                                    errorText: ' Name is Too Short')
                              ]),
                              decoration: InputDecoration(
                                labelText: 'Title',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FormBuilderTextField(
                              name: 'desc',
                              keyboardType: TextInputType.multiline,
                              minLines: 2,
                              maxLines: 4,
                              focusNode: _desc,
                              onSaved: (value) {
                                item = Pizza(
                                    title: item.title,
                                    desc: value!,
                                    image: item.image,
                                    size: item.size,
                                    toppings: item.toppings);
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'Can\'t be Empty '),
                                FormBuilderValidators.minLength(context, 10,
                                    errorText: ' Description is Too Short')
                              ]),
                              decoration: InputDecoration(
                                labelText: 'Description',
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20))),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            FormBuilderCheckboxGroup(
                                name: 'Size',
                                focusNode: _sizes,
                                onSaved: (value) {
                                  item = Pizza(
                                      title: item.title,
                                      desc: item.desc,
                                      image: item.image,
                                      size: value as List,
                                      toppings: item.toppings);
                                },
                                onChanged: (value) {
                                  if (value!.isEmpty) {
                                    setState(() {
                                      _isSmall = false;
                                      _isMeduim = false;
                                      _isLarge = false;
                                    });
                                  }

                                  if ((!value.any((element) => element == 1))) {
                                    if (this.mounted) {
                                      setState(() {
                                        _isSmall = false;
                                      });
                                    }
                                  }
                                  if ((!value.any((element) => element == 2))) {
                                    if (this.mounted) {
                                      setState(() {
                                        _isMeduim = false;
                                      });
                                    }
                                  }

                                  if ((!value.any((element) => element == 3))) {
                                    if (this.mounted) {
                                      setState(() {
                                        _isLarge = false;
                                      });
                                    }
                                  }

                                  if (value.any((element) => element == 1)) {
                                    if (this.mounted) {
                                      setState(() {
                                        //print(_isSmall);
                                        _isSmall = true;
                                      });
                                    }
                                  }

                                  if (value.any((element) => element == 2)) {
                                    if (this.mounted) {
                                      setState(() {
                                        // print(_isSmall);
                                        _isMeduim = true;
                                      });
                                    }
                                  }

                                  if (value.any((element) => element == 3)) {
                                    if (this.mounted) {
                                      setState(() {
                                        // print(_isSmall);
                                        _isLarge = true;
                                      });
                                    }
                                  }
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select at least one';
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'Sizes',
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                options: [
                                  FormBuilderFieldOption(
                                    value: 1,
                                    child: Text('Small'),
                                  ),
                                  FormBuilderFieldOption(
                                    value: 2,
                                    child: Text('Medium'),
                                  ),
                                  FormBuilderFieldOption(
                                    value: 3,
                                    child: Text('Large'),
                                  ),
                                ]),
                            if (_isSmall || _isMeduim || _isLarge)
                              SizedBox(
                                height: 20,
                              ),
                            if (_isSmall)
                              FormBuilderTextField(
                                name: 'Small Price',
                                focusNode: _small,
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  if (_isSmall) {
                                    item = Pizza(
                                        title: item.title,
                                        desc: item.desc,
                                        image: item.image,
                                        size: item.size,
                                        toppings: item.toppings);

                                    _smallPrice = double.parse(value!);
                                  }
                                },
                                validator: (value) {
                                  if (_isSmall) {
                                    if (value == null || value.isEmpty) {
                                      return 'Not empty';
                                    }
                                    final smallPrice = double.tryParse(value);
                                    if (smallPrice != null) {
                                      return null;
                                    } else {
                                      return 'Enter digits only';
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Small Price',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                            if (_isSmall || _isMeduim || _isLarge)
                              SizedBox(
                                height: 20,
                              ),
                            if (_isMeduim)
                              FormBuilderTextField(
                                name: 'Meduim Price',
                                focusNode: _meduim,
                                onSaved: (value) {
                                  if (_isMeduim) {
                                    item = Pizza(
                                        title: item.title,
                                        desc: item.desc,
                                        image: item.image,
                                        size: item.size,
                                        toppings: item.toppings);

                                    _meduimPrice = double.parse(value!);
                                  }
                                },
                                validator: (value) {
                                  if (_isMeduim) {
                                    if (value == null || value.isEmpty) {
                                      return 'Not empty';
                                    }
                                    final meduimPrice = double.tryParse(value);
                                    if (meduimPrice != null) {
                                      return null;
                                    } else {
                                      return 'Enter digits only';
                                    }
                                  }
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: 'Medium Price',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                            if (_isSmall || _isMeduim || _isLarge)
                              SizedBox(
                                height: 20,
                              ),
                            if (_isLarge)
                              FormBuilderTextField(
                                name: 'Large Price',
                                focusNode: _large,
                                keyboardType: TextInputType.number,
                                onSaved: (value) {
                                  if (_isLarge) {
                                    item = Pizza(
                                        title: item.title,
                                        desc: item.desc,
                                        image: item.image,
                                        size: item.size,
                                        toppings: item.toppings);

                                    _largePrice = double.parse(value!);
                                  }
                                },
                                validator: (value) {
                                  if (_isLarge) {
                                    if (value == null || value.isEmpty) {
                                      return 'Not empty';
                                    }
                                    final largePrice = double.tryParse(value);
                                    if (largePrice != null) {
                                      return null;
                                    } else {
                                      return 'Enter digits only';
                                    }
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Large Price',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                ),
                              ),
                            if (_isSmall || _isMeduim || _isLarge)
                              SizedBox(
                                height: 20,
                              ),
                            FormBuilderImagePicker(
                              name: 'Image',
                              key: ValueKey('camera'),
                              decoration: const InputDecoration(
                                  labelText: 'Pick Image'),
                              imageQuality: 50,
                              maxImages: 1,
                              focusNode: _image,
                              onSaved: (value) {
                                _selectedImage = value![0];
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(context,
                                    errorText: 'Please Select an Image')
                              ]),
                            ),
                            FormBuilderCheckboxGroup(
                                name: 'Toppings',
                                focusNode: _toppings,
                                onSaved: (value) {
                                  item = Pizza(
                                      title: item.title,
                                      desc: item.desc,
                                      image: item.image,
                                      size: item.size,
                                      toppings: value as List);
                                },
                                decoration: InputDecoration(
                                    labelText: 'Toppings',
                                    labelStyle: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please Select at least one';
                                  } else {
                                    return null;
                                  }
                                },
                                options: [
                                  FormBuilderFieldOption(
                                    value: 1,
                                    child: Text('Mushroom'),
                                  ),
                                  FormBuilderFieldOption(
                                    value: 2,
                                    child: Text('Sausage'),
                                  ),
                                  FormBuilderFieldOption(
                                    value: 3,
                                    child: Text('Bacon'),
                                  ),
                                  FormBuilderFieldOption(
                                    value: 4,
                                    child: Text('Chicken'),
                                  ),
                                  FormBuilderFieldOption(
                                    value: 5,
                                    child: Text('Black Olives'),
                                  ),
                                ]),
                            SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                                onPressed: () async {
                                  await validateInputAndSave();
                                },
                                child: Text('Add')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
        ));
  }
}
