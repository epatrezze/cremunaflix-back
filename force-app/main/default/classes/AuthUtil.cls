/**
 * @file AuthUtil
 * @description Placeholder authorization checker for Bearer tokens.
 * @layer Service
 * @patterns Utility
 * @author IA
 * @date 2026-01-25
 */
public with sharing class AuthUtil {
    public static Boolean enforceAuth = false;

    /**
     * @description Enforces Authorization header when enabled.
     * @param none
     * @return void
     * @throws ApiException When auth is required and missing/invalid.
     */
    public static void requireAuth() {
        if (!enforceAuth) {
            return;
        }

        RestRequest request = RestContext.request;
        String authHeader = request != null ? request.headers.get('Authorization') : null;
        if (String.isBlank(authHeader) || !authHeader.startsWith('Bearer ')) {
            throw new ApiException(401, 'UNAUTHORIZED', 'Missing or invalid Authorization header.', null);
        }
    }
}
