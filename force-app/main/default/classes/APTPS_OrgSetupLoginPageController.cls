/**
 * Company      : Apttus Inc.
 * Description  : Org Set up class 
 * History      :
 * [13th Jul 2015] Hemal Yadav    : Created Class 
 */
Global with sharing class APTPS_OrgSetupLoginPageController{

    public Id trainingOrgId {get;set;}
    public Training_Org_Setup__c trainingOrgSO;
          
    /**
    * Class Constructor specifying initial values
    * 
    */
    public APTPS_OrgSetupLoginPageController() {
        List<Training_Org_Setup__c> trainingOrgList = [SELECT Id, Primary__c FROM Training_Org_Setup__c WHERE Primary__c =: True LIMIT 1];
        if(trainingOrgList.size() > 0) {
            trainingOrgSO = trainingOrgList[0];  
            trainingOrgId = trainingOrgSO.Id;  
        }
        
    }
    
    public PageReference init() {
        if(trainingOrgId != null) {
            return new PageReference('/' + trainingOrgId);
        } 
        return null;
    }
    
}