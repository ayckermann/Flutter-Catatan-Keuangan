import 'package:catatan_keuangan/model/akun.dart';
import 'package:catatan_keuangan/view/home_view.dart';
import 'package:catatan_keuangan/view/register_view.dart';
import 'package:flutter/material.dart';
import 'package:catatan_keuangan/styles.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool passwordVisible = false;

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void initState() {
    super.initState();
    passwordVisible = true;
  }

  bool auth() {
    bool x = false;

    listAkun.forEach((akun) {
      if (emailController.text == akun.email &&
          passwordController.text == akun.password) {
        x = true;
      }
    });

    return x;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0077B6),
                  Color(0xFF3096C7),
                  Color(0xFFADE8F4)
                ]),
          ),
          alignment: Alignment.bottomCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              formTitle("CREATE\nACCOUNT"),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomRight: Radius.circular(100),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                child: Container(
                  child: Column(
                    children: [
                      textFieldForm("Email", emailController,
                          TextInputType.emailAddress, Icons.email),
                      passwordForm("Password", passwordController),
                      SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (auth()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomeView()));
                          } else {
                            showDialog(
                                context: context,
                                builder: (BuildContext) {
                                  return AlertDialog(
                                    title: Text('Login Gagal'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  );
                                });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: headerColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5))),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.center,
                          child: const Text(
                            "LOGIN",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins-bold',
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        color: primaryColor,
                        thickness: 1,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return RegisterView();
                          }));
                        },
                        style: ElevatedButton.styleFrom(
                            foregroundColor: headerColor,
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                side: BorderSide(color: headerColor, width: 1),
                                borderRadius: BorderRadius.circular(5))),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          alignment: Alignment.center,
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins-bold',
                              color: headerColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField textFieldForm(String label, TextEditingController controller,
      TextInputType type, IconData icon) {
    return TextField(
      autocorrect: false,
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
      ),
    );
  }

  TextField passwordForm(String label, TextEditingController controller) {
    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      obscureText: passwordVisible,
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(passwordVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: () {
            setState(
              () {
                passwordVisible = !passwordVisible;
              },
            );
          },
        ),
        alignLabelWithHint: false,
      ),
      style: TextStyle(
        fontSize: 16,
      ),
    );
  }

  Container formTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(left: 30, top: 30),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 32,
          fontWeight: FontWeight.w900,
          fontFamily: 'Poppins-bold',
        ),
      ),
    );
  }
}
