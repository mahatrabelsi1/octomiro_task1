import 'package:flutter/material.dart';
import '../models/inventory_model.dart';
import 'document_details_page.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class InventoryListPage extends StatefulWidget {
  final String username; // Added to accept the username

  const InventoryListPage({super.key, required this.username});

  @override
  _InventoryListPageState createState() => _InventoryListPageState();
}

class _InventoryListPageState extends State<InventoryListPage> {
  List<InventoryDocument> inventoryDocuments = [];

  @override
  void initState() {
    super.initState();
    loadInventoryData().then((data) {
      setState(() {
        inventoryDocuments = data;
      });
    });
  }

  Future<List<InventoryDocument>> loadInventoryData() async {
    final String response = await rootBundle.loadString('lib/assets/data.json');
    final List<dynamic> jsonData = json.decode(response);
    return jsonData.map((data) => InventoryDocument.fromJson(data)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/images/logoS.png',
              height: 40,
              width: 40,
              fit: BoxFit.contain,
            ),
            SizedBox(width: 10),
            Text(
              'Inventory Documents',
              style: TextStyle(
                color: Color.fromRGBO(31, 102, 111, 1),
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Message
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, ${widget.username}!\nDate: ${DateTime.now().toLocal().toString().split(' ')[0]}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: inventoryDocuments.isEmpty
                ? Center(child: CircularProgressIndicator()) // Show loader
                : ListView.builder(
                    itemCount: inventoryDocuments.length,
                    itemBuilder: (context, index) {
                      final document = inventoryDocuments[index];
                      return ListTile(
                        leading: Icon(Icons.description,
                            color: Color.fromRGBO(31, 102, 111, 1), size: 30),
                        title: Text(document.id),
                        subtitle: Text(
                          ' ${document.date.toLocal().toString().split(' ')[0]}\n',
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Navigate to DocumentDetailsPage and pass document
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DocumentDetailsPage(document: document),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[300],
                            foregroundColor: Colors.black,
                          ),
                          child: Text('View Details'),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
