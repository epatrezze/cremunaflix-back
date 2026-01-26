/**
 * @file RequiredFieldsValidator
 * @description Validates mandatory fields for request creation.
 * @layer Validation
 * @patterns Chain of Responsibility
 * @author IA
 * @date 2026-01-25
 */
public with sharing class RequiredFieldsValidator extends RequestValidator {
    /**
     * @description Creates a RequiredFieldsValidator.
     * @param none
     * @return RequiredFieldsValidator instance.
     * @throws ApiException When instantiation fails.
     */
    public RequiredFieldsValidator() {
    }

    /**
     * @description Validates required fields and dependencies.
     * @param input CreateRequestDTO input.
     * @return void
     * @throws ApiException When validation fails.
     */
    protected override void doValidate(CreateRequestDTO input) {
        if (input == null) {
            throw new ApiException(400, 'VALIDATION_ERROR', 'Request body is required.', null);
        }
        if (String.isBlank(input.requesterName)) {
            throw new ApiException(400, 'VALIDATION_ERROR', 'Requester name is required.', new Map<String, Object>{
                'field' => 'requesterName'
            });
        }
        if (String.isBlank(input.filmId) && String.isBlank(input.requestedTitle)) {
            throw new ApiException(400, 'VALIDATION_ERROR', 'Provide filmId or requestedTitle.', new Map<String, Object>{
                'fields' => new List<String>{ 'filmId', 'requestedTitle' }
            });
        }
    }
}
