/**
 * @file RequestControllerV1Test
 * @description Controller tests for request endpoints.
 * @layer Test
 * @patterns Test
 * @author IA
 * @date 2026-01-25
 */
@IsTest
private class RequestControllerV1Test {
    @TestSetup
    static void setupData() {
        Film__c film = new Film__c(
            Name = 'Controller Film',
            Status__c = 'SCREENED',
            ExternalKey__c = 'film-controller-1'
        );
        insert film;

        Request__c req1 = new Request__c(
            RequesterName__c = 'Ana',
            Status__c = 'OPEN',
            RequestedTitle__c = 'Title One'
        );
        Request__c req2 = new Request__c(
            RequesterName__c = 'Beto',
            Status__c = 'OPEN',
            RequestedTitle__c = 'Title Two'
        );
        insert new List<Request__c>{ req1, req2 };
    }

    /**
     * @description Validates list endpoint response.
     * @param none
     * @return void
     * @throws ApiException When request fails.
     */
    @IsTest
    static void testListEndpoint() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/requests';
        req.resourcePath = '/api/v1/requests';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        RequestControllerV1.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(
            RestContext.response.responseBody.toString()
        );
        System.assertEquals(2, ((List<Object>) payload.get('items')).size());
    }

    /**
     * @description Validates create endpoint response.
     * @param none
     * @return void
     * @throws ApiException When request fails.
     */
    @IsTest
    static void testCreateEndpoint() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestUri = '/services/apexrest/api/v1/requests';
        req.resourcePath = '/api/v1/requests';
        req.requestBody = Blob.valueOf('{"requesterName":"Maria","requestedTitle":"New Title"}');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        RequestControllerV1.doPost();
        Test.stopTest();

        System.assertEquals(201, RestContext.response.statusCode);
    }

    /**
     * @description Validates invalid sort handling.
     * @param none
     * @return void
     * @throws ApiException When request fails.
     */
    @IsTest
    static void testInvalidSort() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/requests';
        req.resourcePath = '/api/v1/requests';
        req.addParameter('sort', 'bad');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        RequestControllerV1.doGet();
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode);
    }
}
