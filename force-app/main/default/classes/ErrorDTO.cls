/**
 * @file ErrorDTO
 * @description Error payload for API v1 responses.
 * @layer DTO
 * @patterns DTO
 * @author epatrezze
 * @date 2026-01-27
 */
public without sharing class ErrorDTO {
    public String code;
    public String message;
    public Object details;
}
