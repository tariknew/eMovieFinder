import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:file_picker/file_picker.dart';

Future<dynamic> generateAndSavePdf(String title, int totalOrders) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                "Movie Order Report",
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text("Title: $title", style: pw.TextStyle(fontSize: 18)),
              pw.Text("Total Orders: $totalOrders",
                  style: pw.TextStyle(fontSize: 18)),
            ],
          ),
        );
      },
    ),
  );

  String? filePath = await FilePicker.platform.saveFile(
    dialogTitle: 'Save PDF File',
    fileName: "${title.replaceAll(RegExp(r'[<>:"/\\|?*]'), '_')}_order_report.pdf",
    allowedExtensions: ['pdf'],
    type: FileType.custom,
  );

  if (filePath != null) {
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return true;
  }

  return false;
}
