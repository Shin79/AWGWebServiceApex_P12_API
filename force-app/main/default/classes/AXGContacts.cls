// Classe Web Service pour les contacts

// Utilisation de l'annotation @RestResource pour exposer la classe Apex en tant que ressource REST
@RestResource(urlMapping='/Contacts/*')

global with sharing class AXGContacts {
    @HttpGet
    global static Contact getAXGContacts() {
        // On utilise la propriété request de la classe RestContext
        RestRequest request = RestContext.request;
        // On récupère l'ID du contact dans l'URI
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        // On requête pour avoir l'ID correspondant à l'ID demandé précédemment 
        Contact result =  [SELECT Id,Name,Email FROM Contact WHERE Id = :contactId];               
        return result;
    }
    // Création des contacts AXG
    @HttpPost
    global static ID createAXGContact(String lastName,String firstName,String email,String phone){
        // On requête pour vérifier si l'email existe déjà
        List<Contact> contacts =[SELECT Id FROM Contact WHERE Email=:email];
        // S'il existe déjà, on retourne l'id du contact
        if(contacts.size()!=0){
            return contacts[0].Id;
        // Sinon, on en crée un nouveau
        }else{
            Contact thisContact = new Contact();
            thisContact.LastName = lastName;
            thisContact.FirstName = firstName;
            thisContact.Email = email;
            thisContact.Phone = phone;
            
            insert thisContact;
            return thisContact.Id;
        }
    }
    // Mise à jour des contacts AXG
    @HttpPatch
    global static Contact updateAXGContact(){
        // On utilise la propriété request de la classe RestContext
        RestRequest request = RestContext.request;
        // On récupère l'ID du contrat dans l'URI
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        // On requête pour avoir l'ID correspondant à l'ID demandé précédemment 
        Contact thisContact = [SELECT Id FROM Contact WHERE Id=:contactId];
        // On désérialise le string JSON en map(paire clé/valeur)
        Map<String,Object> params = (Map<String,Object>)JSON.deserializeUntyped(request.requestbody.toString());
        // On itère sur chaque clé pour modifier les valeurs de champs à modifier
        for(String fieldName : params.keySet()){
            thisContact.put(fieldName,params.get(fieldName));
        }
        update thisContact;
        return thisContact;
    }

    // Suppression d'un contact
    @HttpDelete
    global static void deleteAXGContact(){
        RestRequest request = restContext.request;
        String contactId = request.requestURI.substring(request.requestURI.lastIndexOf('/')+1);
        // On requête sur l'Id et le champ personnalisé Active qui correspond à l'Id
        Contact thisContact = [SELECT Id,Active__c FROM Contact WHERE Id=:contactId];
        // On décoche la case à cocher Active
        thisContact.Active__c = false;
        update thisContact;
    }
}
