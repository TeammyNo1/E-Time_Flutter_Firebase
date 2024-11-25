import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'forgotpassword_user.dart';

class HomePage extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  Future<void> saveWorkIn() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    String userId = currentUser.uid;
    String userEmail = currentUser.email ?? 'Unknown User';
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String time = DateFormat('hh:mm a').format(DateTime.now());

    bool isLate = DateTime.now().isAfter(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, 8, 30));

    await FirebaseFirestore.instance
        .collection('time_entries')
        .doc(userId)
        .collection('log_entries')
        .doc(date)
        .set({
      'email': userEmail,
      'work_in': time,
      'work_out': '',
      'status': isLate ? 'Late' : 'On Time',
    }, SetOptions(merge: true));
  }

  Future<void> saveWorkOut() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    String userId = currentUser.uid;
    String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
    String time = DateFormat('hh:mm a').format(DateTime.now());

    await FirebaseFirestore.instance
        .collection('time_entries')
        .doc(userId)
        .collection('log_entries')
        .doc(date)
        .update({
      'work_out': time,
    });
  }

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  List<String> getDatesUntilEndOfMonth() {
    DateTime now = DateTime.now();
    DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    List<String> dates = [];
    for (int i = 1; i <= lastDayOfMonth.day; i++) {
      DateTime date = DateTime(now.year, now.month, i);
      dates.add(DateFormat('dd-MM-yyyy').format(date));
    }
    return dates;
  }

  void scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 1),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    String userId = currentUser?.uid ?? '';
    List<String> datesInMonth = getDatesUntilEndOfMonth();

    return Scaffold(
      backgroundColor: Colors.lightBlue.shade50,
      body: Row(
        children: [
          Container(
            width: 250,
            color: Colors.blueAccent,
            padding: EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Icon(Icons.person, color: Colors.blueAccent, size: 50),
                ),
                SizedBox(height: 20),
                Text(
                  currentUser?.email ?? 'No Email',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                ListTile(
                  leading: Icon(Icons.lock, color: Colors.white),
                  title: Text("Change Password", style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.logout, color: Colors.white),
                  title: Text("Logout", style: TextStyle(color: Colors.white)),
                  onTap: () => logOut(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueAccent, width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.access_time, color: Colors.blueAccent, size: 28),
                            SizedBox(width: 8),
                            Text(
                              DateFormat('hh:mm a').format(DateTime.now()),
                              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'image/logo.png',
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            Text(
                              DateFormat('dd-MM-yyyy').format(DateTime.now()),
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ลงเวลาเข้า-ออกงาน TIME IN/OUT",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton.icon(
                        onPressed: saveWorkIn,
                        label: Text(
                          "บันทึกเข้า",
                          style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: saveWorkOut,
                        label: Text(
                          "บันทึกออก",
                          style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton.icon(
                        onPressed: scrollToBottom,
                        label: Text(
                          "เลื่อนไปด้านล่างสุด",
                          style: TextStyle(fontSize: 18, color: Colors.blueAccent),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          side: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('time_entries')
                          .doc(userId)
                          .collection('log_entries')
                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(child: Text('Error: ${snapshot.error}'));
                        }

                        final data = snapshot.data?.docs ?? [];
                        Map<String, Map<String, dynamic>> entries = {
                          for (var doc in data) doc.id: doc.data() as Map<String, dynamic>
                        };

                        return ListView(
                          controller: _scrollController,
                          children: [
                            DataTable(
                              columns: [
                                DataColumn(
                                  label: Text(
                                    'DATE',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'WORK IN',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'WORK OUT',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'STATUS',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                                  ),
                                ),
                              ],
                              rows: datesInMonth.asMap().entries.map((entry) {
                                int index = entry.key;
                                String date = entry.value;
                                final entryData = entries[date];

                                DateTime parsedDate = DateFormat('dd-MM-yyyy').parse(date);
                                String dayName = DateFormat('EEE').format(parsedDate);
                                bool isWeekend = dayName == 'Sat' || dayName == 'Sun';

                                return DataRow(
                                  color: MaterialStateProperty.resolveWith<Color?>(
                                    (Set<MaterialState> states) {
                                      if (isWeekend) {
                                        return Colors.grey.shade300;
                                      }
                                      return index.isEven ? Colors.white : Colors.blue.shade50;
                                    },
                                  ),
                                  cells: [
                                    DataCell(
                                      Row(
                                        children: [
                                          Text(
                                            '$dayName - $date',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DataCell(Text(entryData?['work_in'] ?? '-')),
                                    DataCell(Text(entryData?['work_out'] ?? '-')),
                                    DataCell(
                                      Text(
                                        entryData?['status'] ?? '-',
                                        style: TextStyle(
                                          color: (entryData?['status'] == 'Late') ? Colors.red : Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
