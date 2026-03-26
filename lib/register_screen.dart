import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String role = 'customer';
  bool isLoading = false;
  bool isPasswordHidden = true;

  void registerUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    /// 🔐 VALIDATION (NEW)
    if (email.isEmpty || password.isEmpty) {
      showMsg("Please fill all fields");
      return;
    }

    if (!email.contains('@')) {
      showMsg("Enter a valid email");
      return;
    }

    if (password.length < 6) {
      showMsg("Password must be at least 6 characters");
      return;
    }

    setState(() => isLoading = true);

    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.user!.uid)
          .set({
        'email': email,
        'role': role,
      });

      showMsg("Registration Successful");

      await FirebaseAuth.instance.signOut();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
      );

    } on FirebaseAuthException catch (e) {
      showMsg(e.message ?? "Something went wrong");
    } catch (e) {
      showMsg("Error occurred");
    }

    setState(() => isLoading = false);
  }

  /// 🔥 CLEAN SNACKBAR METHOD (NEW)
  void showMsg(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6A11CB),
              Color(0xFF2575FC),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25),

                child: Card(
                  elevation: 12,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(25),

                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        const Text(
                          "Create Account ✨",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 25),

                        /// EMAIL
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress, // ✅ NEW
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon:
                                const Icon(Icons.email_outlined),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// PASSWORD
                        TextField(
                          controller: passwordController,
                          obscureText: isPasswordHidden,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon:
                                const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                isPasswordHidden
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  isPasswordHidden =
                                      !isPasswordHidden;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        /// ROLE
                        DropdownButtonFormField<String>(
                          initialValue: role,
                          decoration: InputDecoration(
                            labelText: "Select Role",
                            prefixIcon:
                                const Icon(Icons.person_outline),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(15),
                            ),
                          ),
                          items: const [
                            DropdownMenuItem(
                                value: 'seller',
                                child: Text('Seller')),
                            DropdownMenuItem(
                                value: 'customer',
                                child: Text('Customer')),
                          ],
                          onChanged: (value) {
                            setState(() {
                              role = value!;
                            });
                          },
                        ),

                        const SizedBox(height: 30),

                        /// REGISTER BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed:
                                isLoading ? null : registerUser,
                            style:
                                ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.deepPurple,
                              padding:
                                  const EdgeInsets.symmetric(
                                      vertical: 16),
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        15),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child:
                                        CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const LoginScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            "Already have an account? Login",
                            style: TextStyle(
                              color: Colors.deepPurple,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}