/**
 * @file ValidationException
 * @description Exception for validation errors (HTTP 400).
 * @layer Error
 * @patterns Exception
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class ValidationException extends ApiException {
    /**
     * @description Creates a new validation exception.
     * @param message Human-readable message.
     * @param details Optional error details.
     */
    public ValidationException(String message, Object details) {
        super(400, 'INVALID_PARAMETER', message, details);
    }
}
