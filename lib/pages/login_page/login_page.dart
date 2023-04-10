import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../constants/themes.dart';
import '../../constants/images.dart';
import '../../constants/effects.dart';
import '../../controller/controller.dart';
import '../../firebase/database.dart';
import '../../widgets/loaders.dart';
import '../../widgets/background.dart';
import '../../widgets/helper.dart';
import '../../firebase/authentication.dart';
import 'login.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with TickerProviderStateMixin {

  final Authentication _auth = Authentication();
  final controller = Get.find<Controller>();
  bool loading = true;

  Future<void> nextPageDecider(User? user) async {
    if (user != null) {
      bool isUserRegistered = await _auth.isUserRegistered(user.uid);
      if (isUserRegistered) {
        controller.userId = user.uid;
        if (!mounted) return;
        nextScreenReplace(context, 'HomePage');
      } else {
        controller.showLoginPage.value = false;
      }
    }
  }

  void checkUserAlreadyLoggedIn() async {
    User? user = await _auth.isUserLoggedIn();
    await nextPageDecider(user);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  void initState() {
    checkUserAlreadyLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        height: screenSize(context).height,
        width: screenSize(context).width,
        child: !loading
            ? Stack(
                children: [
                  Background(
                    backgroundImage: ImageConst.loginPageImage,
                    sensitivity: Effects.loginPageSensitivity,
                    blurValue: Effects.blurVeryLight,
                    blackValue: Effects.blackMedium,
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: screenSize(context).height,
                      width: screenSize(context).width,
                      child: Obx(() => Center(
                        child: AnimatedSwitcher(
                          switchInCurve: Curves.easeIn,
                          switchOutCurve: Curves.easeOut,
                          duration: const Duration(milliseconds: 500),
                          child: controller.showLoginPage.value ? const Login() : const Register()),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Container(color: Themes.themeDark, child: const LoaderCircular()),
      ),
    );
  }
}
