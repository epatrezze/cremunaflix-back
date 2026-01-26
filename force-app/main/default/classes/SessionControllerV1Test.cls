/**
 * @file SessionControllerV1Test
 * @description Controller tests for session endpoints.
 * @layer Test
 * @patterns Test
 * @author IA
 * @date 2026-01-25
 */
@IsTest
private class SessionControllerV1Test {
    @TestSetup
    static void setupData() {
        Film__c film = new Film__c(
            Name = 'Session Film',
            Status__c = 'SCREENED',
            ExternalKey__c = 'film-session-1'
        );
        insert film;

        Session__c upcoming = new Session__c(
            Film__c = film.Id,
            StartDateTime__c = System.now().addDays(3),
            Status__c = 'UPCOMING'
        );
        Session__c past = new Session__c(
            Film__c = film.Id,
            StartDateTime__c = System.now().addDays(-3),
            Status__c = 'PAST'
        );
        insert new List<Session__c>{ upcoming, past };
    }

    /**
     * @description Validates upcoming sessions endpoint response.
     * @param none
     * @return void
     * @throws ApiException When request fails.
     */
    @IsTest
    static void testUpcomingEndpoint() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/sessions/upcoming';
        req.resourcePath = '/api/v1/sessions/upcoming';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        SessionControllerV1.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(
            RestContext.response.responseBody.toString()
        );
        System.assertEquals(1, ((List<Object>) payload.get('items')).size());
    }

    /**
     * @description Validates past sessions endpoint response.
     * @param none
     * @return void
     * @throws ApiException When request fails.
     */
    @IsTest
    static void testPastEndpoint() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/sessions/past';
        req.resourcePath = '/api/v1/sessions/past';
        req.addParameter('from', DateTimeUtil.formatIso(System.now().addDays(-10)));
        req.addParameter('to', DateTimeUtil.formatIso(System.now().addDays(-1)));
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        SessionControllerV1.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }

    /**
     * @description Validates error when from/to is missing.
     * @param none
     * @return void
     * @throws ApiException When request fails.
     */
    @IsTest
    static void testPastMissingParams() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/sessions/past';
        req.resourcePath = '/api/v1/sessions/past';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        SessionControllerV1.doGet();
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode);
    }
}
