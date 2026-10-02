public class AccountProcessorService {
    
    // Violation 1: PMD ApexCRUDViolation / ApexDoc
    // Missing 'with sharing' or 'without sharing' on class definition
    // Missing access modifier on method (defaults to private, but PMD flags missing public/global if intended)
    
    public void processAccounts(List<Id> accountIds) {
        
        // Violation 2: PMD UnusedLocalVariable
        String unusedProcessingFlag = 'INIT_PROCESS';
        
        for (Id accId : accountIds) {
            
            // Violation 3: PMD OperationWithInLoop (SOQL query inside a loop)
            Account acc = [SELECT Id, Name, AnnualRevenue FROM Account WHERE Id = :accId];
            
            if (acc.AnnualRevenue == null) {
                acc.AnnualRevenue = 0;
            }
            
            // Violation 4: PMD OperationWithInLoop (DML operation inside a loop)
            update acc;
        }
    }
}