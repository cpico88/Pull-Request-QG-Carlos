/**
 * @description Dummy Apex test class demonstrating standard test patterns
 *              for Case-related logic.
 * @author      Copado Build Agent
 * @date        2026-09-22
 */
@IsTest
private class DummyCaseServiceTest {

    // ─── Test Data Setup ────────────────────────────────────────────────────

    @TestSetup
    static void makeData() {
        Account acc = new Account(Name = 'Case Parent Account');
        insert acc;

        Contact con = new Contact(
            FirstName = 'Case',
            LastName  = 'Contact',
            AccountId = acc.Id
        );
        insert con;

        List<Case> cases = new List<Case>();
        for (Integer i = 0; i < 5; i++) {
            cases.add(new Case(
                Subject   = 'Test Case ' + i,
                Status    = 'New',
                Origin    = 'Web',
                Priority  = 'Medium',
                AccountId = acc.Id,
                ContactId = con.Id
            ));
        }
        insert cases;
    }

    // ─── Positive Tests ─────────────────────────────────────────────────────

    @IsTest
    static void testCaseInsert_success() {
        // Arrange
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Case c = new Case(
            Subject   = 'New Dummy Case',
            Status    = 'New',
            Origin    = 'Phone',
            Priority  = 'High',
            AccountId = acc.Id
        );

        // Act
        Test.startTest();
        insert c;
        Test.stopTest();

        // Assert
        Case inserted = [SELECT Subject, Status, Priority FROM Case WHERE Id = :c.Id];
        System.assertEquals('New Dummy Case', inserted.Subject,  'Case subject should match.');
        System.assertEquals('New',            inserted.Status,   'Case status should match.');
        System.assertEquals('High',           inserted.Priority, 'Case priority should match.');
    }

    @IsTest
    static void testCaseQuery_returnsExpectedCount() {
        // Act
        Test.startTest();
        List<Case> cases = [SELECT Id FROM Case WHERE Status = 'New'];
        Test.stopTest();

        // Assert
        System.assertEquals(5, cases.size(), 'Should return exactly 5 New cases.');
    }

    @IsTest
    static void testCaseUpdate_status_success() {
        // Arrange
        Case c = [SELECT Id, Status FROM Case LIMIT 1];
        c.Status = 'Working';

        // Act
        Test.startTest();
        update c;
        Test.stopTest();

        // Assert
        Case updated = [SELECT Status FROM Case WHERE Id = :c.Id];
        System.assertEquals('Working', updated.Status, 'Case status should be updated to Working.');
    }

    @IsTest
    static void testCaseClose_success() {
        // Arrange
        Case c = [SELECT Id, Status FROM Case LIMIT 1];
        c.Status = 'Closed';

        // Act
        Test.startTest();
        update c;
        Test.stopTest();

        // Assert
        Case closed = [SELECT Status, IsClosed FROM Case WHERE Id = :c.Id];
        System.assertEquals('Closed', closed.Status,   'Case status should be Closed.');
        System.assertEquals(true,     closed.IsClosed, 'IsClosed flag should be true.');
    }

    // ─── Negative Tests ──────────────────────────────────────────────────────

    @IsTest
    static void testCaseDelete_success() {
        // Arrange
        Case c = [SELECT Id FROM Case LIMIT 1];

        // Act
        Test.startTest();
        delete c;
        Test.stopTest();

        // Assert
        List<Case> remaining = [SELECT Id FROM Case WHERE Id = :c.Id ALL ROWS];
        System.assertEquals(1, remaining.size(), 'Deleted case should still exist in the recycle bin.');
        System.assertEquals(true, remaining[0].isDeleted, 'Case should be marked as deleted.');
    }

    // ─── Bulk Tests ──────────────────────────────────────────────────────────

    @IsTest
    static void testCaseInsert_bulk_success() {
        // Arrange
        Account acc = [SELECT Id FROM Account LIMIT 1];
        List<Case> bulkCases = new List<Case>();
        for (Integer i = 0; i < 200; i++) {
            bulkCases.add(new Case(
                Subject   = 'Bulk Case ' + i,
                Status    = 'New',
                Origin    = 'Web',
                AccountId = acc.Id
            ));
        }

        // Act
        Test.startTest();
        insert bulkCases;
        Test.stopTest();

        // Assert
        Integer count = [SELECT COUNT() FROM Case WHERE Subject LIKE 'Bulk Case%'];
        System.assertEquals(200, count, 'All 200 bulk cases should be inserted.');
    }
}