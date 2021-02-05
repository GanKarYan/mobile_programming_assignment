import 'package:flutter/material.dart';
import 'package:coinmemoria/loginscreen.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

final TextEditingController _namecontroller = TextEditingController();
final TextEditingController _emailcontroller = TextEditingController();
final TextEditingController _pwcontroller = TextEditingController();
final TextEditingController _phcontroller = TextEditingController();
String _email, _password, _phone, _name;
bool _passwordVisible = false;
bool _isChecked = false;

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        child: Padding(
            padding: EdgeInsets.all(30.0),
            child: SingleChildScrollView(
                child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  scale: 2,
                ),
                TextField(
                    controller: _namecontroller,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                        labelText: 'Name', icon: Icon(Icons.person))),
                TextField(
                    controller: _emailcontroller,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        labelText: 'Email', icon: Icon(Icons.email))),
                TextField(
                    controller: _phcontroller,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        labelText: 'Phone', icon: Icon(Icons.phone))),
                TextField(
                  controller: _pwcontroller,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    icon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: _passwordVisible,
                ),
                SizedBox(height: 10),
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
                MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  minWidth: 200,
                  height: 40,
                  child: Text('Login', style: TextStyle(fontSize: 16)),
                  color: Colors.orange,
                  textColor: Colors.black,
                  elevation: 20,
                  onPressed: _onRegister,
                ),
                SizedBox(height: 20),
                GestureDetector(
                    onTap: _onLogin,
                    child: Text('Already register',
                        style: TextStyle(fontSize: 14))),
              ],
            ))),
      ),
    );
  }

  Future<void> _onRegister() async {
    _name = _namecontroller.text;
    _email = _emailcontroller.text;
    _password = _pwcontroller.text;
    _phone = _phcontroller.text;
    ProgressDialog pr = new ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(message: "Registration...");
    await pr.show();

    http.post("http://sopmathpowy2.com/CoinMemoria/php/register_user.php",
        body: {
          "name": _name,
          "email": _email,
          "phone": _phone,
          "password": _password,
        }).then((res) {
      if (res.body == "success") {
        Toast.show(
          "Registration success",
          context,
          duration: Toast.LENGTH_LONG,
          gravity: Toast.BOTTOM,
        );
        if (_isChecked) {
          savepref();
        }
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginScreen()));
      } else {
        Toast.show(
          "This email have been registered",
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

  void _onLogin() {
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()));
  }

  void _onChange(bool value) {
    setState(() {
      _isChecked = value;
    });
  }

  void savepref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = _emailcontroller.text;
    _password = _pwcontroller.text;
    await prefs.setString('email', _email);
    await prefs.setString('password', _password);
    await prefs.setBool('rememberme', true);
  }
}
