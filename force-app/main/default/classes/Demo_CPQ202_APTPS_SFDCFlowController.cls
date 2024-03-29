/**
 *  Apttus Config & Pricing
 *  Controller for Guided Selling Page; Initial code by Apttus Engineering
 *   
 *  @2012-2015 Apttus Inc. All rights reserved. 
 *  e neiman;  enhancements base controller 
 *  Revised for CenturyLink, 3/26/2015
 */
public with sharing class Demo_CPQ202_APTPS_SFDCFlowController {
    private static final Integer searchItemsSizeLimit   = 15;
    // parameter names
    private static final String PARAM_PRODUCT_ID            = 'productId';
    private static final String PARAM_CONFIGURE             = 'configure';
    private static final String PARAM_INTERVIEW_ID          = 'interviewId';
    private static final String PARAM_INTERVIEW_NAME        = 'interviewName';
    private static final String PARAM_CONFIG_REQUEST_ID     = 'configRequestId';
    private static final String PARAM_CALLER_PAGE_ID        = 'callerPage';
    private static final String PARAM_RETURN_PAGE           = 'returnPage';
    private static final String PARAM_STEP                  = 'step';
    // default page size
    private static final Integer PAGESIZE_DEFAULT           = 25;    
    //getter/setters
     public Apttus_Config2__ProductConfiguration__c configSO {get; set;}  
     public Apttus_Proposal__Proposal__c proposal {get; set;}
     public String lookupHoverDetailUrl {get; set;}
     public String proposalPageUrl {get; set;}
     public static String doInstructions {get; set;}
     public static Boolean notFirstPage {get; set;}   
    // interview steps
    private static final String STEP_BUNDLE                 = 'Bundle';
    private static final String STEP_OPTION                 = 'Option';
    private static final String STEP_RESULT                 = 'Result';
    
    // product configuration
    private ID configId = null;
    
    // config request
    private String configRequestId = null;
    
    // state
    
    // base controller
    private Apttus_Config2.GuidePageController base = null;
    // guided interview
    private transient Apttus_Config2__SearchAttributeValue__c interviewStepSO = null;
    // interview id
    public ID gInterviewId = null;
    // bundles
    private List<BundleInfo> bundles = null;
    // step
    private enum Step {BUNDLE, OPTION, RESULT}
    // current step
    private Step currStep = null;
    
    private String callerPage;
    
    public Boolean showNoRecsToDisplayError {get; set;}
  /**    
    public account acc {get{return [ 
                SELECT Id, Name FROM account 
                WHERE Id = '001F000000zNbWw'
                ORDER BY Id
            ];} set;}

  
     * Class Constructor
     * @param stdController the standard controller
     */
    public Demo_CPQ202_APTPS_SFDCFlowController(ApexPages.StandardController stdController) {
        system.debug('!!.. ..Demo_CPQ202_APTPS_SFDCFlowController ' + ApexPages.currentPage().getParameters().get('interviewName'));
        
        callerPage = ApexPages.currentPage().getParameters().get('callerPage');
        
        // create the base controler
        this.base = new Apttus_Config2.GuidePageController(stdController);
        system.debug(this.base);
        doInstructions = 'visibility:visible;';
        notFirstPage = false;
        // read parameters
        
        // get the config sobject id
        this.configId = stdController.getId();
        configSO = [Select Apttus_QPConfig__Proposald__c from Apttus_Config2__ProductConfiguration__c where id = :configId limit 1];
        proposal = [Select Name, Apttus_Proposal__Proposal_Name__c, Apttus_QPApprov__Approval_Status__c, Company_Name__c From Apttus_Proposal__Proposal__c 
                    Where Id = :configSO.Apttus_QPConfig__Proposald__c limit 1];     
        
        if(UserInfo.getUserType() == 'Partner' || UserInfo.getUserType() == 'PowerPartner') {
            proposalPageUrl = '/prm/' + proposal.id;
        } else {
            proposalPageUrl = '/' + proposal.id;
        }
        
        // guided interview id
        String strValue = ApexPages.currentPage().getParameters().get(PARAM_INTERVIEW_ID);
        System.debug('!!.. ..gInterviewId '+ strValue + ' this.gInterviewId is ' + this.gInterviewId);
        if (strValue != null) 
            this.gInterviewId = String.escapeSingleQuotes(strValue);                     
        // account
        System.debug('!!.. ..account is ' + proposal.Company_Name__c);
        // config request id
        String configRequestIdStr = ApexPages.currentPage().getParameters().get(PARAM_CONFIG_REQUEST_ID);
        if (configRequestIdStr != null)
            configRequestId = String.escapeSingleQuotes(configRequestIdStr);

          System.debug('!!.. ..configRequestId '+ configRequestId);         
        // current step
        strValue = ApexPages.currentPage().getParameters().get(PARAM_STEP);
        if (strValue != null) {
            String stepName = String.escapeSingleQuotes(strValue);
            System.debug('!!.. ..stepName '+ stepName);
            // determine step
            if (STEP_OPTION == stepName) {
                currStep = Step.OPTION;
                
            } else if (STEP_RESULT == stepName) {
                currStep = Step.RESULT;
                
            } else {
                currStep = Step.BUNDLE;
                
            }
            
        } else {
            currStep = Step.BUNDLE;            
        }
                
    }
    
    /**
     * Performs the init action
     */
    public void doInit() {
        // initialize the base controller
        base.doInit();       
        // update step
        setCurrentStep(currStep);
        
        showNoRecsToDisplayError = false;
        
        if (getIsOptionStep() || getIsResultStep()) {
            showNoRecsToDisplayError = true;
            
            // search bundles
            doSearchStep();            
        }        
    }
    
    /**
     * 
     * @return the product configuration id
     */
    public Id getConfigId()
    {   
        system.debug('!!.. .. getConfigId ' + this.configId);
        return this.configId;
    }
    
    /**
     * Gets the cart request id
     * @return the cart request id
     */
    public ID getRequestId() {
        system.debug('!!.. .. getRequestId ' + this.configRequestId);
        return this.configRequestId;
        
    }
    
    /**
     * Gets the base controller
     * @return the base controller
     */
    public Apttus_Config2.GuidePageController getBase() {
        system.debug('!!.. .. getBase ' + base);
        return base;
        
    }
    
    /**
     * Gets the guided interview id
     * @return the guided interview id
     */
    public ID getInterviewId() {
        return base.getInterviewSO().Id;
        
    }
    
    /**
     * Checks if the current step is the bundle step
     * @return <code>true</code> if bundle step, <code>false</code> otherwise
     */
    public Boolean getIsBundleStep() {
                system.debug('!!.. ..getIsBundleStep ' + currStep);
        return (STEP.BUNDLE == currStep);
        
    }
    
    /**
     * Checks if the current step is the option step
     * @return <code>true</code> if option step, <code>false</code> otherwise
     */
    public Boolean getIsOptionStep() {
                system.debug('!!.. ..getIsOptionStep' + currStep);
        return (STEP.OPTION == currStep);
        
    }
    
    /**
     * Checks if the current step is the result step
     * @return <code>true</code> if result step, <code>false</code> otherwise
     */
    public Boolean getIsResultStep() {
    system.debug('!!.. ..getIsResultStep ' + currStep);
        return (STEP.RESULT == currStep);
        
    }
    
    /**
     * Gets the list of bundle products from the current page in the resultset
     * @return the list of bundle info objects
     */
    public List<BundleInfo> getBundleProducts() {
        return bundles;
        
    }
    
    /**
     * Checks if there are bundle products in the resultset
     * @return <code>true</code> if there are bundle products, <code<false</code> otherwise
     */
    public Boolean getHasBundleProducts() {
        return (bundles != null && !bundles.isEmpty());
        
    } 
    
    /**
     * Gets the finish page
     * @return the finish page 
     */
    public PageReference getFinishPage() {
        if (notFirstPage==true)
            doInstructions = 'visibility:hidden;';
        notFirstPage = true;
                
        system.debug('!!.. ..notFirstPage ' + notFirstPage);
        // custom page
        String pageName = 'Demo_CPQ202_APTPSGS';
        // build the custom page url
        //String pageURL = (instanceUrl != null ? instanceUrl : '');
        String pageURL = getVFPageUrlPrefix() + '/' + pageName; 
        PageReference pageRef = new PageReference(pageURL);
        pageRef.getParameters().put(PARAM_CALLER_PAGE_ID, callerPage);
                    
        system.debug('!!.. ..PARAM_INTERVIEW_NAME ' + PARAM_INTERVIEW_NAME);
        pageRef.getParameters().putAll(base.getFinishPage().getParameters());
        pageRef.getParameters().put(PARAM_INTERVIEW_NAME, 'Salesforce');        
            // add step name
          if (getIsBundleStep()) {
                 pageRef.getParameters().put(PARAM_STEP, STEP_OPTION);

            } else if (getIsOptionStep()) {
                 pageRef.getParameters().put(PARAM_STEP, STEP_RESULT);

            }

         pageRef.setRedirect(true);            
        //    System.debug(LoggingLevel.ERROR,'*** base  getFinishPage() = '+currStep+' => '+base.getInterviewSO());
         System.debug('!!.. ..getFinishPage ' + pageRef);
         return pageRef;
    }
    
    /**
     * Performs the search step 
     */
    private void doSearchStep() {
        
            // search bundles
            ApexPages.StandardSetController productSet = base.doSearchProducts(null);
            if(productSet != null){
                // set the page size
                productSet.setPageSize(PAGESIZE_DEFAULT);
                // read bundle products
                bundles = new List<BundleInfo>();
                
                Set<ID> bdlProductIds = new Set<ID>();
                Map<ID, BundleInfo> bdlLookup = new Map<ID, BundleInfo>();
                
                for (Product2 productSO : (List<Product2>) productSet.getRecords()) {
                    if(productSO.Apttus_Config2__ConfigurationType__c != 'Option'){
                        // create the product info 
                        BundleInfo bundle = new BundleInfo(productSO);
                        // add to the collection
                        bundles.add(bundle);
                        // add to the lookup
                        bdlLookup.put(productSO.Id, bundle);
                        // add to the bundle id collection to retrieve option components
                        bdlProductIds.add(productSO.Id);
                    }
                }
                System.debug(LoggingLevel.ERROR,'+++ bdlProductIds dosearchstep '+bdlProductIds);       
                // read default option components
                if (!bdlProductIds.isEmpty()) {
                    Map<ID, List<Apttus_Config2__ProductOptionComponent__c>> bdlComponents = base.getIncludedComponents(bdlProductIds);
                    System.debug(LoggingLevel.ERROR,'+++ flow option components = '+bdlComponents);
                    for (ID bundleId : bdlComponents.keySet()) {
                        // get the components for the bundle
                        List<Apttus_Config2__ProductOptionComponent__c> components = bdlComponents.get(bundleId);
                        if (components != null && bdlLookup.containsKey(bundleId)) {
                            // add components to the bundle
                            bdlLookup.get(bundleId).addOptions(components);
                            
                        }
                        
                    }
                
                }
                
               }

    }
    
    /**
     * Performs the update bundle products action 
     
    private void doUpdateStep() {
        system.debug('!!.. ..doUpdateStep' );
        Set<ID> bdlProductIds = new Set<ID>();
        Map<ID, BundleInfo> bdlLookup = new Map<ID, BundleInfo>();
        
        for (BundleInfo bundle : bundles) {
            // clear option components
            bundle.options.clear();
            // add to the lookup
            bdlLookup.put(bundle.productSO.Id, bundle);
            // add to the bundle id collection to retrieve option components
            bdlProductIds.add(bundle.productSO.Id);
            
        }
        System.debug(LoggingLevel.ERROR,'+++ bdlProductIds doupdatestep '+bdlProductIds);       
        // read default option components
            
            if (!bdlProductIds.isEmpty()) {
                Map<ID, List<Apttus_Config2__ProductOptionComponent__c>> bdlComponents = base.getIncludedComponents(bdlProductIds);
                System.debug(LoggingLevel.ERROR,'+++ flow option components  = '+bdlComponents);
                for (ID bundleId : bdlComponents.keySet()) {
                    // get the components for the bundle
                    List<Apttus_Config2__ProductOptionComponent__c> components = bdlComponents.get(bundleId);
                    
                    if (components != null) {
                        // add components to the bundle
                        bdlLookup.get(bundleId).addOptions(components);
                        
                    }
                    
                }
                
            }
        
        
        // update step
        //setCurrentStep(null);
        
    }*/
    
    /**
     * Performs the select action
     * @return the next page reference 
     */
    public PageReference doSelect() {
        system.debug('!!.. ..doSelect1');
        for (BundleInfo bundle: bundles) {
                system.debug('!!.. .. ' + bundle.productSO.Name);
        }
        String productIdStr     = ApexPages.currentPage().getParameters().get(PARAM_PRODUCT_ID);
        String configureProd    = ApexPages.currentPage().getParameters().get(PARAM_CONFIGURE);
        String returnPage       = ApexPages.currentPage().getParameters().get(PARAM_RETURN_PAGE);
        ID productId;
        ID cartId;
        Decimal lineNumber;
        Boolean hasAttributes = false;
        if (productIdStr != null) {
            system.debug('!!.. ..doSelect2');
            productId = (ID) String.escapeSingleQuotes(productIdStr);
            
            // locate the bundle
            for (BundleInfo bundle : bundles) {
                system.debug('!!.. ..doSelect3');
                if (bundle.productSO.Id == productId) {
                    // add the bundle to the cart
                    // create the add bundle request
                    Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();
                    
                    // add request parameters
                    request.CartId = base.getConfigSO().Id;
                    cartId = request.CartId;
                    // add bundle
                    Apttus_CPQApi.CPQ.SelectedBundleDO bundleDO = new Apttus_CPQApi.CPQ.SelectedBundleDO();
                    
                    // selected product
                    bundleDO.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();
                    
                    hasAttributes = bundle.productSO.Apttus_Config2__HasAttributes__c;
                    bundleDO.SelectedProduct.ProductId  = bundle.productSO.Id;
                    bundleDO.SelectedProduct.Quantity   = bundle.lineItemSO.Apttus_Config2__Quantity__c;
                    bundleDO.SelectedProduct.SellingTerm = bundle.lineItemSO.Apttus_Config2__SellingTerm__c;
                    
                    // default options
                    for (OptionInfo option : bundle.options) {
                        Apttus_CPQApi.CPQ.SelectedOptionDO optionDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();
                        
                        optionDO.ComponentId            = option.componentId;
                        optionDO.ComponentProductId     = option.productSO.Id;
                        optionDO.Quantity               = 1;
                        optionDO.SellingTerm            = 1;
                        // add the option to the bundle
                        bundleDO.SelectedOptions.add(optionDO);
                        
                    }                                        
                    
                    request.SelectedBundle = bundleDO;
                                                                                                                  
                    // add a bundle to the cart
                    Apttus_CPQApi.CPQ.AddBundleResponseDO result = Apttus_CPQApi.CPQWebService.addBundle(request);
                    System.debug(result);
                    System.debug('LineNumber=' + result.LineNumber);
                    lineNumber = result.LineNumber;
                    break;
                    
                }
                
            }
            
            Apttus_Config2.ConstraintWebService2.ConstraintResult2 res = Apttus_Config2.ConstraintWebService2.applyConstraintRulesOnAddAll(base.getConfigSO().Id);
            
        }

        
        PageReference pg;
        
        if(callerPage != null) {            
            pg = new PageReference(getVFPageUrlPrefix() + '/Apttus_Config2__pricing');
        
            pg.getParameters().put('id', configSO.Id);
            pg.getParameters().put('configRequestId', configRequestId);
        } else {
            pg = base.getCatalogPage();
        }
        
        return pg;
        
    }
    
    public class SizeException extends Exception{} 

    public PageReference doCartSelected() {
        Decimal lineNumber;
        List<Apttus_Config2__LineItem__c> lineItemsToUpdate = new List<Apttus_Config2__LineItem__c>();
        Integer selectedItemsCount = 0;
        for (BundleInfo bundle : bundles) {
            if(bundle.isSelected) {
                selectedItemsCount++;
            }
        }
        try {
            if( selectedItemsCount > searchItemsSizeLimit ) {
                throw new SizeException ('WARNING');
            }
        } catch(Exception ex) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot add more than ' + searchItemsSizeLimit + ' products at the same time.');
            ApexPages.addMessage(errorMsg);
            return null;
        }

        for (BundleInfo bundle : bundles) {
            if(bundle.isSelected) {
                // add the bundle to the cart
                // create the add bundle request
                Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();

                // add request parameters
                request.CartId = base.getConfigSO().Id;
                
                // add bundle
                Apttus_CPQApi.CPQ.SelectedBundleDO bundleDO = new Apttus_CPQApi.CPQ.SelectedBundleDO();
                
                // selected product
                bundleDO.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();

                bundleDO.SelectedProduct.ProductId = bundle.productSO.Id;
                bundleDO.SelectedProduct.Quantity = bundle.lineItemSO.Apttus_Config2__Quantity__c;
                bundleDO.SelectedProduct.SellingTerm = bundle.lineItemSO.Apttus_Config2__SellingTerm__c;

                // default options
                for (OptionInfo option : bundle.options) {
                    Apttus_CPQApi.CPQ.SelectedOptionDO optionDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();

                    optionDO.ComponentId = option.componentId;
                    optionDO.ComponentProductId = option.productSO.Id;
                    optionDO.Quantity = 1;
                    optionDO.SellingTerm = 1;
                    
                    // add the option to the bundle
                    bundleDO.SelectedOptions.add(optionDO);
                }                                        

                request.SelectedBundle = bundleDO;

                // add a bundle to the cart
                Apttus_CPQApi.CPQ.AddBundleResponseDO result = Apttus_CPQApi.CPQWebService.addBundle(request);
                lineNumber = result.LineNumber;
                lineItemsToUpdate.add(bundle.lineItemSO);
            }
        }
        
        Apttus_Config2.ConstraintWebService2.ConstraintResult2 res = Apttus_Config2.ConstraintWebService2.applyConstraintRulesOnAddAll(base.getConfigSO().Id);
        
        markLineItemsPricingToPending(lineItemsToUpdate);
        
        PageReference pg;
        
        if(callerPage != null) {            
            pg = new PageReference(getVFPageUrlPrefix() + '/Apttus_Config2__pricing');
        
            pg.getParameters().put('id', configSO.Id);
            pg.getParameters().put('configRequestId', configRequestId);
        } else {
            pg = base.getCatalogPage();
        }
        
        return pg;
    }
    
    public PageReference doSelectAll() {

        try {
            if( bundles.size() > searchItemsSizeLimit ) {
                throw new SizeException ('WARNING');
            }
        } catch(Exception ex) {
            ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'You cannot add more than ' + searchItemsSizeLimit + ' products at the same time.');
            ApexPages.addMessage(errorMsg);
            return null;
        }
        Decimal lineNumber;
        List<Apttus_Config2__LineItem__c> lineItemsToUpdate = new List<Apttus_Config2__LineItem__c>();

            for (BundleInfo bundle : bundles) {
              // add the bundle to the cart
              // create the add bundle request
              Apttus_CPQApi.CPQ.AddBundleRequestDO request = new Apttus_CPQApi.CPQ.AddBundleRequestDO();

              // add request parameters
              request.CartId = base.getConfigSO().Id;

              // add bundle
              Apttus_CPQApi.CPQ.SelectedBundleDO bundleDO = new Apttus_CPQApi.CPQ.SelectedBundleDO();

              // selected product
              bundleDO.SelectedProduct = new Apttus_CPQApi.CPQ.SelectedProductDO();


              bundleDO.SelectedProduct.ProductId = bundle.productSO.Id;
              bundleDO.SelectedProduct.Quantity = bundle.lineItemSO.Apttus_Config2__Quantity__c;
              bundleDO.SelectedProduct.SellingTerm = bundle.lineItemSO.Apttus_Config2__SellingTerm__c;

              // default options
              for (OptionInfo option : bundle.options) {
                                 Apttus_CPQApi.CPQ.SelectedOptionDO optionDO = new Apttus_CPQApi.CPQ.SelectedOptionDO();

                                 optionDO.ComponentId = option.componentId;
                                 optionDO.ComponentProductId = option.productSO.Id;
                                 optionDO.Quantity = 1;
                                 optionDO.SellingTerm = 1;
                                 // add the option to the bundle
                                 bundleDO.SelectedOptions.add(optionDO);

              }                                        

              request.SelectedBundle = bundleDO;
                      System.debug('!!.. .. REQUEST ' + request);
              // add a bundle to the cart
              Apttus_CPQApi.CPQ.AddBundleResponseDO result = Apttus_CPQApi.CPQWebService.addBundle(request);
              System.debug(result);
              System.debug('!!.. .. LineNumber=' + result.LineNumber);
              lineNumber = result.LineNumber;
              lineItemsToUpdate.add(bundle.lineItemSO);
            }
                        
        Apttus_Config2.ConstraintWebService2.ConstraintResult2 res = Apttus_Config2.ConstraintWebService2.applyConstraintRulesOnAddAll(base.getConfigSO().Id);
      
        markLineItemsPricingToPending(lineItemsToUpdate);
        
        PageReference pg;
        
        if(callerPage != null) {            
            pg = new PageReference( getVFPageUrlPrefix() + '/Apttus_Config2__pricing');
        
            pg.getParameters().put('id', configSO.Id);
            pg.getParameters().put('configRequestId', configRequestId);
        } else {
            pg = base.getCatalogPage();
        }
        
        return pg;
    }
        
    /**
     * Gets the guided interview step sobject
     * @return the guided interview step sobject
     */
    private Apttus_Config2__SearchAttributeValue__c getInterviewStepSO() {
        
        if (interviewStepSO == null) {
            // get the interview sobject
            ID interviewId = getInterviewId();
            system.debug('!!.. ..getInterviewStepSO ' + interviewId);
            List<Apttus_Config2__SearchAttributeValue__c> interviews = [SELECT Id, InterviewStep__c
                                                                        FROM Apttus_Config2__SearchAttributeValue__c
                                                                        WHERE Id = :interviewId
                                                                        LIMIT 1];
                                    
            interviewStepSO = (!interviews.isEmpty() ? interviews[0] : null);
            
        }
       
        return interviewStepSO;
       
    }
    
    /**
     * Sets the current step
     * @param currStep the current step
     */
    private void setCurrentStep(Step currStep) {
        // update the interview step
        system.debug('!!.. ..setCurrentStep ' +  currStep);
        // set interview step
        Apttus_Config2__SearchAttributeValue__c interviewStepSO = getInterviewStepSO();
        if (Step.BUNDLE == currStep) {
            // bundle step
            interviewStepSO.InterviewStep__c = STEP_BUNDLE;
        
        } else if (Step.OPTION == currStep) {
            // option step
            interviewStepSO.InterviewStep__c = STEP_OPTION;
        } else if (Step.RESULT == currStep) {
            // update step
            interviewStepSO.InterviewStep__c = STEP_RESULT;
        } else {
            // done
            interviewStepSO.InterviewStep__c = STEP_BUNDLE;
            
        }
        
        update interviewStepSO;
        
    }
    
    
    /**
     * Wrapper class for holding bundles
     */
    public class BundleInfo {

        // state
        
        // product sobject
        public Product2 productSO {get; private set;}
        // image source
        public String imageSrc {get; private set;}
        // image style
        public String imageSizeStyle {get; private set;}
        // line item sobject
        public Apttus_Config2__LineItem__c lineItemSO {get; private set;}
        // option components
        public List<OptionInfo> options {get; private set;} 
        
        public Boolean isSelected {get; set;}
        
        /**
         * Class Constructor specifying initial values
         * @param productSO the product sobject
         */
        public BundleInfo(Product2 productSO) {
                system.debug('!!.. ..BundleInfo');
            this.productSO = productSO;
            // create a new line item
            this.lineItemSO = new Apttus_Config2__LineItem__c(Apttus_Config2__ProductId__c = ProductSO.Id,
                                                              Apttus_Config2__Quantity__c = 1,
                                                              Apttus_Config2__SellingTerm__c = 1);
            
            // image source
            this.imageSrc = '';
            
            // create containers
            this.options = new List<OptionInfo>();
            
        }
        
        /**
         * Gets the Icon size in CSS style
         * @return the icon style
         */
        public String getIconStyleCSS() {
            
            if (imageSizeStyle == null) {
                imageSizeStyle = '';
                
            }
            
            return imageSizeStyle;
            
        }
        
        /**
         * whether to display the select button
         */
        public boolean getIsShowSelect() {
            return (!productSO.Apttus_Config2__Customizable__c && 
                    !productSO.Apttus_Config2__HasSearchAttributes__c);  
                    
        }
        
        /**
         * whether to display the configure button
         */
        public Boolean getIsShowConfigure() {
            return ((productSO.Apttus_Config2__HasOptions__c || productSO.Apttus_Config2__HasAttributes__c) && 
                    !productSO.Apttus_Config2__HasSearchAttributes__c);  
                    
        }
        
        /**
         * Add the given list of option components to the bundle
         * @param components the list of option componen sobjects to add
         */
        public void addOptions(List<Apttus_Config2__ProductOptionComponent__c> components) {
            
            System.debug('!!.. .. flow option components for '+productSO.Name+' = '+components);
            
            // add each option to the collection
            for (Apttus_Config2__ProductOptionComponent__c componentSO : components) {
                options.add(new optionInfo(componentSO));
                
            }
            
        }
        
    }
    
    /**
     * Wrapper class for holding options
     */
    public class OptionInfo {

        // state
        
        // product sobject
        public Product2 productSO {get; private set;}
        // option component id
        public ID componentId {get; private set;}
        
        /**
         * Class Constructor specifying initial values
         * @param componentSO the option component sobject
         */
        public OptionInfo(Apttus_Config2__ProductOptionComponent__c componentSO) {
            // create a new product sobject
            this.productSO = new Product2(Id = componentSO.Apttus_Config2__ComponentProductId__c, 
                                          Name = componentSO.Apttus_Config2__ComponentProductId__r.Name,
                                          Description = componentSO.Apttus_Config2__ComponentProductId__r.Description,
                                          Family = componentSO.Apttus_Config2__ComponentProductId__r.Family,
                                          ProductCode = componentSO.Apttus_Config2__ComponentProductId__r.ProductCode,
                                          Apttus_Config2__Uom__c = componentSO.Apttus_Config2__ComponentProductId__r.Apttus_Config2__Uom__c);
                                          
            this.componentId = componentSO.Id;
            
        }
        
    }
    
    public PageReference redirectToCallerPage() {
        PageReference pg;
        
        if(callerPage != null) {
            pg = new PageReference( getVFPageUrlPrefix() + '/' + callerPage);
        
            pg.getParameters().put('id', configSO.Id);
            pg.getParameters().put('configRequestId', configRequestId);
        } else {
            pg = base.getCatalogPage();
        }
        
        pg.setRedirect(true);
        
        return pg;
    }
    
    private void markLineItemsPricingToPending(List<Apttus_Config2__LineItem__c> lineItems) {
        for(Apttus_Config2__LineItem__c lineItem : lineItems) {
            lineItem.Apttus_Config2__PricingStatus__c = 'Pending';
        }
    }

    private static String getVFPageUrlPrefix() {
        if(UserInfo.getUserType() == 'Partner' || UserInfo.getUserType() == 'PowerPartner') {
            return '/prm';
        } else {
            return '/apex';
        }
    }    
}