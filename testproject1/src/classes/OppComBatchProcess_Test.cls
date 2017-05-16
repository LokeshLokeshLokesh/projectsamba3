/*****************************************************************************************************************************************
 * Orange id        :   
 * created on       :   22/11/2016
 * Purpose          :   test class for handler - OppComBatchProcess
 *                      
 * Created By       :   Vaibhav Goel
 * Last ModifiedBy  :   
 * Last Modified On :   
 * 
*******************************************************************************************************************************************/
@isTest
private class OppComBatchProcess_Test {
    
    public static Profile p;
    public static User u;
    public static Account acc;
    
    
    
    //test1
    public static Profile p1;
    public static User u1;
    public static Account acc1;
    public static List<opportunity> opp;
    public static List<Competitor__c> compList;
    public static List<OpportunityCompetitor> stdCompList;
    
    @IsTest(seeAllData=false)
    static void testBatchMethod() {
        p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        u = TestDataCreation.createtestuser(p);
        //createUserTestData();
        
        System.runAs(u){
            SMB_Competitor_validation.runBeforeInsert = false;
            SMB_Competitor_validation.runAfterInsert = false;
            SMB_Competitor_validation.runBeforeUpdate = false;
            SMB_Competitor_validation.runAfterUpdate = false;
            createTestData();
            Test.startTest();
                OppComBatchProcess bat = new OppComBatchProcess();
                Database.executeBatch(bat, 149);
            Test.stopTest();
            stdCompList = new list<OpportunityCompetitor>();
            stdCompList = [SELECT CompetitorName, Id, OpportunityId, Strengths, Weaknesses
                            FROM OpportunityCompetitor where OpportunityId = :Opp[0].id];
            System.assertEquals(149,stdCompList.size());
            
        }
        
            
    }
    
    private static void createTestData(){
        opp = new list<opportunity>();
        compList = new list<Competitor__c>();
        TestDataCreation.createSplitcommission(1, 'Commission');
        TestDataCreation.createSplitcommission(1, 'Finance');
        acc = TestDataCreation.createAccounts(1)[0];
        opp = TestDataCreation.createOpportunitiesWithAccount(1,acc.id);
        update Opp[0];
    
        for(Integer i = 0; i < 149; i ++){
            Competitor__c comObj = new Competitor__c();
            comObj.SMB_OPCOM_Competitor_Name__c = 'test' + i;
            comObj.SMB_OPCOM_Strengths__c = 'testStrength' + i;
            comObj.SMB_OPCOM_Weaknesses__c = 'testWeakeness' + i;
            comObj.Opportunity__c = Opp[0].id;
            if(i == 0){
                comObj.SMB_OPCOM_Primary__c=true;    
            }else{
                comObj.SMB_OPCOM_Primary__c = false;    
            }
            
            compList.add(comObj);
        }
        
        try{
            insert compList;
            system.debug('----compList----' + compList);
            system.debug('----compList----' + compList.size());
        }
        catch(Exception e){
            system.debug('----Exception----' + e);
        }
        
                                                
    }
}