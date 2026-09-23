import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import '../services/stripe_service.dart';

class PaymentController extends GetxController {
  final StripeService _stripeService = StripeService();

  final isProcessing = false.obs;
  final errorMessage = ''.obs;

  Future<bool> payWithStripe({
    required double amount,
}) async {
    try {
      isProcessing.value = true;
      errorMessage.value = '';

      // 1) Stripe se PaymentIntent mangwao
      final clientSecret = await _stripeService.createPaymentIntent(
          amount: amount,
          currency: 'usd',
      );

      // 2) Payment Sheet (Stripe ka ready-made UI) setup karo
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: clientSecret,
            merchantDisplayName: 'ShopFlow',
          ),
      );

      // 3) User ko Payment Sheet dikhao (card details yahan bharega)
      await Stripe.instance.presentPaymentSheet();
      // Agar yahan tak error nahi aaya, matlab payment successful
      return true;
    } on StripeException catch (e) {
      errorMessage.value = e.error.localizedMessage ?? 'Payment failed';
      return false;
    } catch (e) {
      errorMessage.value = e.toString();
      return false;
    } finally {
      isProcessing.value = false;
    }
  }
}