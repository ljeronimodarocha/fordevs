import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../signup_presenter.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<String>(
        stream: presenter.emailErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: S.email,
              icon:
                  Icon(Icons.email, color: Theme.of(context).primaryColorLight),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
            keyboardType: TextInputType.emailAddress,
            onChanged: presenter.validateEmail,
          );
        });
  }
}
