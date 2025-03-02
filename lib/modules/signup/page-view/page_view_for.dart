import 'package:animated_card/animated_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:raro_academy_budget/modules/signup/signup_manager.dart';

import 'package:raro_academy_budget/shared/widgets/input_form_widget.dart';
import 'package:raro_academy_budget/shared/widgets/visible_widget.dart';
import 'package:raro_academy_budget/util/constants/app_images.dart';
import 'package:raro_academy_budget/util/constants/app_text_styles.dart';
import 'package:raro_academy_budget/util/validators/text_validator.dart';

class PageViewFor extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const PageViewFor({
    Key? key,
    required this.passwordController,
    required this.confirmPasswordController,
  }) : super(key: key);

  @override
  _PageViewForState createState() => _PageViewForState();
}

class _PageViewForState extends State<PageViewFor> {
  String password = '';
  bool passwordVisible = false;
  bool confirmPasswordVisible = false;
  final controller = SignUpManager();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Observer(builder: (_) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.05),
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 48.0),
              child: AnimatedCard(
                direction: AnimatedCardDirection.top,
                duration: const Duration(milliseconds: 600),
                child: Image.asset(AppImages.logoBudget),
              ),
            ),
          ),
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: Padding(
              padding: const EdgeInsets.only(left: 48.0, top: 16.0),
              child: AnimatedCard(
                direction: AnimatedCardDirection.right,
                duration: const Duration(milliseconds: 600),
                child: const Text(
                  "Bem-vindo!",
                  style: AppTextStyles.kPrimaryTextLoginPage,
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 48.0, right: 57.0),
            child: SizedBox(
              child: Text(
                'Agora crie sua senha\ncontendo:',
                style: AppTextStyles.kSubTitleSignUpText,
              ),
            ),
          ),
          const SizedBox(height: 28),
          const Padding(
            padding: EdgeInsets.only(left: 48.0),
            child: Text(
              '• pelo menos oito caracteres',
              style: AppTextStyles.kPasswordTextLogin,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 48.0),
            child: Text(
              '• letras maiúsculas, letras\n minúsculas, números e símbolos',
              style: AppTextStyles.kPasswordTextLogin,
            ),
          ),
          SizedBox(height: size.height * 0.01),
          InputForm(
              hintText: "Crie uma senha",
              labelText: "Senha",
              controller: widget.passwordController,
              onChanged: (value) {
                password = value;
              },
              validator: (value) => Validators().validatePassword(value!),
              keyboardType: TextInputType.visiblePassword,
              obscureText: !controller.passwordVisible,
              onEditingComplete: () {
                FocusScope.of(context).nextFocus();
              },
              suffixIcon: VisibleWidget(
                  visible: !controller.passwordVisible,
                  onPressed: () {
                    controller.changePasswordVisible();
                  })),
          SizedBox(height: size.height * 0.04),
          InputForm(
              keyboardType: TextInputType.visiblePassword,
              hintText: "Confirme sua senha",
              labelText: "Confirmar senha",
              controller: widget.confirmPasswordController,
              validator: (value) =>
                  Validators().validateConfirmPassword(value!, password),
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
              },
              obscureText: !controller.confirmPasswordVisible,
              suffixIcon: VisibleWidget(
                  visible: !controller.confirmPasswordVisible,
                  onPressed: () {
                    controller.changeconfirmPasswordVisible();
                  })),
        ],
      );
    });
  }
}
