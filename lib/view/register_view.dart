import 'package:catatan_keuangan/view/login_view.dart';
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
  bool passwordVisible = false;
  bool confirmpasswordVisible = false;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  void initState() {
    super.initState();
    passwordVisible = true;
    confirmpasswordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          body: Container(
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
                            textFieldForm("Nama", nameController,
                                TextInputType.name, Icons.person),
                            textFieldForm("Email", emailController,
                                TextInputType.emailAddress, Icons.email),
                            textFieldForm("Phone Number", phoneController,
                                TextInputType.phone, Icons.phone),
                            passwordForm("Password", passwordController,
                                passwordVisible),
                            passwordForm(
                                "Confirm Password",
                                confirmPasswordController,
                                confirmpasswordVisible),
                            const SizedBox(height: 30),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: headerColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5))),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                child: const Text(
                                  "SIGN UP",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Poppins-bold',
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              color: primaryColor,
                              thickness: 1,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return LoginView();
                                }));
                              },
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: headerColor,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          color: headerColor, width: 1),
                                      borderRadius: BorderRadius.circular(5))),
                              child: Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                alignment: Alignment.center,
                                child: const Text(
                                  "LOGIN",
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
              )),
        ),
      ),
      theme: ThemeData(fontFamily: 'Poppins-regular'),
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

  TextField passwordForm(
      String label, TextEditingController controller, bool visible) {
    return TextField(
      autocorrect: false,
      keyboardType: TextInputType.visiblePassword,
      obscureText: visible,
      controller: controller,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: const Icon(Icons.lock),
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
      style: const TextStyle(
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
