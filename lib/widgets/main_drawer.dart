import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

final auth = Get.put(AuthController());

class MainDrawer extends StatelessWidget {
  const MainDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Drawer(
            child: Column(
      children: [
        GetBuilder<AuthController>(
          initState: (_) async {
            await auth.obtainUserDataFromStorage();
          },
          builder: (_) => ListTile(
              tileColor: Theme.of(context).accentColor,
              leading: Container(
                margin: EdgeInsets.only(top: 5),
                child: Text(
                  auth.user.name,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              trailing: auth.user.photoUrl.isNotEmpty
                  ? CircleAvatar(
                      backgroundImage: NetworkImage(auth.user.photoUrl),
                    )
                  : Container(
                      child: ClipOval(
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                      ),
                    )),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text('LogOut'),
          onTap: () async {
            await auth.logOut();
          },
        ),
      ],
    )));
  }
}
