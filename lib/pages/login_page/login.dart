import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../constants/themes.dart';
import '../../constants/images.dart';
import '../../controller/controller.dart';
import '../../widgets/helper.dart';
import '../../widgets/logo_shower.dart';
import '../../firebase/authentication.dart';

class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final Authentication _auth = Authentication();
  final controller = Get.find<Controller>();

  Future<void> nextPageDecider(User? user) async {
    if (user != null) {
      controller.userId = user.uid;
      controller.userEmail = user.email!;
      bool isUserRegistered = await _auth.isUserRegistered(user.uid);
      if (isUserRegistered) {
        if (!mounted) return;
        nextScreenReplace(context, 'HomePage');
      } else {
        controller.showLoginPage.value = false;
      }
    }
  }

  Future<void> signIn() async {
    try {
      User? user = await _auth.signInWithGoogle();
      await nextPageDecider(user);
    } catch (e) {
      showSnackBar(context, e.toString(), 4);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          LogoShower(logo: ImageConst.camoChatLogo, size: screenSize(context).width-180),
          TextButton(
            onPressed: () async {
              await EasyLoading.show(
                maskType: EasyLoadingMaskType.black,
                indicator: const CircularProgressIndicator()
              );
              await signIn();
              EasyLoading.dismiss();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            child: Container(
              height: 40,
              width: screenSize(context).width-100,
              decoration: BoxDecoration(
                  color: Themes.themeRed.withOpacity(0.3),
                  border: Border.all(color: Themes.themeRed, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Row(
                children: [
                  Container(
                    height: 40,
                    width: 40,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(5),
                      bottomLeft: Radius.circular(5),
                    )),
                    child: const Center(
                      child: LogoShower(size: 25, logo: ImageConst.googleLogo,)
                    ),
                  ),
                  SizedBox(
                    width: screenSize(context).width-142,
                    child: const Center(
                      child: Text(
                        'Login with Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: screenSize(context).width-240,)
        ],
      ),
    );
  }
}
