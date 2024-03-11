/**
 * Company      : Apttus Inc.
 * Description  : Org Set up class
 * History      :
 * [6th Feb 2015] Hemal Yadav    : Created Class 
 */
Global with sharing class APTPS_OrgSetupController {

    public Id trainingOrgId {get;set;}
    public Training_Org_Setup__c trainingOrgSO;
    public List<Apttus_Config2__ClassificationName__c> categories{get;set;}
    public String [] categoriesArray {get;set;}
      
    /**
    * Class Constructor specifying initial values
    * @param stdController the standard controller
    */
    public APTPS_OrgSetupController(ApexPages.StandardController stdController) {
    
        trainingOrgId = stdController.getRecord().Id;
        categories = [SELECT Id FROM Apttus_Config2__ClassificationName__c WHERE Apttus_Config2__Type__c = 'Offering' OR Apttus_Config2__Type__c = 'Both'];
        categoriesArray = new String [categories.size()];
        Integer i = 0;
        for (Apttus_Config2__ClassificationName__c category : categories) {
            categoriesArray[i++] = String.valueOf(category.Id);
        }
        trainingOrgSO = [SELECT Instance_URL_Default__c, Instance_URL_To_Be__c, Update_Instance_URL__c, Update_Student_Account_Passwords__c,
                                Update_Student_Account_Usernames__c, Student_Account_Username_Conv_Default__c, Student_Account_Username_Conv_To_Be__c,
                                Student_Account_Password_To_Be__c, Student_Account_Password_Default__c
                         FROM Training_Org_Setup__c
                         WHERE id =: trainingOrgId]; 
      
    }
    
     public void execute() {
        // Update Instance URL
        if(trainingOrgSO.Update_Instance_URL__c) {
            if(trainingOrgSO.Instance_URL_Default__c != null && trainingOrgSO.Instance_URL_To_Be__c == null) {
                setInstanceURL(trainingOrgSO.Instance_URL_Default__c);
            } else if(trainingOrgSO.Instance_URL_To_Be__c != null) {
                setInstanceURL(trainingOrgSO.Instance_URL_To_Be__c);
            }  
        }
        
    }  
    
        
    @RemoteAction
    global static void execute2(ID tId) {
        Training_Org_Setup__c  trainingOrgSO = [SELECT Instance_URL_Default__c, Instance_URL_To_Be__c, Update_Instance_URL__c, Update_Student_Account_Passwords__c,
                                                       Update_Student_Account_Usernames__c, Student_Account_Username_Conv_Default__c, Student_Account_Username_Conv_To_Be__c,
                                                       Student_Account_Password_To_Be__c, Student_Account_Password_Default__c
                                                FROM Training_Org_Setup__c
                                                WHERE id =: tId]; 
        // Update Instance URL
        if(trainingOrgSO.Update_Instance_URL__c) {
            if(trainingOrgSO.Instance_URL_Default__c != null && trainingOrgSO.Instance_URL_To_Be__c == null) {
                setInstanceURL(trainingOrgSO.Instance_URL_Default__c);
            } else if(trainingOrgSO.Instance_URL_To_Be__c != null) {
                setInstanceURL(trainingOrgSO.Instance_URL_To_Be__c);
            }  
        }
        
               
        trainingOrgSO.Last_Executed__c = DateTime.Now();
        trainingOrgSO.Execution_Log__c = 'Success';
        
        update trainingOrgSO;
        system.debug('*** last executed : ' + trainingOrgSO.Last_Executed__c );
    
        
    }
    
    @RemoteAction
    global static void execute3(ID tId) {
        Training_Org_Setup__c  trainingOrgSO = [SELECT Instance_URL_Default__c, Instance_URL_To_Be__c, Update_Instance_URL__c, Update_Student_Account_Passwords__c,
                                                       Update_Student_Account_Usernames__c, Student_Account_Username_Conv_Default__c, Student_Account_Username_Conv_To_Be__c,
                                                       Student_Account_Password_To_Be__c, Student_Account_Password_Default__c
                                                FROM Training_Org_Setup__c
                                                WHERE id =: tId]; 
        //get users
        List<User> users = [SELECT Id, Name, Username, LastName, FirstName FROM USER WHERE Name like '%student%'];
        
        //Update User Name
        if(trainingOrgSO.Update_Student_Account_Usernames__c) {
            if(trainingOrgSO.Student_Account_Username_Conv_Default__c != null && trainingOrgSO.Student_Account_Username_Conv_To_Be__c == null) {
                setUserName(trainingOrgSO.Student_Account_Username_Conv_Default__c, users);
            } else if(trainingOrgSO.Student_Account_Username_Conv_To_Be__c!= null) {
                setUserName(trainingOrgSO.Student_Account_Username_Conv_To_Be__c, users);
            }
        }
        
        //Update User Password
        if(trainingOrgSO.Update_Student_Account_Passwords__c) {
            if(trainingOrgSO.Student_Account_Password_Default__c!= null && trainingOrgSO.Student_Account_Password_To_Be__c == null) {
                setUserPassword(trainingOrgSO.Student_Account_Username_Conv_Default__c, users);
            } else if(trainingOrgSO.Student_Account_Password_To_Be__c != null) {
                setUserPassword(trainingOrgSO.Student_Account_Password_To_Be__c, users);
            }
        }
        
        //return new PageReference('/' + trainingOrgSO.Id);
    }    
    
    private static void setUserName(String userName, List<User> users){
        List<User> usersToUpdate = new List<User>();
        for(User u : Users) {
            u.Username = 's' + u.LastName + '@apttusu.' + userName;
            usersToUpdate.add(u);
        }
        
        if(usersToUpdate.size() > 0) {
            update usersToUpdate;
        }
        
    }
    
    private static void setUserPassword(String password, List<User> users){
        for(User u : Users) {
            System.setPassword(u.Id, password);
        }
    }
    
    private static void setInstanceURL(String instanceUrl){
    
        Apttus_Approval__ApprovalsSystemProperties__c ApprovalsSystemProperties=Apttus_Approval__ApprovalsSystemProperties__c.getValues('System Properties');
        ApprovalsSystemProperties.Apttus_Approval__InstanceUrl__c = instanceUrl;
        Update ApprovalsSystemProperties;
        
        Apttus_Config2__ConfigSystemProperties__c ConfigSystemProperties=Apttus_Config2__ConfigSystemProperties__c.getValues('System Properties');
        ConfigSystemProperties.Apttus_Config2__InstanceUrl__c = instanceUrl;
        
        Update ConfigSystemProperties;
        
        Apttus__ComplySystemProperties__c ComplySystemProperties=Apttus__ComplySystemProperties__c.getValues('System Properties');
        ComplySystemProperties.Apttus__InstanceUrl__c = instanceUrl;
        
        Update ComplySystemProperties;
        
        Apttus_Proposal__ProposalSystemProperties__c ProposalSystemProperties=Apttus_Proposal__ProposalSystemProperties__c.getValues('System Properties');
        ProposalSystemProperties.Apttus_Proposal__InstanceUrl__c = instanceUrl;
        
        Update ProposalSystemProperties;
    }
    
    @RemoteAction
    public static Boolean runCategoryMaintenanceJob(string categoryId){
        Id catId = Id.valueOf(categoryId.trim());
        ID jobID = System.enqueueJob(new CategoryJobAsyncExecution(catId));
        system.debug('### jobID : ' + jobID);
        return TRUE;
    }
    
    public PageReference backToRecord() {
        return new PageReference('/' + trainingOrgSO.Id);
    }
    
}