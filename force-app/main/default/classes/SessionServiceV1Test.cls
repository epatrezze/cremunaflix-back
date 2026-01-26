/**
 * @file SessionServiceV1Test
 * @description Unit tests for SessionServiceV1.
 * @layer Test
 * @patterns Test
 * @author IA
 * @date 2026-01-25
 */
@IsTest
private class SessionServiceV1Test {
    @TestSetup
    static void setupData() {
        Film__c film = new Film__c(
            Name = 'Test Film',
            Status__c = 'SCREENED',
            ExternalKey__c = 'film-001'
        );
        insert film;

        Session__c upcoming = new Session__c(
            Film__c = film.Id,
            StartDateTime__c = System.now().addDays(2),
            Status__c = 'UPCOMING'
        );
        Session__c past = new Session__c(
            Film__c = film.Id,
            StartDateTime__c = System.now().addDays(-2),
            Status__c = 'PAST'
        );
        insert new List<Session__c>{ upcoming, past };
    }

    /**
     * @description Validates upcoming sessions response.
     * @param none
     * @return void
     * @throws ApiException When validation fails.
     */
    @IsTest
    static void testGetUpcoming() {
        Test.startTest();
        PaginatedResponseDTO response = new SessionServiceV1().getUpcoming(1, 10);
        Test.stopTest();

        System.assertEquals(1, response.total);
        System.assertEquals(1, response.items.size());
    }

    /**
     * @description Validates past sessions response.
     * @param none
     * @return void
     * @throws ApiException When validation fails.
     */
    @IsTest
    static void testGetPast() {
        Datetime fromDt = System.now().addDays(-10);
        Datetime toDt = System.now().addDays(-1);

        Test.startTest();
        PaginatedResponseDTO response = new SessionServiceV1().getPast(fromDt, toDt, 1, 10);
        Test.stopTest();

        System.assertEquals(1, response.total);
        System.assertEquals(1, response.items.size());
    }
}
