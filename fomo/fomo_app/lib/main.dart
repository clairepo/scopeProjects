
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Simple Login Demo',
      theme: new ThemeData(
          primarySwatch: Colors.blue
      ),
      home: new LoginPage(),
    );
  }
}

class EventPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

// Used for controlling whether the user is logging or creating an account
enum FormType {
  login,
  register
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  String _email = "";
  String _password = "";
  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  // Swap in between our two forms, registering and logging in
  void _formChange() async {
    setState(() {
      if (_form == FormType.register) {
        _form = FormType.login;
      } else {
        _form = FormType.register;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Simple Login Example"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(
                  labelText: 'Email'
              ),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(
                  labelText: 'Password'
              ),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    if (_form == FormType.login) {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Login'),
              onPressed: _loginPressed,
            ),
            new FlatButton(
              child: new Text('Dont have an account? Tap here to register.'),
              onPressed: _formChange,
            ),
            new FlatButton(
              child: new Text('Forgot Password?'),
              onPressed: _passwordReset,
            )
          ],
        ),
      );
    } else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              child: new Text('Create an Account'),
              onPressed: _createAccountPressed,
            ),
            new FlatButton(
              child: new Text('Have an account? Click here to login.'),
              onPressed: _formChange,
            )
          ],
        ),
      );
    }
  }

  // These functions can self contain any user auth logic required, they all have access to _email and _password

  void _loginPressed() {
    print('The user wants to login with $_email and $_password');
    _attemptLogin();
  }

  void _createAccountPressed() {
    print('The user wants to create an accoutn with $_email and $_password');
    _attemptRegister();
  }

  void _passwordReset() {
    print("The user wants a password reset request sent to $_email");
  }

  void _attemptLogin() async{
    var settings = new ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: '',
        db: 'FOMO'
    );
    var conn = await MySqlConnection.connect(settings);
    var username = _email;
    var password = _password;
    var result = await conn.query('SELECT * from Accounts where username=? AND password=?', [username, password]);
    //check if result returned something, if so successful login
    if(result != null){

    }
  }

  void _attemptRegister() async{
    var settings = new ConnectionSettings(
        host: 'localhost',
        port: 3306,
        user: 'root',
        password: '',
        db: 'FOMO'
    );
    var conn = await MySqlConnection.connect(settings);
    var username = _email;
    var password = _password;
    var result = await conn.query('SELECT * from Accounts where username=?', [username]);
    //check if result returned something, if so username is taken
    if(result != null){

    }
    else{
      var result = await conn.query('INSERT INTO Accounts(username, password) VALUES (?,?)', [username, password]);
        //successful register
    }
  }
}


class User {
  var name;
  var _password;
  var firstName;
  var lastName;
  var friends = [];
  var privateEvents = [];

  User(var first, var last, var username, var password){
    this.name = username;
    this.firstName = first;
    this.lastName = last;
    this._password = password;
  }

  String get username{
    return name;
  }

  String get password{
    return _password;
  }

  void addFriend(var friend){
    friends.add(friend);
  }

  void addEvent(var event){
    privateEvents.add(event);
  }

  void resetPass(var newPass){
    _password = newPass;
  }

  void resetUser(var newUname){
    name = newUname;
  }

}


