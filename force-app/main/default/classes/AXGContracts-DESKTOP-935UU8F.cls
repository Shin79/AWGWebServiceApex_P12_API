// Classe Web Service pour les contrats

// Utilisation de l'annotation @RestResource pour exposer la classe Apex en tant que ressource REST
@RestResource(urlMapping='/Contracts/*')

global with sharing class AXGContracts {
    // Création des contrats
    @HttpPost
    global static Id createAXGContract(String account, String status,String contractTerm) {
        Integer contractTermInt = Integer.valueOf(contractTerm);
        // Nouvelle instance de contrat
        Contract thisContract = new Contract(AccountId=account,Status=status,ContractTerm=contractTermInt);
        insert thisContract;
        return thisContract.Id;
    }
    // Mise à jour des contrats
    @HttpPatch
    global static void updateAXGContract(){
        // On utilise la propriété request de la classe RestContext
        RestRequest request = RestContext.request;
        // On récupère l'ID du contrat dans l'URI
        String contractId = request.requestURI.substring(request.requestURI.lastIndexOf('/') + 1);
        // On requête pour avoir l'ID correspondant à l'ID demandé précédemment 
        Contract thisContract = [SELECT Id FROM Contract WHERE Id=:contractId];
        // On désérialise le string JSON en map(paire clé/valeur)
        Map<String,Object> params = (Map<String,Object>)JSON.deserializeUntyped(request.requestbody.toString());
        // On itère sur chaque clé pour modifier les valeurs de champs à modifier
        for(String fieldName : params.keySet()){
            thisContract.put(fieldName,params.get(fieldName));
        }
        update thisContract;
    }
}
