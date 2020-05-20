import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:onde_tem_saude_app/models/contact_model.dart';
import 'package:onde_tem_saude_app/ui/widgets/custom_drawer.dart';

class ContactUsTab extends StatefulWidget {
  static const String routeName = '/contactUs';

  @override
  _ContactUsTabState createState() => _ContactUsTabState();
}

class _ContactUsTabState extends State<ContactUsTab> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = MaskedTextController(mask: '(00) 0 0000-0000');
  final _messageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        drawer: CustomDrawer(ContactUsTab.routeName),
        appBar: AppBar(
          title: Text("Nos envie uma mensagem..."),
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
            ScopedModel<ContactModel>(
                model: ContactModel(),
                child: ScopedModelDescendant<ContactModel>(
                    builder: (context, child, model) {
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
                                labelText: "Nome", icon: Icon(Icons.person)),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                                labelText: "E-mail*", icon: Icon(Icons.email)),
                            keyboardType: TextInputType.emailAddress,
                            validator: (text) {
                              if (text.isEmpty)
                                return "Informe a email para contato!";
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                                labelText: "Telefone", icon: Icon(Icons.phone)),
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            controller: _messageController,
                            maxLines: 4,
                            decoration: InputDecoration(hintText: "Mensagem*"),
                            validator: (text) {
                              if (text.isEmpty) return "Informe a mensagem!";
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
                                "ENVIAR",
                                style: TextStyle(fontSize: 18.0),
                              ),
                              textColor: Colors.white,
                              color: Theme.of(context).primaryColor,
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  Map<String, dynamic> _data = {
                                    "name": _nameController.text,
                                    "email": _emailController.text,
                                    "phone": _phoneController.text,
                                    "message": _messageController.text,
                                    "date": DateTime.now()
                                  };

                                  model.send(
                                      data: _data,
                                      onSuccess: _onSuccess,
                                      onFail: _onFail);
                                }
                              },
                            ),
                          )
                        ],
                      ));
                })),
          ],
        ));
  }

  void _onSuccess() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Mensagem enviada com sucesso!"),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 2),
    ));

    Future.delayed(Duration(seconds: 2)).then((_) {
      _nameController.text = "";
      _emailController.text = "";
      _phoneController.text = "";
      _messageController.text = "";
    });
  }

  void _onFail() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text("Falha ao enviar a mensagem!"),
      backgroundColor: Colors.redAccent,
      duration: Duration(seconds: 2),
    ));
  }
}
