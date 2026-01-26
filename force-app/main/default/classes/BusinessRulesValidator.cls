/**
 * @file BusinessRulesValidator
 * @description Validates business rules for request creation.
 * @layer Validation
 * @patterns Chain of Responsibility
 * @author IA
 * @date 2026-01-25
 */
public with sharing class BusinessRulesValidator extends RequestValidator {
    private static final Integer MIN_YEAR = 1888;

    /**
     * @description Creates a BusinessRulesValidator.
     * @param none
     * @return BusinessRulesValidator instance.
     * @throws ApiException When instantiation fails.
     */
    public BusinessRulesValidator() {
    }

    /**
     * @description Validates year range and film existence.
     * @param input CreateRequestDTO input.
     * @return void
     * @throws ApiException When validation fails.
     */
    protected override void doValidate(CreateRequestDTO input) {
        if (input == null) {
            return;
        }

        if (input.requestedYear != null) {
            Integer maxYear = Date.today().year() + 1;
            if (input.requestedYear < MIN_YEAR || input.requestedYear > maxYear) {
                throw new ApiException(400, 'VALIDATION_ERROR', 'Requested year is out of range.', new Map<String, Object>{
                    'field' => 'requestedYear',
                    'min' => MIN_YEAR,
                    'max' => maxYear
                });
            }
        }

        if (!String.isBlank(input.filmId)) {
            Film__c filmRecord = resolveFilm(input.filmId);
            if (filmRecord == null) {
                throw new ApiException(400, 'VALIDATION_ERROR', 'Film not found.', new Map<String, Object>{
                    'field' => 'filmId',
                    'value' => input.filmId
                });
            }
        }
    }

    private static Film__c resolveFilm(String filmToken) {
        String trimmed = filmToken != null ? filmToken.trim() : null;
        if (String.isBlank(trimmed)) {
            return null;
        }
        if (isValidId(trimmed)) {
            return FilmDAO.fetchById((Id) trimmed);
        }
        return FilmDAO.fetchByExternalKey(trimmed);
    }

    private static Boolean isValidId(String value) {
        try {
            Id.valueOf(value);
            return true;
        } catch (Exception ex) {
            return false;
        }
    }
}
