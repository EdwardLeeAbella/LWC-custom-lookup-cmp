public with sharing class LookupController {

    @AuraEnabled(cacheable=true)
    public static List<sObject> lookUp(String searchTerm, String objectName, String filters, String recordId, String fields, boolean respectSharing) {
        Integer limitNum = 20;
        List<sObject> lookUpList = new List<sObject>();
        String finalQuery = 'SELECT ' + fields + ' FROM ' + objectName;

        if(String.isBlank(recordId)){
            if(String.isNotBlank(searchTerm)){
                finalQuery += ' WHERE Name Like  \'%' + searchTerm + '%\' ';
            }
            
            if(String.isNotBlank(filters)){
                finalQuery += String.isNotBlank(searchTerm) ? ' AND ' : ' WHERE ';
                finalQuery += filters;
            }
        }else{
            finalQuery += ' WHERE Id =  \'' + recordId + '\'';
        }

        finalQuery+= ' LIMIT ' + limitNum;

        System.debug('Final Query::::' + finalQuery);
        
        if(respectSharing == true){
            lookUpList = database.query(finalQuery);
            return lookUpList;  
        }else{
            lookUpList = NoSharingHelperClass.lookUp(finalQuery);
            return lookUpList;  
        }
    }
}