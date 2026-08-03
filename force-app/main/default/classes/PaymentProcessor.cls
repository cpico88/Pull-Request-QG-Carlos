public with sharing class PaymentProcessor {
    public static Boolean processPayment(Decimal amount) {
        String endpoint = 'https://api.v2.paymentservice.com/v2/charge';
        
        // Defined variable and added missing semicolon
        Decimal taxRate = 0.09;
        Decimal totalCharge = amount + (amount * taxRate);
        
        return true;
    }
}