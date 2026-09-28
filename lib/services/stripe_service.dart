import 'dart:convert';
import 'package:http/http.dart' as http;

class StripeService {
  static const String _secretKey =
  String.fromEnvironment('STRIPE_SECRET_KEY');

  Future<String> createPaymentIntent({
    required double amount,
    required String currency,
}) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': _toStripeAmount(amount),
          'currency': currency,
          'automatic_payment_methods[enabled]': 'true',
        },
      );

      if(response.statusCode != 200) {
        throw Exception('Stripe error: ${response.body}');
      }

      final data = jsonDecode(response.body);
      return data['client_secret'] as String;
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }

  String _toStripeAmount(double amount) {
    return (amount * 100).round().toString();
  }
}