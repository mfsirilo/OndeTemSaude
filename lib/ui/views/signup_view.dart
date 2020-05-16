import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:onde_tem_saude_app/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passController = TextEditingController();
  final _passConfirmController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00) 0 0000-0000');
  final _cepController = MaskedTextController(mask: '00.000-000');

  final _emailFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passFocus = FocusNode();
  final _passConfirmFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _passwordVisible;
  bool _passwordConfirmVisible;

  var selectedCity, selectedDistrict;

  @override
  void initState() {
    _passwordVisible = false;
    _passwordConfirmVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("CADASTRE-SE"),
          centerTitle: true,
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipperTwo(),
              child: Container(
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
                height: 55,
              ),
            ),
            ScopedModelDescendant<UserModel>(builder: (context, child, model) {
              if (model.isLoading)
                return Center(
                  child: CircularProgressIndicator(),
                );
              return Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.only(
                        right: 16.0, left: 16.0, bottom: 16.0, top: 50.0),
                    children: <Widget>[
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            hasFloatingPlaceholder: true,
                            filled: true,
                            labelText: "Nome",
                            icon: Icon(Icons.person)),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_emailFocus);
                        },
                        validator: (text) {
                          if (text.isEmpty) return "Nome inválido!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocus,
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_addressFocus);
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            hasFloatingPlaceholder: true,
                            filled: true,
                            labelText: "E-mail",
                            icon: Icon(Icons.email)),
                        keyboardType: TextInputType.emailAddress,
                        validator: (text) {
                          if (text.isEmpty ||
                              !text.contains("@") ||
                              !text.contains(".")) return "E-mail inválido!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: _addressController,
                        focusNode: _addressFocus,
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            hasFloatingPlaceholder: true,
                            filled: true,
                            labelText: "Endereço",
                            icon: Icon(Icons.location_on)),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_phoneFocus);
                        },
                        validator: (text) {
                          if (text.isEmpty) return "Endereço inválido!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection("cities")
                                  .where("active", isEqualTo: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData)
                                  return const Text("Carregando...");
                                else {
                                  List<DropdownMenuItem> currencyItems = [];
                                  for (int i = 0;
                                      i < snapshot.data.documents.length;
                                      i++) {
                                    DocumentSnapshot snap =
                                        snapshot.data.documents[i];
                                    currencyItems.add(
                                      DropdownMenuItem(
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 8.0, right: 8.0),
                                          child: Text(
                                            snap["name"],
                                            style: TextStyle(
                                                color: Color(0xff11b719)),
                                          ),
                                        ),
                                        value: "${snap.documentID}",
                                      ),
                                    );
                                  }
                                  return Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 6.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text("Cidade:"),
                                          DropdownButton(
                                            items: currencyItems,
                                            onChanged: (currencyValue) {
                                              setState(() {
                                                selectedCity = currencyValue;
                                              });
                                            },
                                            value: selectedCity,
                                            isExpanded: true,
                                            hint: Text(
                                              "Selecione...",
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }
                              }),
                          selectedCity == null
                              ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 6.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text("Bairro:"),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text("Selecione a Cidade..."),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection("cities")
                                      .document(selectedCity)
                                      .collection("districts")
                                      .where("active", isEqualTo: true)
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData)
                                      return const Text("Carregando...");
                                    else {
                                      List<DropdownMenuItem> currencyItems = [];
                                      for (int i = 0;
                                          i < snapshot.data.documents.length;
                                          i++) {
                                        DocumentSnapshot snap =
                                            snapshot.data.documents[i];
                                        currencyItems.add(
                                          DropdownMenuItem(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 8.0, right: 8.0),
                                              child: Text(
                                                snap["name"],
                                                style: TextStyle(
                                                    color: Color(0xff11b719)),
                                              ),
                                            ),
                                            value: "${snap.documentID}",
                                          ),
                                        );
                                      }
                                      return Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text("Bairro:"),
                                              DropdownButton(
                                                items: currencyItems,
                                                onChanged: (currencyValue) {
                                                  setState(() {
                                                    selectedDistrict =
                                                        currencyValue;
                                                  });
                                                },
                                                value: selectedDistrict,
                                                isExpanded: true,
                                                hint: Text(
                                                  "Selecione...",
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }
                                  }),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                controller: _cepController,
                                decoration: InputDecoration(
                                    fillColor: Colors.transparent,
                                    hasFloatingPlaceholder: true,
                                    filled: true,
                                    labelText: "CEP",
                                    icon: Icon(Icons.location_on)),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Padding(
                            padding:
                                const EdgeInsets.only(left: 6.0, top: 25.0),
                            child: Center(
                              child: Text(
                                "Goiás - Brasil",
                                style: TextStyle(fontSize: 22),
                              ),
                            ),
                          ))
                        ],
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _phoneController,
                        focusNode: _phoneFocus,
                        decoration: InputDecoration(
                            fillColor: Colors.transparent,
                            hasFloatingPlaceholder: true,
                            filled: true,
                            labelText: "Telefone",
                            icon: Icon(Icons.phone)),
                        onEditingComplete: () {
                          FocusScope.of(context).requestFocus(_passFocus);
                        },
                        validator: (text) {
                          if (text.isEmpty) return "Telefone inválido!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        controller: _passController,
                        focusNode: _passFocus,
                        onEditingComplete: () {
                          FocusScope.of(context)
                              .requestFocus(_passConfirmFocus);
                        },
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          hasFloatingPlaceholder: true,
                          filled: true,
                          labelText: "Senha",
                          icon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                _passwordVisible = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _passwordVisible = false;
                              });
                            },
                            child: Icon(_passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        validator: (text) {
                          if (text.isEmpty || text.length < 6)
                            return "Senha inválida!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      TextFormField(
                        obscureText: !_passwordConfirmVisible,
                        controller: _passConfirmController,
                        focusNode: _passConfirmFocus,
                        decoration: InputDecoration(
                          fillColor: Colors.transparent,
                          hasFloatingPlaceholder: true,
                          filled: true,
                          labelText: "Confirme a Senha",
                          icon: Icon(Icons.lock),
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _passwordConfirmVisible =
                                    !_passwordConfirmVisible;
                              });
                            },
                            onLongPress: () {
                              setState(() {
                                _passwordConfirmVisible = true;
                              });
                            },
                            onLongPressUp: () {
                              setState(() {
                                _passwordConfirmVisible = false;
                              });
                            },
                            child: Icon(_passwordConfirmVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                        ),
                        onEditingComplete: () {
                          _formKey.currentState.validate();
                          FocusScope.of(context).requestFocus(FocusNode());
                        },
                        validator: (text) {
                          if (text.isEmpty || text.length < 6)
                            return "Senha inválida!";
                          if (text != _passController.text)
                            return "Confirmação de Senha Diferente da Senha!";
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                      SizedBox(
                        height: 44.0,
                        child: RaisedButton(
                          child: Text(
                            "Criar Conta",
                            style: TextStyle(fontSize: 18.0),
                          ),
                          textColor: Colors.white,
                          color: Theme.of(context).primaryColor,
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              Map<String, dynamic> userData = {
                                "name": _nameController.text.trim(),
                                "email": _emailController.text.trim(),
                                "address": _addressController.text.trim(),
                                "city": selectedCity,
                                "district": selectedDistrict,
                                "cep": _cepController.text.trim(),
                                "phone1": _phoneController.text.trim(),
                              };

                              model.signUp(
                                  userData: userData,
                                  pass: _passController.text,
                                  onSuccess: _onSuccess,
                                  onFail: _onFail);
                            }
                          },
                        ),
                      )
                    ],
                  ));
            }),
          ],
        ));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Usuário criado com sucesso!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao criar o usuário!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
