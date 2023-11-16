import 'package:catatan_keuangan/components/input_components.dart';
import 'package:catatan_keuangan/view/login_view.dart';
import 'package:flutter/material.dart';
import '../tools/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    super.key,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _auth = FirebaseAuth.instance;

  bool _isLoading = false;

  bool passwordVisible = false;
  bool confirmpasswordVisible = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void initState() {
    super.initState();
    passwordVisible = true;
    confirmpasswordVisible = true;
  }

  void toLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginView();
    }));
  }

  void register() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final navigator = Navigator.of(context);
      final email = emailController.text;
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;

      if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
        throw ("Please fill all fields");
      } else {
        if (password != confirmPassword) {
          throw ("Password and confirm password must be same");
        } else if (password.length < 6) {
          throw ("Password must be at least 6 characters");
        } else {
          await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
        }
      }
      navigator.pop();
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [secondaryColor, headerColor, primaryColor]),
                ),
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 50),
                        child: Container(
                          child: Column(
                            children: [
                              UserField(
                                  label: 'Nama',
                                  controller: nameController,
                                  inputType: TextInputType.name,
                                  icon: Icons.person),
                              UserField(
                                  label: 'Email',
                                  controller: emailController,
                                  inputType: TextInputType.emailAddress,
                                  icon: Icons.email),
                              PasswordField(
                                  label: 'Password',
                                  controller: passwordController,
                                  passVisible: passwordVisible,
                                  visPresed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  }),
                              PasswordField(
                                  label: 'Confirm Password',
                                  controller: confirmPasswordController,
                                  passVisible: confirmpasswordVisible,
                                  visPresed: () {
                                    setState(() {
                                      confirmpasswordVisible =
                                          !confirmpasswordVisible;
                                    });
                                  }),
                              const SizedBox(height: 30),
                              ButtonAuth(
                                  label: "SIGN UP",
                                  onPressed: register,
                                  fgColor: Colors.white,
                                  bgColor: headerColor),
                              const Divider(
                                color: primaryColor,
                                thickness: 1,
                              ),
                              ButtonAuth(
                                  label: "LOGIN",
                                  onPressed: toLogin,
                                  fgColor: headerColor,
                                  bgColor: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
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
