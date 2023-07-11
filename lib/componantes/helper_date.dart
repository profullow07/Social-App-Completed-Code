import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: non_constant_identifier_names
String Formatdate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

// year
  String year = dateTime.year.toString();

// month
  String month = dateTime.month.toString();

// date
  String date = dateTime.day.toString();

// final date time

// ignore: non_constant_identifier_names
  String Formatdate = "$date/$month/$year";
  return Formatdate;
}
