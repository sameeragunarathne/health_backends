import ballerina/http;

configurable map<string> patientIds = {
    "444222222": "https://run.mocky.io/v3/817f521b-9c58-4083-b719-f39973e81e20",
    "564738291": "https://run.mocky.io/v3/cf32afde-8f75-4350-9844-f8c386003e55",
    "102938475": "https://run.mocky.io/v3/f1090dc8-3d7b-49c2-a0a4-db372f47aa17"
};

service /patients on new http:Listener(9091) {
    
    // Get CCDA document for specific patient
    resource function get patients/[string id]/ccda() returns xml|error {
        if !patientIds.hasKey(id) {
            return error("Patient not found: " + id);
        }

        http:Client ccdaEpClient = check new (patientIds.get(id));
        
        // Call first API to get CCDA document
        http:Response documentResponse = check ccdaEpClient->get("/" + id);
        
        if documentResponse.statusCode == 200 {
            xml documentContent = check documentResponse.getXmlPayload();
            return documentContent;
        }
        
        return error("CCDA document not found for patient: " + id);
    }
}