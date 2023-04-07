import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../../constants/images.dart';
import '../../constants/themes.dart';
import '../../controller/controller.dart';
import '../../firebase/database_users.dart';
import '../../firebase/authentication.dart';
import '../../widgets/helper.dart';
import '../../widgets/logo_shower.dart';

class Register extends StatefulWidget {
  const Register({
    Key? key,
  }) : super(key: key);

  @override
  State createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final controller = Get.find<Controller>();
  TextEditingController textController = TextEditingController(text: '');
  final formKey = GlobalKey<FormState>();
  bool showBlankError = true;

  Future<void> registerUser() async {
    controller.userName = textController.text;
    await DatabaseUsers().registerUser(
      controller.userId,
      controller.userEmail,
      textController.text,
    );
    if (!mounted) return;
    nextScreenReplace(context, 'HomePage');
  }

  Future<void> goBack() async {
    await Authentication().logout();
    controller.userId = "";
    controller.userName = "";
    controller.userEmail = "";
    controller.showLoginPage.value = true;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                  onPressed: () async {
                    await goBack();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 30,
                  )),
              LogoShower(logo: ImageConst.camoChatLogo, size: screenSize(context).width-180),
              const SizedBox(
                width: 50,
              ),
            ],
          ),





          // TODO: ADD name Randomizer in the suffix icon ABC....





          Form(
            key: formKey,
            child: SizedBox(
              width: screenSize(context).width-100,
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 20,
                  ),
                  suffixIcon: Icon(
                    Icons.abc_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 1),
                  ),
                ),
                enabled: false,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18
                ),
                controller: textController,
              ),
            ),
          ),
          const SizedBox(height: 20,),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                await EasyLoading.show(
                    maskType: EasyLoadingMaskType.black,
                    indicator: const CircularProgressIndicator());
                await registerUser();
                EasyLoading.dismiss();
              } else {
                setState(() => showBlankError = false);
              }
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(0),
            ),
            child: Container(
              height: 40,
              width: screenSize(context).width-100,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  color: Themes.themeRed.withOpacity(0.3),
                  border: Border.all(color: Themes.themeRed, width: 1.0),
                  borderRadius: const BorderRadius.all(Radius.circular(5))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: screenSize(context).width-162,
                    child: const Center(
                      child: Text(
                        'Let\'s go...',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20,
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
