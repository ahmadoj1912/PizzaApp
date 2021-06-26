import 'package:flutter/material.dart';
import 'package:location/location.dart';
import '../controllers/location_controller.dart';
import '../controllers/pizza_controller.dart';
import '../screens/change_location_screen.dart';
import '../widgets/pizza_item.dart';
import '../screens/add_pizza_screen.dart';
import '../widgets/main_drawer.dart';
import 'package:get/get.dart';

final pizzaController = Get.put(PizzaController());
final locationController = Get.put(LocationController());

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double? lat;
    double? lon;
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: Text('Pizza App'),
          actions: [
            ElevatedButton.icon(
                style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith(
                      (states) => EdgeInsets.all(10)),
                  elevation: MaterialStateProperty.resolveWith((states) => 0),
                ),
                onPressed: () async {
                  await Get.toNamed(AddPizzaScreen.routeName)!.then(
                      (value) async => await pizzaController.fetchProducts());
                },
                icon: Icon(Icons.add),
                label: Text(
                  'Add Pizza',
                )),
            GetBuilder<LocationController>(
              initState: (_) async {
                try {
                  bool exist =
                      await locationController.checkIfUserLocationExist();

                  if (exist) {
                    await locationController.fetchLocation();
                    lat = locationController.lat;
                    lon = locationController.lon;
                    //print('new location');
                  } else {
                    LocationData location =
                        await Location.instance.getLocation();
                    lat = location.latitude!;
                    lon = location.longitude!;
                    //print('current location');
                  }
                } catch (error) {
                  throw error;
                }
              },
              builder: (_) => IconButton(
                  onPressed: () async {
                    await Get.to(() => ChangeLocationScreen(),
                            transition: Transition.leftToRight,
                            // ignore: unnecessary_cast
                            arguments: {
                              'latitude': lat as double,
                              'longitude': lon as double,
                            } as Map<String, double>)!
                        .then((value) async {
                      if (value != null) {
                        await locationController.changeLocation(value);
                        await locationController.fetchLocation();
                        lat = locationController.lat;
                        lon = locationController.lon;
                        Get.snackbar('Location has been changed', 'Good Work');
                      }
                    });
                  },
                  icon: Icon(Icons.place)),
            ),
          ],
        ),
        body: GetBuilder<PizzaController>(
          // case if user logged out and other users added a pizza item we need to fetch data again
          initState: (state) async {
            await pizzaController.fetchProducts();
          },
          builder: (_) => pizzaController.obx(
              (state) {
                return ListView.builder(
                    padding: EdgeInsets.all(10),
                    itemCount: pizzaController.items.length,
                    itemBuilder: (context, index) =>
                        PizzaItem(pizzaController.items[index]));
              },
              onLoading: Center(
                child: CircularProgressIndicator(),
              ),
              onEmpty: Center(
                child: Text(
                  'No items have been added yet...',
                  style: Theme.of(context).textTheme.headline4,
                ),
              ),
              onError: (error) {
                return Center(
                  child: Text(error.toString()),
                );
              }),
        ));
  }
}
