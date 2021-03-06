class Constants {
  static final String receivedRegex =
      r'received\s\w+[a-zA-Z]([0-9,.]+)\b\s\w+\b([A-Z\s]+)\b(\d{9,10})\s\w+\s(\d{1,2}\/\d{1,2}\/\d{1,2})';
  static final String sentRegex =
      r'\w+[a-zA-z](\d[0-9,.]+)\b\b\ssent\s\w+\s([A-Z\s]+)\b(\b\d{10})\b\s\w+\s([\d{1,2}\/]+)';
  static final String paidRegex =
      r'\b[a-zA-Z]+([0-9,.]+)\spaid\s\w+\s([a-zA-Z0-9, ]+)\.\s\w+\s([\d{1,2}\/]+)';
  static final String apiUrl = "http://192.168.100.118:5000/";
}
