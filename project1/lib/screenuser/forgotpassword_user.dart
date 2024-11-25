import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project1/screenuser/home_user.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isCurrentPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _changePassword() async {
    String currentPassword = _currentPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }
    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    User? user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You must be signed in to change your password")),
      );
      return;
    }

    try {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Password changed successfully!")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('image/logo.png', height: 100),
              SizedBox(height: 30),
              Container(
                width: 300,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change Password',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 23, 23, 23),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _currentPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Current Password',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isCurrentPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isCurrentPasswordVisible = !_isCurrentPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isCurrentPasswordVisible,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isNewPasswordVisible = !_isNewPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isNewPasswordVisible,
                    ),
                    SizedBox(height: 16),
                    TextField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm New Password',
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                            color: Colors.blueAccent,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isConfirmPasswordVisible,
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _changePassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: Colors.blueAccent),
                        ),
                        child: Text(
                          'Change Password',
                          style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        },
                        child: Text(
                          "Back to E-Time",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
