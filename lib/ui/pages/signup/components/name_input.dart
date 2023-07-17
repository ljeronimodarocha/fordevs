import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../utils/utils.dart';
import '../signup_presenter.dart';

class NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Provider.of<SignUpPresenter>(context);
    return StreamBuilder<String>(
        stream: presenter.nameErrorStream,
        builder: (context, snapshot) {
          return TextFormField(
            decoration: InputDecoration(
              labelText: S.name,
              icon: Icon(Icons.person,
                  color: Theme.of(context).primaryColorLight),
              errorText: snapshot.data?.isEmpty == true ? null : snapshot.data,
            ),
            keyboardType: TextInputType.name,
            onChanged: presenter.validateName,
          );
        });
  }
}
