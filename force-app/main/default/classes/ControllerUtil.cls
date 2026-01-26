/**
 * @file ControllerUtil
 * @description Shared helpers for REST controllers.
 * @layer Controller
 * @patterns Utility
 * @author IA
 * @date 2026-01-25
 */
public with sharing class ControllerUtil {
    /**
     * @description Writes a JSON response with status code.
     * @param payload Object to serialize.
     * @param statusCode HTTP status code.
     * @return void
     * @throws ApiException When response cannot be written.
     */
    public static void sendJson(Object payload, Integer statusCode) {
        RestResponse response = RestContext.response;
        response.statusCode = statusCode;
        response.addHeader('Content-Type', 'application/json');
        response.responseBody = Blob.valueOf(JSON.serialize(payload));
    }

    /**
     * @description Writes an ApiErrorDTO response from ApiException.
     * @param ex ApiException instance.
     * @return void
     * @throws ApiException When response cannot be written.
     */
    public static void sendError(ApiException ex) {
        ApiErrorDTO errorPayload = new ApiErrorDTO();
        errorPayload.code = ex.code;
        errorPayload.message = ex.message != null ? ex.message : ex.getMessage();
        errorPayload.details = ex.details;
        sendJson(errorPayload, ex.httpStatus);
    }

    /**
     * @description Writes an ApiErrorDTO response from error details.
     * @param statusCode HTTP status code.
     * @param code Error code identifier.
     * @param message Human-readable message.
     * @param details Optional error details.
     * @return void
     * @throws ApiException When response cannot be written.
     */
    public static void sendError(Integer statusCode, String code, String message, Object details) {
        sendError(new ApiException(statusCode, code, message, details));
    }

    /**
     * @description Parses a positive integer query param with default value.
     * @param rawValue Raw string parameter.
     * @param defaultValue Default if rawValue is blank.
     * @param paramName Parameter name for errors.
     * @return Parsed integer.
     * @throws ApiException When parsing fails or value is < 1.
     */
    public static Integer parsePositiveInt(String rawValue, Integer defaultValue, String paramName) {
        if (String.isBlank(rawValue)) {
            return defaultValue;
        }

        Integer parsedValue;
        try {
            parsedValue = Integer.valueOf(rawValue);
        } catch (Exception ex) {
            throw new ApiException(400, 'INVALID_PARAMETER', 'Invalid parameter: ' + paramName + '.', new Map<String, Object>{
                'param' => paramName,
                'value' => rawValue,
                'reason' => 'must be an integer'
            });
        }

        if (parsedValue < 1) {
            throw new ApiException(400, 'INVALID_PARAMETER', 'Invalid parameter: ' + paramName + '.', new Map<String, Object>{
                'param' => paramName,
                'value' => rawValue,
                'reason' => 'must be >= 1'
            });
        }
        return parsedValue;
    }

    /**
     * @description Validates page size against a maximum value.
     * @param page Page number.
     * @param pageSize Page size.
     * @param maxPageSize Maximum allowed page size.
     * @return void
     * @throws ApiException When pageSize exceeds maxPageSize.
     */
    public static void validatePagination(Integer page, Integer pageSize, Integer maxPageSize) {
        if (pageSize > maxPageSize) {
            throw new ApiException(400, 'INVALID_PARAMETER', 'Invalid parameter: pageSize.', new Map<String, Object>{
                'param' => 'pageSize',
                'value' => String.valueOf(pageSize),
                'reason' => 'max value ' + maxPageSize
            });
        }
    }

    /**
     * @description Normalizes request path by trimming trailing slash.
     * @param path Raw path.
     * @return Normalized path string.
     * @throws ApiException When normalization fails.
     */
    public static String normalizePath(String path) {
        if (String.isBlank(path)) {
            return '';
        }
        if (path.endsWith('/')) {
            return path.substring(0, path.length() - 1);
        }
        return path;
    }

    /**
     * @description Writes default OPTIONS response headers.
     * @param allowMethods Allowed HTTP methods.
     * @return void
     * @throws ApiException When response cannot be written.
     */
    public static void handleOptions(String allowMethods) {
        RestResponse response = RestContext.response;
        response.statusCode = 204;
        response.addHeader('Access-Control-Allow-Methods', allowMethods);
        response.addHeader('Access-Control-Allow-Headers', 'Authorization,Content-Type');
    }
}
