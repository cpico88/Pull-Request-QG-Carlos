/**
 * @description Dummy Apex test class demonstrating standard test patterns
 *              for Opportunity-related logic.
 * @author      Copado Build Agent
 * @date        2026-09-22
 */
@IsTest
private class DummyOpportunityServiceTest {

    // ─── Test Data Setup ────────────────────────────────────────────────────

    @TestSetup
    static void makeData() {
        Account acc = new Account(Name = 'Opportunity Parent Account');
        insert acc;

        List<Opportunity> opps = new List<Opportunity>();
        for (Integer i = 0; i < 5; i++) {
            opps.add(new Opportunity(
                Name      = 'Test Opportunity ' + i,
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30),
                Amount    = 1000 * (i + 1)
            ));
        }
        insert opps;
    }

    // ─── Positive Tests ─────────────────────────────────────────────────────

    @IsTest
    static void testOpportunityInsert_success() {
        // Arrange
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp = new Opportunity(
            Name      = 'New Dummy Opportunity',
            AccountId = acc.Id,
            StageName = 'Qualification',
            CloseDate = Date.today().addDays(60),
            Amount    = 50000
        );

        // Act
        Test.startTest();
        insert opp;
        Test.stopTest();

        // Assert
        Opportunity inserted = [SELECT Name, StageName, Amount FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('New Dummy Opportunity', inserted.Name,      'Opportunity name should match.');
        System.assertEquals('Qualification',         inserted.StageName, 'Stage should match.');
        System.assertEquals(50000,                   inserted.Amount,    'Amount should match.');
    }

    @IsTest
    static void testOpportunityQuery_returnsExpectedCount() {
        // Act
        Test.startTest();
        List<Opportunity> opps = [SELECT Id FROM Opportunity WHERE StageName = 'Prospecting'];
        Test.stopTest();

        // Assert
        System.assertEquals(5, opps.size(), 'Should return exactly 5 Prospecting opportunities.');
    }

    @IsTest
    static void testOpportunityUpdate_stage_success() {
        // Arrange
        Opportunity opp = [SELECT Id, StageName FROM Opportunity LIMIT 1];
        opp.StageName = 'Closed Won';

        // Act
        Test.startTest();
        update opp;
        Test.stopTest();

        // Assert
        Opportunity updated = [SELECT StageName FROM Opportunity WHERE Id = :opp.Id];
        System.assertEquals('Closed Won', updated.StageName, 'Stage should be updated to Closed Won.');
    }

    @IsTest
    static void testOpportunityAmount_aggregation() {
        // Act
        Test.startTest();
        AggregateResult result = [
            SELECT SUM(Amount) total
            FROM Opportunity
            WHERE StageName = 'Prospecting'
        ];
        Test.stopTest();

        // Assert
        Decimal totalAmount = (Decimal) result.get('total');
        System.assertEquals(15000, totalAmount, 'Total amount should be 1000+2000+3000+4000+5000 = 15000.');
    }

    // ─── Negative Tests ──────────────────────────────────────────────────────

    @IsTest
    static void testOpportunityInsert_missingCloseDate_throwsException() {
        // Arrange
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp = new Opportunity(
            Name      = 'Missing CloseDate',
            AccountId = acc.Id,
            StageName = 'Prospecting'
            // CloseDate intentionally omitted
        );

        // Act & Assert
        Test.startTest();
        try {
            insert opp;
            System.assert(false, 'Expected a DmlException to be thrown.');
        } catch (DmlException e) {
            System.assert(
                e.getMessage().contains('Required fields are missing'),
                'Exception message should indicate missing required fields.'
            );
        }
        Test.stopTest();
    }

    // ─── Bulk Tests ──────────────────────────────────────────────────────────

    @IsTest
    static void testOpportunityInsert_bulk_success() {
        // Arrange
        Account acc = [SELECT Id FROM Account LIMIT 1];
        List<Opportunity> bulkOpps = new List<Opportunity>();
        for (Integer i = 0; i < 200; i++) {
            bulkOpps.add(new Opportunity(
                Name      = 'Bulk Opportunity ' + i,
                AccountId = acc.Id,
                StageName = 'Prospecting',
                CloseDate = Date.today().addDays(30)
            ));
        }

        // Act
        Test.startTest();
        insert bulkOpps;
        Test.stopTest();

        // Assert
        Integer count = [SELECT COUNT() FROM Opportunity WHERE Name LIKE 'Bulk Opportunity%'];
        System.assertEquals(200, count, 'All 200 bulk opportunities should be inserted.');
    }
}