/**
 * @file RequestServiceV1Test
 * @description Unit tests for RequestServiceV1.
 * @layer Test
 * @patterns Test
 * @author IA
 * @date 2026-01-25
 */
@IsTest
private class RequestServiceV1Test {
    @TestSetup
    static void setupData() {
        Film__c film = new Film__c(
            Name = 'Request Film',
            Status__c = 'SCREENED',
            ExternalKey__c = 'film-req-1'
        );
        insert film;

        Request__c req1 = new Request__c(
            RequesterName__c = 'Alice',
            Status__c = 'OPEN',
            RequestedTitle__c = 'Some Film'
        );
        Request__c req2 = new Request__c(
            RequesterName__c = 'Bob',
            Status__c = 'OPEN',
            RequestedTitle__c = 'Another Film'
        );
        insert new List<Request__c>{ req1, req2 };
    }

    /**
     * @description Validates successful request creation.
     * @param none
     * @return void
     * @throws ApiException When validation fails.
     */
    @IsTest
    static void testCreateSuccess() {
        CreateRequestDTO input = new CreateRequestDTO();
        input.requesterName = 'Carol';
        input.filmId = 'film-req-1';

        Test.startTest();
        RequestDTO created = new RequestServiceV1().create(input);
        Test.stopTest();

        System.assertEquals('OPEN', created.status);
        System.assertEquals('Carol', created.requesterName);
    }

    /**
     * @description Validates create error when required fields are missing.
     * @param none
     * @return void
     * @throws ApiException When validation fails.
     */
    @IsTest
    static void testCreateMissingFilmOrTitle() {
        CreateRequestDTO input = new CreateRequestDTO();
        input.requesterName = 'Dave';

        Test.startTest();
        try {
            new RequestServiceV1().create(input);
            System.assert(false, 'Expected ApiException.');
        } catch (ApiException ex) {
            System.assertEquals('VALIDATION_ERROR', ex.code);
        }
        Test.stopTest();
    }

    /**
     * @description Validates pagination in list response.
     * @param none
     * @return void
     * @throws ApiException When validation fails.
     */
    @IsTest
    static void testListPagination() {
        Test.startTest();
        PaginatedResponseDTO response = new RequestServiceV1().listRequests('createdAt_desc', 1, 1);
        Test.stopTest();

        System.assertEquals(2, response.total);
        System.assertEquals(1, response.items.size());
    }
}
