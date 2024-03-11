@isTest  
private class MetadataServiceTest 
{    
    /**
     * Dummy Metadata API web service mock class (see MetadataCreateJobTest.cls for a better example)
     **/
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
    
  @IsTest
  private static void coverGeneratedCodeCRUDOperations()
  {  
      // Null Web Service mock implementation
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService MetadataService = new MetadataService();
        // Invoke operations         
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        metaDataPort.create(null);
        metaDataPort.deleteMetadata(null);
        metaDataPort.updateMetadata(new MetadataService.UpdateMetadata[]{});    
  }
  
  @IsTest
    private static void coverGeneratedCodeFileBasedOperations()
    {      
      // Null Web Service mock implementation
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        // Only required to workaround a current code coverage bug in the platform
        MetadataService MetadataService = new MetadataService();
        // Invoke operations         
        MetadataService.MetadataPort metaDataPort = new MetadataService.MetadataPort();
        metaDataPort.retrieve(null);
        metaDataPort.checkDeployStatus(null, false);
        metaDataPort.listMetadata(null, null);
        metaDataPort.checkStatus(null);
        metaDataPort.describeMetadata(null);
        metaDataPort.checkRetrieveStatus(null);
        metaDataPort.deploy(null, null);
        metaDataPort.checkDeployStatus(null, false);
    }
        
  @IsTest
    private static void coverGeneratedCodeTypes()
    {             
        // Reference types
        new MetadataService();
        new MetadataService.listMetadataResponse_element();
        new MetadataService.AccountOwnerSharingRule();
        new MetadataService.describeMetadata_element();
        new MetadataService.delete_element ();
        new MetadataService.create_element ();
        new MetadataService.checkStatus_element();                                              
        new MetadataService.checkStatusResponse_element();
        new MetadataService.CustomField ();
        new MetadataService.FilterItem ();
        new MetadataService.deployResponse_element ();
        new MetadataService.SessionHeader_element ();
        new MetadataService.DebuggingInfo_element ();
        new MetadataService.CallOptions_element ();
        new MetadataService.DebuggingHeader_element();
        new MetadataService.LogInfo();
        new MetadataService.retrieve_element ();
        new MetadataService.RetrieveRequest ();
        new MetadataService.retrieveResponse_element ();
        new MetadataService.checkDeployStatus_element ();
        new MetadataService.checkDeployStatusResponse_element();
        new MetadataService.DeployResult  ();
        new MetadataService.FileProperties ();
        new MetadataService.updateResponse_element  ();
        new MetadataService.RetrieveResult  ();
        new MetadataService.checkRetrieveStatusResponse_element ();
        new MetadataService.describeMetadataResponse_element  ();
        new MetadataService.DescribeMetadataResult  ();
        new MetadataService.RetrieveMessage();
        new MetadataService.DescribeMetadataObject();
        new MetadataService.checkRetrieveStatus_element();
        new MetadataService.DeployOptions();
        new MetadataService.listMetadataResponse_element ();
        new MetadataService.PicklistValue   ();
        new MetadataService.DeployMessage  ();
        new MetadataService.UpdateMetadata();
        new MetadataService.MetadataPort();
        new MetadataService.MetadataWithContent ();
        new MetadataService.ListMetadataQuery  ();
        new MetadataService.Picklist();
        new MetadataService.deploy_element();
        new MetadataService.createResponse_element ();
        new MetadataService.AuthProvider();                              
        new MetadataService.AsyncResult ();                                                                                                              
        new MetadataService.DeployDetails();                                                                                                                              
        new MetadataService.listMetadata_element();                                                                                                                                                                                                      
        new MetadataService.Metadata ();          
        new MetadataService.ReportBucketFieldValue ();          
        new MetadataService.deleteResponse_element ();          
        new MetadataService.update_element ();          
                                        }
}