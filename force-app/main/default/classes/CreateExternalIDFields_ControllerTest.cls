/*
* Apex Test Class: CreateExternalIDFields_ControllerTest; for class: CreateExternalIDFields_Controller 
* Author: Rajiv Bhatt (rbhatt@apttus.com)
*/
@isTest
public class CreateExternalIDFields_ControllerTest 

{


  private class WebServiceMockImpl implements WebServiceMock 
  {
    public void doInvoke(
      Object stub, Object request, Map<String, Object> response,
      String endpoint, String soapAction, String requestName,
      String responseNS, String responseName, String responseType) 
    {
      if(request instanceof MetadataService.retrieve_element)
        response.put('response_x', new MetadataService.retrieveResponse_element());
      else if(request instanceof MetadataService.checkDeployStatus_element)
        response.put('response_x', new MetadataService.checkDeployStatusResponse_element());
      else if(request instanceof MetadataService.update_element)
        response.put('response_x', new MetadataService.updateResponse_element());
      else if(request instanceof MetadataService.listMetadata_element)
        response.put('response_x', new MetadataService.listMetadataResponse_element());
      else if(request instanceof MetadataService.checkStatus_element)
        response.put('response_x', new MetadataService.checkStatusResponse_element());
      else if(request instanceof MetadataService.create_element)
        response.put('response_x', new MetadataService.createResponse_element());
      else if(request instanceof MetadataService.checkRetrieveStatus_element)
        response.put('response_x', new MetadataService.checkRetrieveStatusResponse_element());
      else if(request instanceof MetadataService.delete_element)
        response.put('response_x', new MetadataService.deleteResponse_element());
      else if(request instanceof MetadataService.describeMetadata_element)
        response.put('response_x', new MetadataService.describeMetadataResponse_element());
      else if(request instanceof MetadataService.deploy_element)
        response.put('response_x', new MetadataService.deployResponse_element());
      return;
    }
  }    

    // test method for createFiled method of CreateExternalIDFields_Controller class
    public static testmethod void testFieldCreation(){
    Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
     Test.StartTest();
     
     // create the instance of the class
     CreateExternalIDFields_Controller extIDFieldController = new CreateExternalIDFields_Controller();
     
     // set the sample test data 
     extIDFieldController.FileBody=Blob.valueOf('Product2\nApttus_Config2__ClassificationName__c\nApttus_Config2__ClassificationHierarchy__c');
     
     //invoke the createField method
     extIDFieldController.createField();
     
     
       
     // create a new instance of the controller
     extIDFieldController = new CreateExternalIDFields_Controller();
    
     
      // get the test data to test the other methods - checkStatus() and display()
     extIDFieldController.finalFieldCreationStatus = getFinalFieldCreationStatusLst();
     extIDFieldController.finalAsyncStatusLst = getFinalAsyncStatusLst();
     
     extIDFieldController.displayStatus();
    
     // test the other methods from the controller 
     extIDFieldController.checkStatus();
     
    
     
     Test.StopTest();
     
   
    
    
    }
 
     public static List<MetadataService.AsyncResult> getFinalFieldCreationStatusLst ()
     {
       
         List<MetadataService.AsyncResult> finalFieldCreationStatusLst = new List<MetadataService.AsyncResult> ();
         
         MetadataService.AsyncResult  finalFieldCreationStatus = new MetadataService.AsyncResult();
         finalFieldCreationStatus.done = true;
     
         finalFieldCreationStatusLst.add(finalFieldCreationStatus);
     
         finalFieldCreationStatus = new MetadataService.AsyncResult();
         finalFieldCreationStatus.done = false;
     
         finalFieldCreationStatusLst.add(finalFieldCreationStatus);
     
         return finalFieldCreationStatusLst;
     
     }
     
     public static List<MetadataService.AsyncResult> getFinalAsyncStatusLst()
     {
     
         List<MetadataService.AsyncResult> finalAsyncStatusLst = new List<MetadataService.AsyncResult> ();
     
     
         MetadataService.AsyncResult  finalAsyncStatus = new MetadataService.AsyncResult();
         finalAsyncStatus.done = true;
     
         finalAsyncStatusLst.add(finalAsyncStatus);
     
     
         finalAsyncStatus = new MetadataService.AsyncResult();
         finalAsyncStatus.done = false;
     
        finalAsyncStatusLst.add(finalAsyncStatus);
     
        return finalAsyncStatusLst;
     }

}