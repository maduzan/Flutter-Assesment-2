import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:sample/providers/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  String? userEmail;

  void initState() {
    getEmail();
  }

  Future<void> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('userEmail');
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<ProviderClass>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        leading: IconButton(
          onPressed: () {
            GoRouter.of(context).go('/home');
          },
          icon: Icon(Icons.home),
        ),
      ),
      body: FutureBuilder(
        future: userProvider.fetchUserByEmail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          return Consumer<ProviderClass>(
            builder: (context, provider, _) {
              final user = provider.currentUser;
              return user != null
                  ? ListView(
                    padding: EdgeInsets.all(16),
                    children: [
                      SizedBox(height: 100),

                      Icon(Icons.person, size: 240),

                      SizedBox(height: 40),

                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 63, 59, 59),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Full Name: ${user.fullname}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 63, 59, 59),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Email: ${user.email}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 63, 59, 59),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'Telephone: ${user.telephone}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  )
                  : Center(child: Text("No user found"));
            },
          );
        },
      ),
    );
  }
}
