@isTest
private class AXGContractsTest {
    static String createAccountId(){
        Account account = new Account(Name='Compte test');
        insert account;
        return account.Id;
    }

    static Id createTestContract(String account){
        Contract contract = new Contract(
            AccountId = account,
            Status = 'Draft',
            ContractTerm = 10
        );
        insert contract;
        return contract.Id;
    }
    @isTest static void createContractTest(){
        String account = createAccountId();
        Id thisContractId = AXGContracts.createAXGContract(account,'Draft',10);
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT AccountId FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals(account, thisContract.AccountId);
    }
    @isTest static void updateContractTest(){
        //Create a record of contract to test and his account
        String account = createAccountId();
        Id thisContractId = createTestContract(account);
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://resilient-fox-adkxlj-dev-ed.my.salesforce.com/services/apexrest/Contracts/'+thisContractId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"status": "Activated"}');
        RestContext.request = request;
        //Update contact of existing contact
        AXGContracts.updateAXGContract();

        //Verify contact was update
        Contract thisContract = [SELECT Status FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals('Activated', thisContract.Status);
    }
}
