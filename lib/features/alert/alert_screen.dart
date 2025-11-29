import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elesafe_app/features/alert/models/alert_data_model.dart';
import 'package:elesafe_app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertScreen extends StatefulWidget {
  final String email;
  const AlertScreen({super.key, required this.email});

  @override
  State<AlertScreen> createState() => _AlertScreenState();
}

class _AlertScreenState extends State<AlertScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _sortAscending = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _logout() {
    context.go(AppRouter.loginPath);
  }

  @override
  Widget build(BuildContext context) {
    final alertsCollection = FirebaseFirestore.instance.collection('Ele-Safe');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Alert Logs',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Welcome, ${widget.email}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by status, description, date...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                  ),
                  tooltip: 'Sort by date',
                  onPressed: () {
                    setState(() {
                      _sortAscending = !_sortAscending;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: alertsCollection.orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No alerts found.'));
                }

                var alerts = snapshot.data!.docs
                    .map((doc) => AlertDataModel.fromFirestore(doc.id, doc.data() as Map<String, dynamic>))
                    .toList();

                if (_searchQuery.isNotEmpty) {
                  alerts = alerts.where((alert) {
                    final query = _searchQuery.toLowerCase();
                    final descriptionMatch = alert.description.toLowerCase().contains(query);
                    final dateMatch = alert.timestamp.toLowerCase().contains(query);

                    final elephantAlertSuffixes = {
                      'PLD', 'LPD', 'DPL', 'PDL', 'LDP', 'LP', 'PL', 'DL', 'LD'
                    };
                    final bool isElephantAlert = elephantAlertSuffixes.any((suffix) => alert.title.endsWith(suffix));
                    final status = isElephantAlert ? 'elephant' : 'clear';
                    final statusMatch = status.toLowerCase().contains(query);

                    return descriptionMatch || dateMatch || statusMatch;
                  }).toList();
                }

                alerts.sort((a, b) {
                  return _sortAscending
                      ? a.timestamp.compareTo(b.timestamp)
                      : b.timestamp.compareTo(a.timestamp);
                });

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  itemCount: alerts.length,
                  itemBuilder: (context, index) {
                    final alert = alerts[index];

                    final elephantAlertSuffixes = {
                      'PLD', 'LPD', 'DPL', 'PDL', 'LDP', 'LP', 'PL', 'DL', 'LD'
                    };

                    final bool isElephantAlert = elephantAlertSuffixes.any((suffix) => alert.title.endsWith(suffix));

                    final Color backgroundColor = isElephantAlert ? Colors.red.withOpacity(0.1) : Colors.green.withOpacity(0.1);
                    final RichText titleWidget = isElephantAlert
                        ? RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.3,
                              ),
                              children: [
                                TextSpan(text: 'Sensor Triggered : '),
                                TextSpan(
                                  text: 'Elephant',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        : RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                color: Colors.black,
                                height: 1.3,
                              ),
                              children: [
                                TextSpan(text: 'Sensor Triggered Clear'),
                              ],
                            ),
                          );

                    return GestureDetector(
                      onTap: () => context.push(AppRouter.mapPath, extra: alert),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: isElephantAlert ? const Color(0xFFff4444) : Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.error_outline, color: Colors.white, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  titleWidget,
                                  const SizedBox(height: 6),
                                  Text(
                                    alert.timestamp,
                                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
