/**
 * @file RequestValidator
 * @description Base validator for request creation using chain of responsibility.
 * @layer Validation
 * @patterns Chain of Responsibility
 * @author IA
 * @date 2026-01-25
 */
public abstract with sharing class RequestValidator {
    private RequestValidator nextValidator;

    /**
     * @description Links the next validator in the chain.
     * @param next Next validator.
     * @return RequestValidator The next validator for chaining.
     * @throws ApiException When chaining fails.
     */
    public RequestValidator setNext(RequestValidator next) {
        this.nextValidator = next;
        return next;
    }

    /**
     * @description Validates input and delegates to the next validator.
     * @param input CreateRequestDTO input.
     * @return void
     * @throws ApiException When validation fails.
     */
    public void validate(CreateRequestDTO input) {
        doValidate(input);
        if (nextValidator != null) {
            nextValidator.validate(input);
        }
    }

    protected abstract void doValidate(CreateRequestDTO input);
}
