public class CreateExternalIDFields_Controller {
   
    // the createField and checkStatus APIs can only process max 10 requests 
    // this var is used to keep the count of requests in the batch and then submit the batch
    public Integer batchCounter=0;
    
    // the name of the file that is uploaded by the user
    public string filename{get; set;}
    
    // the contents of the file uploaded by the user
    public Blob filebody{get; set;}
    
    // the size of the file uploaded by the user
    public decimal filesize{get; set;}
    
    // the objects from the file
    public List<String> lstCustomObjectAPI = New List<String>();
    
    // holds the temporary results from a batch that was submitted for field creation
    public List<MetadataService.AsyncResult> tempFieldCreationStatus {get;set;}
    
    // holds the results from all the batches that were submitted for field creation
    public List<MetadataService.AsyncResult> finalFieldCreationStatus {get;set;}
    
    // holds the temporary results from a batch that was submitted to check the status of the previously submitted request
    public List<MetadataService.AsyncResult> tempAsyncStatusLst {get;set;}
    
    // holds the results from all batches that were submitted to check the status of the previously submitted requests
    public List<MetadataService.AsyncResult> finalAsyncStatusLst {get;set;}
    
    
    
    public PageReference createField()
    {
        
        String str;
        String ObjectAPIName;

        MetadataService.CustomField customField;

        List<MetadataService.Metadata> metaDataLst = New List<MetadataService.Metadata>();
        
        finalFieldCreationStatus = new List<MetadataService.AsyncResult>();

        // get the object names from the file that is uploaded by the user
        findCutomObjectAPIName();
                   
        // loop over the object names and create the custom external id field on each object
        For( Integer i = 1 ; i <=lstCustomObjectAPI.size() ; i++)
        {
            str = lstCustomObjectAPI[i-1];
            ObjectAPIName = str.split(',')[0].Trim();
            
            // prepare the custom field object
            customField = new MetadataService.CustomField();
            customField.fullName = ObjectAPIName+'.APTS_Ext_ID__c';
            customField.label = 'APTS Ext ID';
            customField.type_x = 'Text';
            customField.length = 20;
            customField.unique = true;
            customField.externalId = true;
            metaDataLst.add(customField);
            
           // we need to maintain this counter so that at a given time max 10 requests are submitted 
           // to the metadata api
           batchCounter++;
           
           // invoke the metadata api only IF
           // the batch size is 10 or 
           // we have reached the max no. of objects.
           if( batchCounter == 10  || i==lstCustomObjectAPI.size()   )
            {
                
                try{
                
                     // invoke the metadata api to create the custom field
                    tempFieldCreationStatus = createService().create(metaDataLst);  
                     
                   
                    // Due to metadata api restriction, at a given time we are submitting max 10 requests
                    // however we need to later get the status of all the requests that we submitted
                    // hence we maintain this list which would contain the IDs of all the requests (from all the batches!)
                    finalFieldCreationStatus.addAll(tempFieldCreationStatus);
                    
                    }Catch(Exception e)
                        {
                                // throw exception, if any
                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error, e.getMessage()));
                                return null;
                        }                
                // reset the list and the counter
                // again, this needs to be done coz of the metadata api restriction of max 10 requests per api call.
                metaDataLst = New List<MetadataService.Metadata>();
                batchCounter =0;
            }
            
          
        }       

        // Display status of the request
        displayStatus();
        
        return null;
    }
    
    // this method prepares the list with the object names from the file that was uploaded by the user
    public void findCutomObjectAPIName(){
    
        if( filebody != null )
            lstCustomObjectAPI = filebody.toString().split('\n');
    } 
    
    public PageReference checkStatus()
    {
        
        List<String>  checkAsyncStatusIDLst = new List<String>();

       
            finalAsyncStatusLst= new List<MetadataService.AsyncResult>();
        
                
        // Check status of the request
        if( finalFieldCreationStatus != null )
        {   
            
            // the process (batching of requests i.e. max 10 requests per batch) 
            // that we did while submitting the request needs 
            // to be repeated for checking the status of each submitted request
            for(Integer i=0; i <finalFieldCreationStatus.size();i++)
            {

                checkAsyncStatusIDLst.add(finalFieldCreationStatus[i].id);
                batchCounter++;
                    
                if( batchCounter == 10  || i==finalFieldCreationStatus.size()   )
                    {
                        // check the status of these requests
                        tempAsyncStatusLst = createService().checkStatus( checkAsyncStatusIDLst );
                        
                        // add the result to the list which maintains all the results
                        finalAsyncStatusLst.addAll(tempAsyncStatusLst);
                        
                        // reset the list and the counter
                        checkAsyncStatusIDLst = new List<String>();
                        batchCounter=0;
                }

            }
        }
        
        
        displayStatus();        
        
        return null;    
    }
    
    // display the status of the submitted request to the user
    public void displayStatus()
    {
        
        Integer successCount = 0;
        
        // check if we are displaying the status on click of "create external id button"
        if(finalAsyncStatusLst==null)
        {
            // in that case the result is yet to be fetched.
            finalAsyncStatusLst = finalFieldCreationStatus;
        }
        
       String results = '<ul>';
        // Inspect the AsyncResult and display the result
        for(Integer i = 0 ; i < finalAsyncStatusLst.size(); i++)
        {
        
        if(finalAsyncStatusLst[i].done )
        {
          successCount++;
        }
        
         if(successCount==lstCustomObjectAPI.size()-1)
         {
         
         ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Request Completed.' ));
         finalFieldCreationStatus = null;
         // add the message to the page
     //   ApexPages.addMessage(
      //      new ApexPages.Message(ApexPages.Severity.Info, 
     //           finalAsyncStatusLst[i].done ? 'Request Completed.': 'Request is in progress...'));
         }
         else
         {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Request In Progress...' ));
         
         }
       
        
        if(finalAsyncStatusLst[i].state == 'Error')
        {
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning, finalAsyncStatusLst[i].message));
            
            }
        if(finalAsyncStatusLst[i].done)
        {
            system.debug('resetting status');
            finalAsyncStatusLst[i] = null;
            
            }
            }
    }
        
    private static MetadataService.MetadataPort createService()
    { 
        // Create the Metadata API service stub and authenticate
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;     
    }
}