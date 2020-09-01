
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_news_app/src/bloc/company/company_bloc.dart';

class RegisterCompanyWidget extends StatefulWidget {
  final String userId;
  RegisterCompanyWidget({Key key, this.userId}) : super(key: key);

  @override
  _RegisterCompanyWidgetState createState() => _RegisterCompanyWidgetState();
}

class _RegisterCompanyWidgetState extends State<RegisterCompanyWidget> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> formData = {'company': null};
  CompanyBloc _companyBloc;

@override
  void initState() {
    _companyBloc = BlocProvider.of<CompanyBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: CircleAvatar(
                child: Icon(Icons.close),
                backgroundColor: Colors.red,
              ),
            ),
          ),
          Text(
            'Add Company',
            style: TextStyle(
              fontFamily: 'Roboto-Regular',
              fontSize: 16.0,
            ),
            textAlign: TextAlign.center,
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    onSaved: (String value) {
                      formData['company'] = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        fontSize: 12.0,
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        _companyBloc.add(
                          CompanyEventStore(
                            data: formData['company'],
                            userId: widget.userId,
                          )
                        );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
