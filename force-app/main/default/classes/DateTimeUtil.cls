/**
 * @file DateTimeUtil
 * @description ISO-8601 parsing/formatting helpers for API payloads.
 * @layer Service
 * @patterns Utility
 * @author IA
 * @date 2026-01-25
 */
public with sharing class DateTimeUtil {
    /**
     * @description Parses an ISO-8601 datetime string into a Datetime value.
     * @param value ISO-8601 datetime string.
     * @return Parsed Datetime or null if blank.
     * @throws ApiException When parsing fails.
     */
    public static Datetime parseIso(String value) {
        if (String.isBlank(value)) {
            return null;
        }

        try {
            return (Datetime) JSON.deserialize('"' + value + '"', Datetime.class);
        } catch (Exception ex) {
            throw new ApiException(400, 'INVALID_PARAMETER', 'Invalid datetime format.', new Map<String, Object>{
                'value' => value,
                'expected' => 'ISO-8601'
            });
        }
    }

    /**
     * @description Formats a Datetime into an ISO-8601 UTC string.
     * @param value Datetime to format.
     * @return ISO-8601 UTC string or null if value is null.
     * @throws ApiException When formatting fails.
     */
    public static String formatIso(Datetime value) {
        if (value == null) {
            return null;
        }
        return value.formatGMT('yyyy-MM-dd\'T\'HH:mm:ss\'Z\'');
    }
}
