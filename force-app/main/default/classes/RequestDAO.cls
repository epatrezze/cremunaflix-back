/**
 * @file RequestDAO
 * @description Centralized SOQL and DML access for Request__c.
 * @layer DAO
 * @patterns DAO
 * @author IA
 * @date 2026-01-25
 */
public with sharing class RequestDAO {
    private static final String BASE_FIELDS =
        'Id, Status__c, RequesterName__c, RequesterEmail__c, Film__c, RequestedTitle__c, ' +
        'RequestedYear__c, Notes__c, CreatedDate, ' +
        'Film__r.Id, Film__r.ExternalKey__c';

    /**
     * @description Fetches a list of requests with sorting and pagination.
     * @param sortParam Sort string.
     * @param offsetValue Offset for pagination.
     * @param limitSize Max number of records.
     * @return List of Request__c records.
     * @throws ApiException When sort is invalid or query fails.
     */
    public static List<Request__c> fetchList(String sortParam, Integer offsetValue, Integer limitSize) {
        String orderByClause = buildOrderBy(sortParam);
        List<Request__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' ' +
            'FROM Request__c ' +
            'ORDER BY ' + orderByClause + ' ' +
            'LIMIT :limitSize OFFSET :offsetValue'
        );
        return sanitizeList(records);
    }

    /**
     * @description Counts all Request__c records.
     * @param none
     * @return Total count.
     * @throws ApiException When query fails.
     */
    public static Integer countTotal() {
        return Database.countQuery('SELECT COUNT() FROM Request__c');
    }

    /**
     * @description Inserts a request record with CRUD/FLS enforcement.
     * @param record Request__c record to insert.
     * @return Inserted record Id.
     * @throws ApiException When insert fails or lacks permissions.
     */
    public static Id insertRequest(Request__c record) {
        List<SObject> creatable = Security.stripInaccessible(
            AccessType.CREATABLE,
            new List<SObject>{ record }
        ).getRecords();
        if (creatable.isEmpty()) {
            throw new ApiException(403, 'FORBIDDEN', 'Missing create permission.', null);
        }

        Database.insert(creatable[0], false);
        return ((Request__c) creatable[0]).Id;
    }

    /**
     * @description Fetches a request by Id.
     * @param requestId Request record Id.
     * @return Request__c record or null.
     * @throws ApiException When query fails.
     */
    public static Request__c fetchById(Id requestId) {
        if (requestId == null) {
            return null;
        }
        List<Request__c> records = Database.query(
            'SELECT ' + BASE_FIELDS + ' FROM Request__c WHERE Id = :requestId LIMIT 1'
        );
        return sanitizeSingle(records);
    }

    private static String buildOrderBy(String sortParam) {
        if (String.isBlank(sortParam) || sortParam == 'createdAt_desc') {
            return 'CreatedDate DESC';
        }
        if (sortParam == 'createdAt_asc') {
            return 'CreatedDate ASC';
        }
        if (sortParam == 'status_asc') {
            return 'Status__c ASC';
        }
        if (sortParam == 'status_desc') {
            return 'Status__c DESC';
        }

        throw new ApiException(400, 'INVALID_PARAMETER', 'Invalid parameter: sort.', new Map<String, Object>{
            'param' => 'sort',
            'value' => sortParam,
            'allowed' => new List<String>{ 'createdAt_desc', 'createdAt_asc', 'status_asc', 'status_desc' }
        });
    }

    private static Request__c sanitizeSingle(List<Request__c> records) {
        if (records == null || records.isEmpty()) {
            return null;
        }
        List<Request__c> sanitized = (List<Request__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
        return sanitized.isEmpty() ? null : sanitized[0];
    }

    private static List<Request__c> sanitizeList(List<Request__c> records) {
        if (records == null) {
            return new List<Request__c>();
        }
        return (List<Request__c>) Security.stripInaccessible(AccessType.READABLE, records).getRecords();
    }
}
