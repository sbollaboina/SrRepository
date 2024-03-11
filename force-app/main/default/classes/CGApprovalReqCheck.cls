public with sharing class CGApprovalReqCheck {

    // status pending approval
    private String STATUS_PENDING_APPROVAL = 'Pending Approval';
    // status Approved
    private String STATUS_APPROVED = 'Approved';
    // status Cancelled
    private String STATUS_CANCELLED = 'Cancelled';
    // status Approval Required
    private String STATUS_APPROVAL_REQUIRED = 'Approval Required';
    // status none
    private static String STATUS_NONE = 'None';
    
    //Anti-Recursion
    private static boolean run = true;
    
    public static boolean cgApprovalRecursionEnd() {
        if(run){
            run=false;
            return true;
        }else{
            return run;
        }
    }

    //Agreement Check
    public void cgAgreementCheck(Map<id,Apttus__APTS_Agreement__c> oldMap, Map<id,Apttus__APTS_Agreement__c> newMap){
        // skip checking under following conditions
        //    - current approval status is pending approval, meaning it is the initial submission action approval status update OR process in progress
        //    - old approval status is pending approval and new approval status is other thatn pending approval, meaning it is process completion approval status update
        for(Apttus__APTS_Agreement__c a : newMap.values()){
            if( (a.Apttus_Approval__Approval_Status__c== STATUS_PENDING_APPROVAL)
                || (oldMap.get(a.id).Apttus_Approval__Approval_Status__c== STATUS_PENDING_APPROVAL)
                ){
                return;
            }else if( CGApprovalReqCheck.cgApprovalRecursionEnd() ){
                Apttus_Approval.ApprovalRequiredCheck checker = new Apttus_Approval.ApprovalRequiredCheck();
                boolean result = checker.doCheck(a.id);
                System.debug(result);
            }   
        }
    }

    //Agreement post-Insert update
    public static void cgAgreeAppCheckPatch(Map<id,Apttus__APTS_Agreement__c> newMap){
        List<Apttus__APTS_Agreement__c> aToUpdate = new List<Apttus__APTS_Agreement__c>();
        for(Apttus__APTS_Agreement__c a : [select id,Apttus_Approval__Approval_Status__c from Apttus__APTS_Agreement__c where id in :newMap.keyset()]){
            a.Apttus_Approval__Approval_Status__c = STATUS_NONE;
            aToUpdate.add(a);
        }
        update aToUpdate;
    }

    //Agreement Clause check
    public void cgAgreementClauseCheck(Map<id,Apttus__Agreement_Clause__c> oldMap, Map<id,Apttus__Agreement_Clause__c> newMap){
        // skip checking under following conditions
        //    - current approval status is pending approval, meaning it is the initial submission action approval status update OR process in progress
        //    - old approval status is pending approval and new approval status is other thatn pending approval, meaning it is process completion approval status update
        for(Apttus__Agreement_Clause__c aClause : newMap.values()){
            if( (aClause.Approval_Status__c== STATUS_PENDING_APPROVAL)
                || (oldMap.get(aClause.id).Approval_Status__c== STATUS_PENDING_APPROVAL)
                ){
                return;
            }else if(CGApprovalReqCheck.cgApprovalRecursionEnd() && aClause.Approval_Status__c == STATUS_NONE){
                Apttus_Approval.ApprovalRequiredCheck checker = new Apttus_Approval.ApprovalRequiredCheck();
                boolean result = checker.doCheck(aClause.Apttus__Agreement__c);
                System.debug(result);
            }   
        }
    }

    //Agreement Clause post-Insert update
    public static void cgClauseAppCheckPatch(Map<id,Apttus__Agreement_Clause__c> newMap){
        List<Apttus__Agreement_Clause__c> aCToUpdate = new List<Apttus__Agreement_Clause__c>();
        for(Apttus__Agreement_Clause__c aClause : [select id,Approval_Status__c from Apttus__Agreement_Clause__c where id in :newMap.keyset()]){
            aClause.Approval_Status__c = STATUS_NONE;
            aCToUpdate.add(aClause);
        }
        update aCToUpdate;
    }
}