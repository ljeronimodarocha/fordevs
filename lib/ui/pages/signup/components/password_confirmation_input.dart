import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../signup_presenter.dart';

class PasswordConfirmationInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);

    return StreamBuilder<String>(
        stream: presenter.passwordConfirmationErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: S.confirmPassword,
              icon:
                  Icon(Icons.lock, color: Theme.of(context).primaryColorLight),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
            obscureText: true,
            onChanged: presenter.validatePasswordConfirmation,
          );
        });
  }
}
