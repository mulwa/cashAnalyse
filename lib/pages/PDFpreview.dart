import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/flutter_full_pdf_viewer.dart';

class PdfPreview extends StatelessWidget {
  final String pfdPath;

  const PdfPreview({Key key, this.pfdPath}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PDFViewerScaffold(
      appBar: AppBar(
          title: Text("Preview",
              style: TextStyle(
                color: Colors.white,
              ))),
      path: pfdPath,
    );
  }
}
