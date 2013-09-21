component implements="I_IndexDAO"{
	

/* 	public query function getPendingDocumentData(required numeric documentId, numeric projectId ){

	}
 */	
	public query function getData(){
		var qData = new query(datasource="sakila");
		var sql 	= "SELECT film_id
								, title
								, description
								, release_year
								, language_id
								, original_language_id
								, rental_duration
								, rental_rate
								, length
								, replacement_cost
								, rating
								, special_features
								, last_update
							FROM film";
		qData.setSql(local.sql);
		var rs = qData.execute().getResult();
		return rs;
	}

	public query function getActors_alldata(){
		var qActors = cagheGet("qActors_alldata");

		if(isNull(local.qActors)){
			var sql = "SELECT a.actor_id
								, a.first_name
								, a.last_name
								, fa.film_id
								, f.title 
						FROM actor a 
								INNER JOIN film_actor fa 
									ON a.actor_id = fa.actor_id 
								INNER JOIN film f 
									ON f.film_id = fa.film_id";
		}
	}

	public query function getActors(){
		var rs = cacheget("qActors");

		if(isNull(local.qActors)){
			var qActors = new query(datasource="sakila");
			var sql = "SELECT a.actor_id
								, a.first_name
								, a.last_name
								, concat(a.first_name, ' ', a.last_name) full_name
								, fa.film_id
						FROM actor a 
								INNER JOIN film_actor fa 
									ON a.actor_id = fa.actor_id 
									order by a.actor_id asc
											,a.first_name asc
											,a.last_name asc";
			local.qActors.setSql(sql);
			local.rs = qActors.execute().getResult();
			cacheput("qActors", local.rs);
		}

		return local.rs;
	}

	public query function getFilmActors(required numeric filmId){
		var qActors = getActors();
		var qFilmActors = new query(dbType="query");
		local.qFilmActors.setAttributes(sourceQuery=local.qActors);
		return local.qFilmActors.execute(sql="Select actor_id, full_name, film_id FROM sourceQuery WHERE film_id=#arguments.filmId#").getResult();

	}
	public numeric function getTotalRecordsToImport(){

	}
}