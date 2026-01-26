/**
 * @file ApiException
 * @description Custom exception carrying HTTP status and API error details.
 * @layer Error
 * @patterns Exception
 * @author IA
 * @date 2026-01-25
 */
public with sharing class ApiException extends Exception {
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
     * @return ApiException instance.
     * @throws ApiException When instantiated for error flow.
     */
    public ApiException(Integer httpStatus, String code, String message, Object details) {
        this.httpStatus = httpStatus;
        this.code = code;
        this.details = details;
        this.message = message;
    }
}
