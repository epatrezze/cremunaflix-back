/**
 * @file PermissionValidator
 * @description Placeholder validator for permission checks.
 * @layer Validation
 * @patterns Chain of Responsibility
 * @author IA
 * @date 2026-01-25
 */
public with sharing class PermissionValidator extends RequestValidator {
    /**
     * @description Creates a PermissionValidator.
     * @param none
     * @return PermissionValidator instance.
     * @throws ApiException When instantiation fails.
     */
    public PermissionValidator() {
    }

    /**
     * @description Validates object-level permissions.
     * @param input CreateRequestDTO input.
     * @return void
     * @throws ApiException When user lacks permissions.
     */
    protected override void doValidate(CreateRequestDTO input) {
        if (!Schema.sObjectType.Request__c.isCreateable()) {
            throw new ApiException(403, 'FORBIDDEN', 'Missing create permission.', null);
        }
    }
}
