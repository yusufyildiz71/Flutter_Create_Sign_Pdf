import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';
import 'package:printing/printing.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'package:pdf/pdf.dart';
import 'package:task2_freelance/MyDoc.dart';

class CreateNewDoc extends StatefulWidget {
  const CreateNewDoc({super.key});

  @override
  State<CreateNewDoc> createState() => _CreateNewDocState();
}

class _CreateNewDocState extends State<CreateNewDoc> {
  final keySignaturePad = GlobalKey<SfSignaturePadState>();
  final documentController = TextEditingController();
  final pdf = pw.Document();
  PlatformFile? pickedFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.orange,
          onPressed: (() {
            createPdf();
          }),
          label: const Text("SAVE")),
      appBar: AppBar(title: const Text("Create New Document")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset('assets/create.json'),
              ),
              TextFormField(
                controller: documentController,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    hintText: 'Document',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: SfSignaturePad(
              //     key: keySignaturePad,
              //     strokeColor: Colors.orange,
              //     backgroundColor: Colors.yellow.shade100,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  createPdf() async {
    final signature = await networkImage(
        'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Jon_Kirsch%27s_Signature.png/1280px-Jon_Kirsch%27s_Signature.png');
    pdf.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.Center(child: pw.Text(documentController.text)),
            pw.SizedBox(
              height: 150,
              width: 150,
              child: pw.Center(child: pw.Image(signature)),
            )
          ]);
        }));
    try {
      final dir = await getExternalStorageDirectory();
      final file = File('${dir!.path}/filename.pdf');
      await file.writeAsBytes(await pdf.save());
      final path = 'MyDocuments/' + DateTime.now().toString();
      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(file);
      print("saved the doc");
    } catch (e) {
      print(e.toString());
    }

    Get.snackbar("Success", "New Pdf Created-Signed",
        backgroundColor: Colors.orange, snackPosition: SnackPosition.BOTTOM);
  }
}
