public with sharing class ContactOpportunityHandler {
    
    // Violation 1: PMD VariableNamingConventions
    // Variable name 'x' is too short; 'TMP_OPP_LIST' violates camelCase standard for non-constants
    private Static List<Opportunity> TMP_OPP_LIST;
    
    public static void validateContactData(List<Contact> contacts) {
        
        for (Contact c : contacts) {
            
            // Violation 2: PMD AvoidDeeplyNestedIfStmts (Excessive nesting)
            if (c.Email != null) {
                if (c.Phone != null) {
                    if (c.Title != null) {
                        if (c.Department != null) {
                            System.debug('Contact is fully populated');
                        }
                    }
                }
            }
            
            // Violation 3: PMD EmptyCatchBlock
            try {
                Decimal discount = 100 / c.ReportsToId.hashCode();
            } catch (Exception e) {
                // Empty catch block explicitly ignored
            }
        }
    }
}