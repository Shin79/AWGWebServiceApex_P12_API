
@isTest
private class AXGContactsTest {
    static Id createTestContact() {
        Contact contact = new Contact(
            LastName = 'Test',
            FirstName = 'Contact',
            Email = 'exemple@exemple.com',
            Phone = '0102030405'
        );
        insert contact;
        return contact.Id;
    }
    @isTest static void createContactTest() {
        //Call the method to test
        Id thisContactId = AXGContacts.createAXGContact('Test', 'Contact', 'exemple@exemple.com', '0102030405');
        //Verify the test
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id, Email FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals('exemple@exemple.com', thisContact.Email);
    }

    //Test to update contact with info from AXG
    @isTest static void updateContactTest() {
        //Create a record of contact to test
        Id thisContactId = createTestContact();
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://resilient-fox-adkxlj-dev-ed.my.salesforce.com/services/apexrest/Contacts/'+thisContactId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"email": "email.update@exemple.com"}');
        RestContext.request = request;
        //Update contact of existing contact
        Contact contactUpdate = AXGContacts.updateAXGContact();

        //Verify contact was update
        System.assert(contactUpdate != null);
        Contact thisContact = [SELECT Email FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals('email.update@exemple.com', thisContact.Email);
    }

    //Test to unactive contact after delete from AXG
    @isTest static void deleteContactTest() {
        //Create a record of contact to test
        Id thisContactId = createTestContact();
        //Instantiate request
        RestRequest request = new RestRequest();
        request.requestURI = 'https://resilient-fox-adkxlj-dev-ed.my.salesforce.com/services/apexrest/Contacts/'+thisContactId;
        request.httpMethod = 'GET';
        RestContext.request = request;
        //Disable contact
        AXGContacts.deleteAXGContact();

        //Verify the contact is disable and NOT delete
        Contact thisContact = [SELECT Active__c FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals(false, thisContact.Active__c);
    }
}
