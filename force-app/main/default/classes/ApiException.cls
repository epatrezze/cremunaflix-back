/**
 * @file ApiException
 * @description Base exception carrying HTTP status and error details for API v1.
 * @layer Error
 * @patterns Exception
 * @author epatrezze
 * @date 2026-01-27
 */
public virtual without sharing class ApiException extends Exception {
    public Integer httpStatus;
    public String code;
    public Object details;
    public String message;

    /**
     * @description Creates a new API exception.
     * @param httpStatus HTTP status code to return.
     * @param code Error code identifier.
     * @param message Human-readable message.
     * @param details Optional error details.
     */
    public ApiException(Integer httpStatus, String code, String message, Object details) {
        this.httpStatus = httpStatus;
        this.code = code;
        this.details = details;
        this.message = message;
    }
}
