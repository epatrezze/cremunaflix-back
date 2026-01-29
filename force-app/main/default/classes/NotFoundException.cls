/**
 * @file NotFoundException
 * @description Exception for not found errors (HTTP 404).
 * @layer Error
 * @patterns Exception
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class NotFoundException extends ApiException {
    /**
     * @description Creates a new not found exception.
     * @param message Human-readable message.
     * @param details Optional error details.
     */
    public NotFoundException(String message, Object details) {
        super(404, 'NOT_FOUND', message, details);
    }
}
