component implements="I_IndexDAO"{
	

/* 	public query function getPendingDocumentData(required numeric documentId, numeric projectId ){

	}
 */	
	public query function getData(){
		var qData = new query(datasource="sakila");
		var sql 	= "Select *
						FROM film";
		qData.setSql(local.sql);
		var rs = qData.execute().getResult();
		return rs;
	}

	public numeric function getTotalRecordsToImport(){

	}
}