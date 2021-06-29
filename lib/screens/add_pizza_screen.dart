import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:get/get.dart';
import '../controllers/pizza_controller.dart';
import '../screens/add_option_screen.dart';

final pizzaController = Get.put(PizzaController());

class AddPizzaScreen extends StatefulWidget {
  const AddPizzaScreen({Key? key}) : super(key: key);
  static const routeName = '/add-pizza';

  @override
  _AddPizzaScreenState createState() => _AddPizzaScreenState();
}

class _AddPizzaScreenState extends State<AddPizzaScreen> {
  late File _selectedImage;
  List<Modifier> modifiers = [];
  Pizza item = Pizza(title: '', desc: '', image: '');

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

    if (modifiers.isEmpty) {
      Get.snackbar('Please Add a Modifier', 'At Least One Modifier is Required',
          colorText: Colors.black, duration: Duration(seconds: 2));
    }

    if (isValid && modifiers.isNotEmpty) {
      _formKey.currentState!.save();
      await pizzaController.addPizza(item, _selectedImage, modifiers);
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
        body: Obx(() => pizzaController.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : LayoutBuilder(
                builder: (context, constraint) => SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraint.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Expanded(
                            child: Card(
                              margin: EdgeInsets.all(0),
                              elevation: 10,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: FormBuilder(
                                  key: _formKey,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  child: Column(
                                    //crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      FormBuilderTextField(
                                        name: 'Title',
                                        focusNode: _title,
                                        keyboardType: TextInputType.text,
                                        onSaved: (value) {
                                          item = Pizza(
                                            title: value!.trim(),
                                            desc: item.desc,
                                            image: item.image,
                                          );
                                        },
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context,
                                              errorText: 'Can\'t be Empty '),
                                          FormBuilderValidators.minLength(
                                              context, 5,
                                              errorText: ' Name is Too Short')
                                        ]),
                                        decoration: InputDecoration(
                                          labelText: 'Title',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
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
                                            desc: value!.trim(),
                                            image: item.image,
                                          );
                                        },
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context,
                                              errorText: 'Can\'t be Empty '),
                                          FormBuilderValidators.minLength(
                                              context, 10,
                                              errorText:
                                                  ' Description is Too Short')
                                        ]),
                                        decoration: InputDecoration(
                                          labelText: 'Description',
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20))),
                                        ),
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
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context,
                                              errorText:
                                                  'Please Select an Image')
                                        ]),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: ElevatedButton.icon(
                                            onPressed: () async {
                                              await Get.to(AddOptionScreen(),
                                                      transition: Transition
                                                          .leftToRight)!
                                                  .then((value) {
                                                if (value != null) {
                                                  // print(value.options);
                                                  setState(() {
                                                    modifiers.add(Modifier(
                                                        name: value.name,
                                                        isRequired:
                                                            value.isRequired,
                                                        singleOrMulti:
                                                            value.singleOrMulti,
                                                        options:
                                                            value.options));
                                                  });
                                                }
                                              });
                                            },
                                            icon: Icon(Icons.add),
                                            label: Text('Add Modifier')),
                                      ),
                                      Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.2,
                                        child: ListView.builder(
                                            itemCount: modifiers.length,
                                            itemBuilder: (context, index) =>
                                                ListTile(
                                                  title: Text(
                                                      modifiers[index].name),
                                                )),
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
                        ],
                      ),
                    ),
                  ),
                ),
              )));
  }
}
