import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'entidades/user.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _form = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _emailController = TextEditingController();
  List<User> _userList = <User>[];
  User _user = User();
  bool _controller = false;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text('Cadastro de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  labelStyle: TextStyle(color: Colors.teal),
                  labelText: 'Nome completo',
                ),
                validator: (valor) {
                  if (valor.length < 3) return 'O nome é muito curto';
                  if (valor.length > 30) return 'O nome é muito longo';
                  return null;
                },
                onSaved: (newLog) {
                  _user.name = newLog;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _ageController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  labelStyle: TextStyle(color: Colors.teal),
                  labelText: 'Idade',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if ((int.tryParse(value) ?? 0) <= 0)
                    return 'A idade é inválida';
                  return null;
                },
                onSaved: (newLog) {
                  _user.age = int.tryParse(newLog);
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  labelStyle: TextStyle(color: Colors.teal),
                  labelText: 'Email',
                ),
                validator: (value) {
                  final bool isTrue = EmailValidator.validate(value);
                  if (!isTrue) {
                    return 'O email é inválido';
                  }
                  return null;
                },
                onSaved: (newLog) {
                  _user.email = newLog;
                },
              ),
              SizedBox(height: 10),
              Container(
                //color: Colors.teal,
                width: double.maxFinite,
                child: OutlineButton(
                  onPressed: () {
                    saveUser();
                    if (_controller) {
                      setState(() {
                        _userList.add(_user);
                        _user = User();
                      });
                    }
                  },
                  child: Text(
                    'Salvar',
                    style: TextStyle(fontSize: 20),
                  ),
                  color: Colors.teal,
                  textColor: Colors.teal,
                  borderSide: BorderSide(color: Colors.teal),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: _userList.length,
                  itemBuilder: (context, index) {
                    String name = _userList[index].name;
                    int age = _userList[index].age;
                    String email = _userList[index].email;
                    return ListTile(
                      onLongPress: () {
                        setState(() {
                          _userList.remove(_user);
                        });
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(
                            'https://www.gravatar.com/avatar/$index?d=monsterid'),
                      ),
                      title: Text('$name, $age'),
                      subtitle: Text('$email'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void logValidate() {
    if (!_form.currentState.validate()) {
      _controller = false;
      _scaffoldKey.currentState
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
              duration: Duration(milliseconds: 250),
              content: Text(
                'Dados inválidos',
                style: TextStyle(fontSize: 20),
              ),
              backgroundColor: Colors.red),
        );
      return;
    }
    _controller = true;
  }

  void saveUser() {
    _form.currentState.save();
    logValidate();
  }
}
