import ballerina/http;

configurable string USER_NAME = ?;
configurable string USER_PASSWORD = ?;

final http:Client securedEP = check new("https://www.seedr.cc/rest",
    cache = {enabled: true, isShared: true},
    auth = {
        username:  USER_NAME,
        password: USER_PASSWORD
    });

service / on new http:Listener(9090) {

    @http:ResourceConfig {
        produces: ["application/json"]
    }
    isolated resource function get folder() returns json|error? {

        json response = check securedEP->get("/folder");
        return response;
    }

    resource function get folder/[string id]() returns json|error? {
        json response = check securedEP->get("/folder/" + id);
        return response;
    }

    resource function get user() returns json|error? {
        json response = check securedEP->get("/user");
        return response;
    }

    resource function get file/[string id](http:Request req) returns http:Response|error? {
        http:Response response = check securedEP->forward("/file/" + id, req);
        return response;
    }

    resource function get file/[string id]/hls (http:Request req) returns http:Response|error? {
        http:Response response = check securedEP->forward("/file/" + id + "/hls", req);
        return response;
    }

    resource function get file/[string id]/image (http:Request req) returns http:Response|error? {
        http:Response response = check securedEP->forward("/file/" + id + "/image", req);
        return response;
    }

    resource function get file/[string id]/thumbnail (http:Request req) returns http:Response|error? {
        http:Response response = check securedEP->forward("/file/" + id + "/thumbnail", req);
        return response;
    }

    resource function get empId/[int id]() returns json {
        return {empId: id};
    }
}
