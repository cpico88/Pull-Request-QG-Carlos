public with sharing class PMDTestController {
    public static void existingMethod() {
        // PMD Violation: EmptyIfStmt (Empty IF statement)
        if (true) {
            
        }
    }

    public static String newCleanMethod() {
        return 'This clean code was added by the current developer.';
    }
}