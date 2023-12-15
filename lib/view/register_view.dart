import 'package:catatan_keuangan/components/input_components.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../tools/styles.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({
    super.key,
  });

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

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
    Navigator.pushNamed(context, '/login');
  }

  void register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String nama = nameController.text;
      String email = emailController.text;
      String password = passwordController.text;
      String confirmPassword = confirmPasswordController.text;

      if (nama.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty) {
        throw ("Please fill all fields");
      } else {
        if (passwordController.text != confirmPasswordController.text) {
          throw ("Password and confirm password must be same");
        } else if (passwordController.text.length < 6) {
          throw ("Password must be at least 6 characters");
        }

        CollectionReference akunCollection = _firestore.collection('akun');

        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .catchError((e) {
          throw (e);
        });

        final id = akunCollection.doc().id;

        await akunCollection.doc(id).set({
          'uid': _auth.currentUser!.uid,
          'nama': nama,
          'email': email,
          'saldo': 0,
          'docId': id,
        }).catchError((e) {
          throw (e);
        });

        Navigator.pushReplacementNamed(context, '/login');
      }
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
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 30),
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
}
