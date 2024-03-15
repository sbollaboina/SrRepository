
public class weatherinformaton {
    public static void getWeather() {
        // Define the SOAP API endpoint
        String endpoint = 'http://api.weather.com/';

        // Create an instance of the HTTPRequest class
        HttpRequest request = new HttpRequest();

        // Set the endpoint URL
        request.setEndpoint(endpoint);

        // Set the HTTP method to GET
        request.setMethod('GET');

        // Send the request and get the response
        HttpResponse response = new Http().send(request);

        // Parse the response XML to get the weather information
        XmlStreamReader responseReader = new XmlStreamReader(response.getBody());
        while (responseReader.hasNext()) {
            if (responseReader.getEventType() == XmlTag.START_ELEMENT) {
                System.debug(responseReader.getLocalName());
            }
            responseReader.next();
        }

    }
}