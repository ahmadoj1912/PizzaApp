import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import '../controllers/pizza_controller.dart';
import 'package:get/get.dart';

class AddOptionScreen extends StatefulWidget {
  const AddOptionScreen({Key? key}) : super(key: key);

  @override
  _AddOptionScreenState createState() => _AddOptionScreenState();
}

class _AddOptionScreenState extends State<AddOptionScreen> {
  // for options
  List<String>? dynamicForm;

  Modifier item = Modifier(name: '', isRequired: false, singleOrMulti: 1);
  bool isClicked = false;
  int? counter;
  String? result;
  final _key = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    counter = 0;
    dynamicForm = [];
    result = '';
    super.initState();
  }

  /*
  _onUpdate(int index, String value) {
    Map<String, dynamic> json = {'id': index + 1, 'value': value};
    values!.add(json);
  }
  */
  /*
  void validateInputAndSave() {
    bool isValid = _key.currentState!.validate();

    if (isValid) {
      _key.currentState!.save();
      //print(_key.currentState?.value);
    } else {
      return;
    }
  }
  */

  Widget _row(int index) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(5),
            padding: EdgeInsets.all(5),
            child: FormBuilderTextField(
              validator: FormBuilderValidators.compose([
                FormBuilderValidators.required(context, errorText: 'Not empty')
              ]),
              name: '$index',
              onSaved: (value) {
                final textFieldValues = dynamicForm?..add(value!.trim());

                item = Modifier(
                    name: item.name,
                    isRequired: item.isRequired,
                    singleOrMulti: item.singleOrMulti,
                    options: textFieldValues);
              },
              decoration: InputDecoration(
                labelText: 'Option: ${index + 1}',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Modifier'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FormBuilder(
                  key: _key,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      FormBuilderTextField(
                        name: 'name',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Not empty')
                        ]),
                        onSaved: (value) {
                          item = Modifier(
                            name: value!.trim(),
                            isRequired: item.isRequired,
                            singleOrMulti: item.singleOrMulti,
                          );
                        },
                        decoration: InputDecoration(
                          labelText: 'name',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                      ),
                      FormBuilderChoiceChip(
                        name: 'Required',
                        spacing: 5,
                        onSaved: (value) {
                          item = Modifier(
                            name: item.name,
                            isRequired: value! as bool,
                            singleOrMulti: item.singleOrMulti,
                          );
                        },
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Not empty')
                        ]),
                        options: [
                          FormBuilderFieldOption(
                            value: true,
                            child: Text('Required'),
                          ),
                          FormBuilderFieldOption(
                              value: false, child: Text('Not Required')),
                        ],
                      ),
                      FormBuilderChoiceChip(
                        name: 'Multi',
                        spacing: 5,
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context,
                              errorText: 'Not empty')
                        ]),
                        onSaved: (value) {
                          item = Modifier(
                            name: item.name,
                            isRequired: item.isRequired,
                            singleOrMulti: value! as int,
                          );
                        },
                        options: [
                          FormBuilderFieldOption(
                            value: 2,
                            child: Text('Multi'),
                          ),
                          FormBuilderFieldOption(
                              value: 1, child: Text('Single')),
                        ],
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          child: ElevatedButton.icon(
                              onPressed: () {
                                setState(() {
                                  counter = (counter! + 1);
                                  isClicked = true;
                                });
                              },
                              icon: Icon(Icons.add),
                              label: Text('Add Option')),
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.38,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 2,
                                color: Theme.of(context).primaryColor)),
                        child: ListView.builder(
                            itemCount: counter,
                            itemBuilder: (context, index) => _row(index)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        child: Text(result!),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                            onPressed: () {
                              bool isValid = _key.currentState!.validate();

                              if (!isClicked) {
                                Get.snackbar('Please Add an Option',
                                    'At Least One Option is Required',
                                    colorText: Colors.black,
                                    duration: Duration(seconds: 2));
                              }

                              if (isValid && isClicked) {
                                _key.currentState!.save();
                                Get.back(result: item);
                              } else {
                                return;
                              }
                            },
                            child: Text('Add')),
                      ),
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
