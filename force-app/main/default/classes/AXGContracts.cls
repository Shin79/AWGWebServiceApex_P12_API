// Classe Web Service pour les contrats
@RestResource(urlMapping='/Contracts/*')

global with sharing class AXGContracts {
    // Création des contrats
    @HttpPost
    global static Id createAXGContract(String account, String status,Integer contractTerm) {
        Contract thisContract = new Contract(AccountId=account,Status=status,ContractTerm=contractTerm);
        insert thisContract;
        return thisContract.Id;
    }
    // Mise à jour des contrats
    @HttpPatch
    global static Contract updateAXGContract(){
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id=:contractId];
        // On désérialise le string JSON en map(paire clé/valeur)
        Map<String,Object> params = (Map<String,Object>)JSON.deserializeUntyped(request.requestbody.toString());
        // On itère sur chaque clé
        for(String fieldName : params.keySet()){
            thisContract.put(fieldName,params.get(fieldName));
        }
        update thisContract;
        return thisContract;
    }
}
