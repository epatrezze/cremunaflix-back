/**
 * @file ApiErrorDTO
 * @description Error payload returned by the API.
 * @layer DTO
 * @patterns DTO
 * @author IA
 * @date 2026-01-25
 */
public with sharing class ApiErrorDTO {
    public String code;
    public String message;
    public Object details;
}
