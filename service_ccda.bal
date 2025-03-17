import ballerina/http;
import ballerina/io;

configurable map<string> patientIds = {
    "444222222": "/Users/sameerag/Documents/444222222.xml",
    "564738291": "/Users/sameerag/Documents/564738291.xml",
    "102938475": "/Users/sameerag/Documents/102938475.xml"
};

service /patients on new http:Listener(9091) {
    
    // Get CCDA document for specific patient
    resource function get patients/[string id]/ccda() returns xml|error {
        if !patientIds.hasKey(id) {
            return error("Patient not found: " + id);
        }

        string xmlContent = check io:fileReadString(patientIds.get(id));
        xml documentContent = check xml:fromString(xmlContent);

        return documentContent;
    }
}