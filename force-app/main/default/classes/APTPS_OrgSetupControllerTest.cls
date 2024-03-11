@isTest
private class APTPS_OrgSetupControllerTest {

    static testMethod void myUnitTest() {
        
        Training_Org_Setup__c org = new Training_Org_Setup__c();
        org.Instance_URL_Override__c = 'https://na16.salesforce.com';
        org.Student_Account_Password_Override__c = 'new12346';
        org.Student_Account_Username_Conv_Override__c= 'hyadav';
        org.Update_Instance_URL__c = TRUE;
               
        insert org;
        
        Apttus_Approval__ApprovalsSystemProperties__c asp = new Apttus_Approval__ApprovalsSystemProperties__c();
        asp.Name = 'System Properties';
        insert asp;
        
        Apttus__ComplySystemProperties__c cmsp = new Apttus__ComplySystemProperties__c();
        cmsp.Name = 'System Properties';
        insert cmsp;
        
        Apttus_Config2__ConfigSystemProperties__c csp = new Apttus_Config2__ConfigSystemProperties__c();
        csp.Name = 'System Properties';
        insert csp;
        
        Apttus_Proposal__ProposalSystemProperties__c psp = new Apttus_Proposal__ProposalSystemProperties__c();
        psp.Name = 'System Properties';
        insert psp;        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(org);
        APTPS_OrgSetupController orgController = new APTPS_OrgSetupController(sc);
        
        PageReference pageRef = Page.APTPS_OrgSetup;
        pageRef.getParameters().put('id', String.valueOf(org.Id));
        Test.setCurrentPage(pageRef);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Test.startTest();
            orgController.execute();
            Test.stopTest();
        }
        
    }
    
    static testMethod void myUnitTest1() {
        
        Training_Org_Setup__c org = new Training_Org_Setup__c();
        org.Instance_URL_Override__c = 'https://na16.salesforce.com';
        org.Student_Account_Password_Override__c = 'apttus1';
        org.Student_Account_Username_Conv_Override__c= 'hyadav';
        org.Update_Instance_URL__c = TRUE;
        
        insert org;
        
        Apttus_Approval__ApprovalsSystemProperties__c asp = new Apttus_Approval__ApprovalsSystemProperties__c();
        asp.Name = 'System Properties';
        insert asp;
        
        Apttus__ComplySystemProperties__c cmsp = new Apttus__ComplySystemProperties__c();
        cmsp.Name = 'System Properties';
        insert cmsp;
        
        Apttus_Config2__ConfigSystemProperties__c csp = new Apttus_Config2__ConfigSystemProperties__c();
        csp.Name = 'System Properties';
        insert csp;
        
        Apttus_Proposal__ProposalSystemProperties__c psp = new Apttus_Proposal__ProposalSystemProperties__c();
        psp.Name = 'System Properties';
        insert psp;        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(org);
        APTPS_OrgSetupController orgController = new APTPS_OrgSetupController(sc);
        
        PageReference pageRef = Page.APTPS_OrgSetup;
        pageRef.getParameters().put('id', String.valueOf(org.Id));
        Test.setCurrentPage(pageRef);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Test.startTest();
            APTPS_OrgSetupController.execute2(org.Id);
            Test.stopTest();
        }
    }
    
     static testMethod void myUnitTest2() {
        
        Training_Org_Setup__c org = new Training_Org_Setup__c();
        org.Instance_URL_Override__c = 'https://na16.salesforce.com';
        org.Student_Account_Password_Override__c = 'new12345';
        org.Student_Account_Username_Conv_Override__c= 'hyadav';
        org.Update_Student_Account_Passwords__c = TRUE;
        org.Update_Student_Account_Usernames__c = TRUE;
        
        insert org;
        
        Apttus_Approval__ApprovalsSystemProperties__c asp = new Apttus_Approval__ApprovalsSystemProperties__c();
        asp.Name = 'System Properties';
        insert asp;
        
        Apttus__ComplySystemProperties__c cmsp = new Apttus__ComplySystemProperties__c();
        cmsp.Name = 'System Properties';
        insert cmsp;
        
        Apttus_Config2__ConfigSystemProperties__c csp = new Apttus_Config2__ConfigSystemProperties__c();
        csp.Name = 'System Properties';
        insert csp;
        
        Apttus_Proposal__ProposalSystemProperties__c psp = new Apttus_Proposal__ProposalSystemProperties__c();
        psp.Name = 'System Properties';
        insert psp;        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(org);
        APTPS_OrgSetupController orgController = new APTPS_OrgSetupController(sc);
        
        PageReference pageRef = Page.APTPS_OrgSetup;
        pageRef.getParameters().put('id', String.valueOf(org.Id));
        Test.setCurrentPage(pageRef);
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
        System.runAs (thisUser) {
            Test.startTest();
            APTPS_OrgSetupController.execute3(org.Id);
            Test.stopTest();
        }
        
    }
}