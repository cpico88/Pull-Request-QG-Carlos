public class LegacyAccountService {
    
    public static void processLegacyAccounts() {
        // Violation 1 & 2 (Pre-existing)
        Id defaultAccountId = '001000000000000AAA';
        
        // Violation 3 (NEWLY ADDED)
        String newUnusedFlag = 'TEST_DELTA';
        
        System.debug('Processing account: ' + defaultAccountId);
    }
}