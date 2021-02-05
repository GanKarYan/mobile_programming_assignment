import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:coinmemoria/registerscreen.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'mainscreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailcontroller = TextEditingController();
  String _email = "";
  final TextEditingController _pwcontroller = TextEditingController();
  String _password = "";
  bool _isChecked = false;
  SharedPreferences prefs;

  @override
  void initState() {
    loadpref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressAppBar,
      //debugShowCheckedModeBanner: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Login', style: TextStyle(fontSize: 20)),
          backgroundColor: Colors.orange,
        ),
        //resizeToAvoidBottomPadding: false,
        body: new Container(
          padding: EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "assets/images/logo.png",
                    height: 100,
                    width: 150,
                  ),
                  TextField(
                      controller: _emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: 'Email', icon: Icon(Icons.email))),
                  TextField(
                    controller: _pwcontroller,
                    decoration: InputDecoration(
                        labelText: 'Password', icon: Icon(Icons.lock)),
                    obscureText: true,
                  ),
                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool value) {
                          _onChange(value);
                        },
                      ),
                      Text('Remember Me', style: TextStyle(fontSize: 15))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    minWidth: 200,
                    height: 40,
                    child: Text('Login', style: TextStyle(fontSize: 16)),
                    color: Colors.orange,
                    textColor: Colors.black,
                    elevation: 20,
                    onPressed: _onLogin,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                      onTap: _onRegister,
                      child: Text('Register New Account',
                          style: TextStyle(fontSize: 14))),
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: _onForget,
                      child: Text('Forget Password?',
                          style: TextStyle(fontSize: 14))),
                ]),
          ),
        ),
      ),
    );
  }

  Future<void> _onLogin() async {
    _email = _emailcontroller.text;
    _password = _pwcontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Login...");
    await pr.show();
    http.post("http://sopmathpowy2.com/CoinMemoria/php/login_user.php", body: {
      "email": _email,
      "password": _password,
    }).then((res) {
      print(res.body);
      if (res.body == "success") {
        Toast.show(
          "Login success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
      } else {
        Toast.show(
          "Login failed",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        
      }
    }).catchError((err) {
      print(err);
    });
    await pr.hide();
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
      savepref(value);
    });
  }

  void _onRegister() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => RegisterScreen()));
  }

  void _onForget() {
    print('Forget');
  }

  void loadpref() async {
    prefs = await SharedPreferences.getInstance();
    _email = (prefs.getString('email')) ?? '';
    _password = (prefs.getString('password')) ?? '';
    _isChecked = (prefs.getBool('ischecked')) ?? false;
    if (_email.isNotEmpty) {
      setState(() {
        _emailcontroller.text = _email;
        _pwcontroller.text = _password;
        _isChecked = _isChecked;
      });
    }
  }

  void savepref(bool value) async {
    prefs = await SharedPreferences.getInstance();
    _email = _emailcontroller.text;
    _password = _pwcontroller.text;

    if (value) {
      if (_email.length < 5 && _password.length < 3) {
        print("Email/Password Empty");
        _isChecked = false;

        Toast.show(
          "Email/password empty",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
        );
      } else {
        await prefs.setString('email', _email);
        await prefs.setString('password', _password);
        await prefs.setBool('ischecked', value);

        Toast.show(
          "Remembered",
          context,
          duration: Toast.LENGTH_SHORT,
          gravity: Toast.BOTTOM,
        );
        print("Success");
      }
    } else {
      await prefs.setString('email', '');
      await prefs.setString('password', '');
      await prefs.setBool('ischecked', false);
      setState(() {
        _emailcontroller.text = '';
        _pwcontroller.text = '';
        _isChecked = false;
      });

      Toast.show(
        "Remember me unsaved",
        context,
        duration: Toast.LENGTH_SHORT,
        gravity: Toast.BOTTOM,
      );
    }
  }

  Future<bool> _onBackPressAppBar() async {
    SystemNavigator.pop();
    print('Backpress');
    return Future.value(false);
  }
}
