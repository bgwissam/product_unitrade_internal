class QuoteData {
  String quoteId;
  List<Map<String, dynamic>> products;
  String userId;
  String clientId;
  String clientName;
  String paymentTerms;
  String status;

  QuoteData({
    this.quoteId,
    this.products,
    this.userId,
    this.clientId,
    this.clientName,
    this.paymentTerms,
    this.status,
  });
}
