public class whatsappIntergrationCont {

    @future(callout=true)
    public static void sendTemplateMessages(List<String> contactIds) {
        try {
            // Query contact details
            List<Contact> contacts = [SELECT Id, Phone FROM Contact WHERE Id IN :contactIds];
            Http http = new Http();

            for (Contact contactDetail : contacts) {
                if (contactDetail.Phone != null) {
                    // Formating the phone number for WhatsApp (country code + phone number)
                    String whatsAppNumber = '1' + contactDetail.Phone;

                    // Create HTTP request
                    HttpRequest req = new HttpRequest();
                    req.setEndpoint('https://graph.facebook.com/v21.0/441518285719470/messages');
                    req.setHeader('Content-Type', 'application/json');
                    req.setMethod('POST');

                    // Request body for sending a template message
                    String body = '{"messaging_product":"whatsapp", "to":"' + whatsAppNumber + '", "type":"template", "template":{"name":"hello_world","language":{"code":"en_US"}}}';
                    req.setBody(body);

                    // Add Authorization header with the API token
                    String apiToken = 'EAAb9sbVXf9sBO5rdO0FK9zb9pZCZBCpLo6O6VYLLQIWmwB1PRZCVEQe62D5mjVwtGZAnuS20vswzj1O1gy4jVHkBjGrqak4FSZCZALYdmFd4mdyEnLF5WiBGJjYuPgdVD0pGYcxHXPMTZBTZB39kJGhhoEbZCOMMZCxfbE7iaklGK3hel5npQWeaoVykKQv908ZCeH2z1HPzxLRDeoZCb5AhgDM5zU5N9wBQIAZDZD';
                    req.setHeader('Authorization', 'Bearer ' + apiToken);

                    // Send the HTTP request
                    HttpResponse res = http.send(req);

                    // Debug the response
                    if (res.getStatusCode() == 200) {
                        System.debug('Message sent successfully to ' + whatsAppNumber);
                        System.debug('Response Body: ' + res.getBody());
                    } else {
                        System.debug('Failed to send message. Status Code: ' + res.getStatusCode());
                        System.debug('Response: ' + res.getBody());
                    }
                } else {
                    System.debug('Contact ' + contactDetail.Id + ' does not have a phone number.');
                }
            }
        } catch (Exception e) {
            System.debug('Error during WhatsApp message callout: ' + e.getMessage());
        }
    }
}
