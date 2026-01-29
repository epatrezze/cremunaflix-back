/**
 * @file ApiV1ControllerTest
 * @description Tests for ApiV1Controller endpoints.
 * @layer Test
 * @patterns Test
 * @author epatrezze
 * @date 2026-01-27
 */
@IsTest
private class ApiV1ControllerTest {
    @TestSetup
    static void setupData() {
        Contact contact = TestDataFactory.createContact('tester@example.com');
        Movie__c movie1 = TestDataFactory.createMovie('Movie A', '1001', 'EXHIBITED');
        Movie__c movie2 = TestDataFactory.createMovie('Movie B', '1002', 'UPCOMING');
        Genre__c genre = TestDataFactory.createGenre(28, 'Action');
        TestDataFactory.createMovieGenre(movie1, genre);
        TestDataFactory.createSession(movie1, System.now().addDays(-2), 'DONE');
        TestDataFactory.createSession(movie2, System.now().addDays(2), 'UPCOMING');
        TestDataFactory.createRequest(contact, movie1, 'Movie A', '1001');
        TestDataFactory.createRequest(contact, null, 'Movie X', '9999');
    }

    @IsTest
    static void testGetHome() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/home';
        req.resourcePath = '/api/v1/home';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }

    @IsTest
    static void testListMovies() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/movies';
        req.resourcePath = '/api/v1/movies';
        req.addParameter('page', '1');
        req.addParameter('pageSize', '1');
        req.addParameter('status', 'EXHIBITED');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
        Map<String, Object> payload = (Map<String, Object>) JSON.deserializeUntyped(
            RestContext.response.responseBody.toString()
        );
        System.assertEquals(1, ((List<Object>) payload.get('items')).size());
    }

    @IsTest
    static void testListMoviesInvalidPage() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/movies';
        req.resourcePath = '/api/v1/movies';
        req.addParameter('page', '0');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doGet();
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode);
    }

    @IsTest
    static void testListSessionsUpcoming() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/sessions';
        req.resourcePath = '/api/v1/sessions';
        req.addParameter('scope', 'upcoming');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }

    @IsTest
    static void testListSessionsLegacyUpcoming() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/sessions/upcoming';
        req.resourcePath = '/api/v1/sessions/upcoming';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }

    @IsTest
    static void testListSessionsLegacyPast() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/sessions/past';
        req.resourcePath = '/api/v1/sessions/past';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }

    @IsTest
    static void testListRequests() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/requests';
        req.resourcePath = '/api/v1/requests';
        req.addParameter('sort', 'requestedAt_desc');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doGet();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
    }

    @IsTest
    static void testCreateRequest() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];

        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestUri = '/services/apexrest/api/v1/requests';
        req.resourcePath = '/api/v1/requests';
        req.requestBody = Blob.valueOf(
            '{"tmdbId":"2001","title":"Movie C","posterUrl":"https://example.com/poster.jpg","requestedById":"' +
            contact.Id +
            '"}'
        );
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doPost();
        Test.stopTest();

        System.assertEquals(201, RestContext.response.statusCode);
    }

    @IsTest
    static void testCreateRequestMissingTitle() {
        Contact contact = [SELECT Id FROM Contact LIMIT 1];

        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestUri = '/services/apexrest/api/v1/requests';
        req.resourcePath = '/api/v1/requests';
        req.requestBody = Blob.valueOf('{"requestedById":"' + contact.Id + '"}');
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doPost();
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode);
    }

    @IsTest
    static void testNotFound() {
        RestRequest req = new RestRequest();
        req.httpMethod = 'GET';
        req.requestUri = '/services/apexrest/api/v1/unknown';
        req.resourcePath = '/api/v1/unknown';
        RestContext.request = req;
        RestContext.response = new RestResponse();

        Test.startTest();
        ApiV1Controller.doGet();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode);
    }
}
