import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mpesa_ledger/models/expenditure.model.dart';
import 'package:mpesa_ledger/models/received.model.dart';
import 'package:mpesa_ledger/pages/PDFpreview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets/font.dart';
import 'package:mpesa_ledger/utils/currencyUtil.dart';

class AnalysisPrint {
  String _bgShape;
  PdfColor _colorAccent = PdfColor.fromHex('38006b');
  PdfColor _black = PdfColor.fromHex('000000');
  final List<Received> received;
  final List<Expenditure> expenditure;

  AnalysisPrint({@required this.received, @required this.expenditure});

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  pw.PageTheme _buildTheme(
      PdfPageFormat pageFormat, pw.Font base, pw.Font bold, pw.Font italic) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.withFont(
        base: base,
        bold: bold,
        italic: italic,
      ),
      buildBackground: (context) => pw.FullPage(
        ignoreMargins: true,
        child: pw.SvgImage(svg: _bgShape),
      ),
    );
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Container(
                  height: 50,
                  child: pw.Text("Uungani Contributors",
                      style: pw.TextStyle(
                        fontSize: 26,
                        fontWeight: pw.FontWeight.bold,
                        color: _colorAccent,
                      ))),
              pw.SizedBox(height: 6),
              pw.Text(
                  "Contribution towards construction of commercial business shops",
                  style: pw.TextStyle(fontSize: 16, color: PdfColors.black),
                  textAlign: pw.TextAlign.center),
              pw.SizedBox(height: 6),
              pw.Divider(color: _colorAccent),
              pw.SizedBox(height: 10),
            ],
          ),
          pw.Column(children: [
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Container(
                      padding: pw.EdgeInsets.all(6.0),
                      color: _colorAccent,
                      child: pw.Column(
                        children: [
                          pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
                            pw.Text("Cashed In",
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12.0,
                                  fontWeight: pw.FontWeight.bold,
                                )),
                            pw.SizedBox(width: 10.0),
                            pw.Text(CurrencyUtils.formatCurrency("2000"),
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12.0,
                                  fontWeight: pw.FontWeight.bold,
                                ))
                          ]),
                        ],
                      )),
                  pw.Container(
                      padding: pw.EdgeInsets.all(6.0),
                      color: _black,
                      child: pw.Column(
                        children: [
                          pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
                            pw.Text("Cashed Out",
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12.0,
                                  fontWeight: pw.FontWeight.bold,
                                )),
                            pw.SizedBox(width: 10.0),
                            pw.Text(CurrencyUtils.formatCurrency("200"),
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 12.0,
                                  fontWeight: pw.FontWeight.bold,
                                ))
                          ]),
                        ],
                      ))
                ]),
            pw.SizedBox(height: 5.0),
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
              pw.Container(
                  margin: pw.EdgeInsets.only(bottom: 15.0),
                  padding: pw.EdgeInsets.all(6.0),
                  color: PdfColors.white,
                  child: pw.Column(
                    children: [
                      pw.Row(mainAxisSize: pw.MainAxisSize.min, children: [
                        pw.Text("Current Balance",
                            style: pw.TextStyle(
                              color: _colorAccent,
                              fontSize: 14.0,
                              fontWeight: pw.FontWeight.bold,
                            )),
                        pw.SizedBox(width: 10.0),
                        pw.Text(CurrencyUtils.formatCurrency("2000"),
                            style: pw.TextStyle(
                              color: _colorAccent,
                              fontSize: 14.0,
                              fontWeight: pw.FontWeight.bold,
                            ))
                      ]),
                    ],
                  )),
            ])
          ])
        ]);
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text("Powered by: Contributor",
              style: pw.TextStyle(fontSize: 18, color: _colorAccent)),
          pw.Text("Page ${context.pageNumber} of ${context.pagesCount}",
              style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.normal,
                  color: PdfColors.white))
        ]);
  }

  pw.Widget _buildExpenditureTable(pw.Context context) {
    return expenditure.length > 0
        ? pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.SizedBox(height: 10),
            pw.Text("Cash Out",
                style: pw.TextStyle(
                    color: _black,
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),
            pw.Text(
                "The Table Below shows how the collected cash was spend as per the budget",
                style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            _cashOutTable(context),
          ])
        : pw.Text("No Expenditure Data to show",
            style: pw.TextStyle(fontSize: 16));
  }

  generatePdf(context) async {
    final base =
        Font.ttf(await rootBundle.load("assets/fonts/Montserrat-Light.ttf"));
    final bold =
        Font.ttf(await rootBundle.load("assets/fonts/Montserrat-Black.ttf"));
    final italic = Font.ttf(
        await rootBundle.load("assets/fonts/Montserrat-BoldItalic.ttf"));
    _bgShape = await rootBundle.loadString('assets/images/bg.svg');

    final doc = pw.Document();
    doc.addPage(pw.MultiPage(
      pageTheme: _buildTheme(PdfPageFormat.a4, base, bold, italic),
      header: (context) =>
          context.pageNumber == 1 ? _buildHeader(context) : pw.Container(),
      footer: (context) => _buildFooter(context),
      build: (context) => [
        received.length > 0
            ? _contentTable(context)
            : pw.Text("No Contribution Found"),
        _buildExpenditureTable(context),
      ],
    ));

    final String dir = await _localPath;
    final path = '$dir/example.pdf';
    final File file = File(path);
    file.writeAsBytesSync(doc.save());
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PdfPreview(
              pfdPath: path,
            )));
  }

  pw.Widget _contentTable(pw.Context context) {
    const tableHeaders = ['#', 'Name', 'Date', 'Mode', 'Amount'];

    return pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          color: _colorAccent,
        ),
        headerHeight: 25,
        cellHeight: 40,
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.center,
          3: pw.Alignment.center,
          4: pw.Alignment.centerRight,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 12,
        ),
        rowDecoration: pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: _colorAccent,
              width: .5,
            ),
          ),
        ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: received
            .asMap()
            .entries
            .map((e) => [
                  e.key + 1,
                  e.value.senderName,
                  e.value.mode == "Cash"
                      ? CurrencyUtils.formatUtc(e.value.transactionDate)
                          .split(" ")[0]
                      : e.value.transactionDate.replaceAll("/", "-"),
                  e.value.mode,
                  CurrencyUtils.formatCurrency(
                      e.value.amount.replaceAll(",", ""))
                ])
            .toList());
  }

  pw.Widget _cashOutTable(pw.Context context) {
    const tableHeaders = ['#', 'Name', 'Date', 'Payment Mode', 'Amount'];

    return pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: pw.BoxDecoration(
          color: _black,
        ),
        headerHeight: 25,
        cellHeight: 40,
        cellAlignments: {
          0: pw.Alignment.centerLeft,
          1: pw.Alignment.centerLeft,
          2: pw.Alignment.center,
          3: pw.Alignment.center,
          4: pw.Alignment.centerRight,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.white,
          fontSize: 12,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: const pw.TextStyle(
          color: PdfColors.black,
          fontSize: 12,
        ),
        rowDecoration: pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: _colorAccent,
              width: .5,
            ),
          ),
        ),
        headers: List<String>.generate(
          tableHeaders.length,
          (col) => tableHeaders[col],
        ),
        data: expenditure
            .asMap()
            .entries
            .map((e) => [
                  e.key + 1,
                  e.value.receiverName,
                  e.value.mode == "Cash"
                      ? CurrencyUtils.formatUtc(e.value.transactionDate)
                          .split(" ")[0]
                      : e.value.transactionDate.replaceAll("/", "-"),
                  e.value.mode,
                  CurrencyUtils.formatCurrency(
                      e.value.amount.replaceAll(",", ""))
                ])
            .toList());
  }
}

String _formatDate(DateTime date) {
  final format = DateFormat.yMMMd('en_US');
  return format.format(date);
}
