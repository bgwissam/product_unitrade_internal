class QuoteData {
  String quoteId;
  List<Map<String, dynamic>> products;
  List<dynamic> itemQuoted;
  String userId;
  var dateTime;
  String clientId;
  String clientName;
  String paymentTerms;
  String status;
  String error;

  QuoteData({
    this.quoteId,
    this.products,
    this.itemQuoted,
    this.dateTime,
    this.userId,
    this.clientId,
    this.clientName,
    this.paymentTerms,
    this.status,
    this.error
  });
}

class Items {
  String name;
  dynamic value;

  Items(
    this.name,
    this.value,
  );

  @override
  String toString() {
    return '{${this.name}, ${this.value}}';
  }
}
