import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class MyDoc extends StatefulWidget {
  const MyDoc({super.key});

  @override
  State<MyDoc> createState() => _MyDocState();
}

class _MyDocState extends State<MyDoc> {
  late Future<ListResult> futureDocuments;
  @override
  void initState() {
    super.initState();

    futureDocuments = FirebaseStorage.instance.ref('/MyDocuments').listAll();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      appBar: AppBar(
        title: const Text("My Documents"),
      ),
      body: FutureBuilder<ListResult>(
        future: futureDocuments,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pdfs = snapshot.data!.items;
            return ListView.builder(
                itemCount: pdfs.length,
                itemBuilder: ((context, index) {
                  final pdf = pdfs[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(18)),
                      child: ListTile(
                        title: Center(child: Text(pdf.name)),
                        onTap: () {
                          downloadDoc(pdf);
                        },
                      ),
                    ),
                  );
                }));
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future downloadDoc(Reference ref) async {
    final url = await ref.getDownloadURL();
    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/${ref.name}';

    await Dio().download(url, path);

    if (url.contains('.pdf')) {
      await PdfView(path: path);
    }

    //await ref.writeToFile(file);
    //PdfView(path: file.path);

    Get.snackbar("success", "Document downloaded");
  }
}
