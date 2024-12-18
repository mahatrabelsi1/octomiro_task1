import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/inventory_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:typed_data';



class DocumentDetailsPage extends StatelessWidget {
  final InventoryDocument document;

  const DocumentDetailsPage({super.key, required this.document});
Future<void> generatePDF(BuildContext context) async {
  final pdf = pw.Document();
  final ByteData bytes = await rootBundle.load('lib/assets/images/logo.png');
    final Uint8List imageData = bytes.buffer.asUint8List();

    final image = pw.MemoryImage(imageData);

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Padding(
          padding: pw.EdgeInsets.all(30),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Image(image, width: 400, height: 400),
              pw.Text('Document ID: ${document.id}',style: pw.TextStyle(fontSize: 30)),
              pw.Text('Date: ${document.date.toLocal().toString().split(' ')[0]}',style: pw.TextStyle(fontSize: 30)),
              pw.Text('Placement: ${document.placement}',style: pw.TextStyle(fontSize: 30)),
              pw.Text('Organization: ${document.organization}',style: pw.TextStyle(fontSize: 30)),
              pw.Text('Made By: ${document.madeBy}',style: pw.TextStyle(fontSize: 30)),
              pw.Text('Item Name: ${document.line.itemName}',style: pw.TextStyle(fontSize: 30)),
              pw.Text('Item Code: ${document.line.itemCode}',style: pw.TextStyle(fontSize: 30)),
              pw.Text('Description: ${document.line.itemDescription}',style: pw.TextStyle(fontSize: 30)),
              pw.Text('Quantity: ${document.line.quantity}',style: pw.TextStyle(fontSize: 30)),
            ],
          ),
        );
      },
    ),
  );

  final directory = await getExternalStorageDirectory();
  final filePath = "${directory!.path}/document_${document.id}.pdf";
  final file = File(filePath);

  // Save PDF
  await file.writeAsBytes(await pdf.save());

  // Show success message with path
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('PDF saved to: $filePath')),
  );

  print('PDF saved to: $filePath');
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Document Details',
          style: TextStyle(
              color: Color.fromRGBO(31, 102, 111, 1),
              fontWeight: FontWeight.w800),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 18, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Document ID\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: document.id,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Date\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: document.date.toLocal().toString().split(' ')[0],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Placement\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: document.placement,
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Organization\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: document.organization,
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Item Info',
              style: TextStyle(
                fontSize:25,
                fontWeight: FontWeight.bold,
                color:  Color.fromRGBO(31, 102, 111, 1),
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Item Name\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: document.line.itemName,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Item Code\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: document.line.itemCode,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Description\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: document.line.itemDescription,
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Quantity\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '${document.line.quantity}',
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  TextSpan(
                    text: 'Made by\n',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: document.madeBy,
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => generatePDF(context),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color.fromRGBO(31, 102, 111, 1),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text('Generate PDF Document',style: TextStyle(color: Colors.white,fontWeight: FontWeight.w700),),
            ),
          ],
        ),
      ),
    );
  }
}
