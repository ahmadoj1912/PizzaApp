import 'package:flutter/material.dart';
import '../controllers/auth_controller.dart';
import 'package:get/get.dart';

final auth = Get.put(AuthController());

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(247, 133, 127, 1.00).withOpacity(0.5),
              Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 1],
          ),
        ),
        child: Center(
            child: Obx(
          () => auth.isLoading
              ? CircularProgressIndicator()
              : ElevatedButton.icon(
                  onPressed: () async {
                    await auth.loginWithGoogle();
                  },
                  icon: Icon(
                    Icons.login,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Login With Google',
                    style: Theme.of(context).textTheme.headline1,
                  )),
        )),
      ),
    );
  }
}
