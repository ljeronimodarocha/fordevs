import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../utils/utils.dart';
import '../../components/components.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  SignUpPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currectFocus = FocusScope.of(context);
      if (!currectFocus.hasPrimaryFocus) {
        currectFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(builder: (context) {
        presenter.isLoadingStream.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.mainErrorStream.listen((error) {
          if (error.isNotEmpty) {
            showErrorMessage(context, error);
          }
        });

        presenter.navigateToStream.listen((page) {
          if (page.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });

        return GestureDetector(
          onTap: _hideKeyboard,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LoginHeader(),
                Headline1(text: S.addAccount),
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Provider(
                    create: (_) => presenter,
                    child: Form(
                      child: Column(
                        children: <Widget>[
                          NameInput(),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: EmailInput(),
                          ),
                          PasswordInput(),
                          Padding(
                            padding: EdgeInsets.only(top: 8, bottom: 32),
                            child: PasswordConfirmationInput(),
                          ),
                          SignUpButton(),
                          ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.exit_to_app),
                              label: Text(S.login))
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
