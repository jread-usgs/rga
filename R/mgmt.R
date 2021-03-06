.extend.rga.mgmt <- function() {
	rga$methods(
		list(
			processManagementData = function(url, keep) {
				ga.json <- fromJSON(getURL(url));
				
				if (is.null(ga.json)) { stop('data fetching did not output correct format'); }
				
				# build data frame
				# get observation with the most columns (this will define the data frame):
				max <- ga.json$items[sapply(ga.json$items, length) == max(sapply(ga.json$items, length))][1];
				n <- names(as.data.frame(do.call(rbind, max)));

				df <- as.data.frame(do.call(rbind, lapply(lapply(ga.json$items, unlist), "[", unique(unlist(c(sapply(ga.json$items,names)))))))
				names(df) <- n;
				
				return(df[keep]);
			},
			getAccounts = function(start=1, max=1000) {
				url <- paste('https://www.googleapis.com/analytics/v3/management/accounts',
	            		 	 '?access_token=', .self$getToken()$access_token,
							 '&start-index=', start,
							 '&max-results=', max,
							 sep='', collapse='');
				return(.self$processManagementData(url, c('id', 'name', 'created', 'updated')));
			},
			getWebProperties = function(accountId='~all', start=1, max=1000) {
				url <- paste('https://www.googleapis.com/analytics/v3/management/accounts/', accountId ,'/webproperties',
	            		 	 '?access_token=', .self$getToken()$access_token,
							 '&start-index=', start,
							 '&max-results=', max,
							 sep='', collapse='');
				return(.self$processManagementData(url, c('id', 'name', 'websiteUrl', 'created', 'updated')));
			},
			getProfiles = function(accountId='~all', webPropertyId='~all', start=1, max=1000) {
				url <- paste('https://www.googleapis.com/analytics/v3/management/accounts/', accountId, '/webproperties/', webPropertyId , '/profiles',
	            		 	 '?access_token=', .self$getToken()$access_token,
							 '&start-index=', start,
							 '&max-results=', max,
							 sep='', collapse='');
				# possible deparse.error, sapply(test$items,length)
				return(.self$processManagementData(url, c('id', 'accountId', 'webPropertyId', 'name', 'currency', 'timezone', 'eCommerceTracking', 'websiteUrl', 'created', 'updated')));
			},
			getGoals = function(accountId = '~all', webPropertyId = '~all', profileId = '~all', start=1, max=1000) { # FIX: deparse error
				url <- paste('https://www.googleapis.com/analytics/v3/management/accounts/', accountId, '/webproperties/', webPropertyId , '/profiles/', profileId, '/goals',
	            		 	 '?access_token=', .self$getToken()$access_token,
							 '&start-index=', start,
							 '&max-results=', max,
							 sep='', collapse='');
				return(.self$processManagementData(url, c('id', 'accountId', 'webPropertyId', 'profileId', 'name', 'value', 'active', 'type', 'created', 'updated')));
			},
			getSegments = function(start=1, max=1000) {
				url <- paste('https://www.googleapis.com/analytics/v3/management/segments',
	            		 	 '?access_token=', .self$getToken()$access_token,
							 '&start-index=', start,
							 '&max-results=', max,
							 sep='', collapse='');
				return(.self$processManagementData(url, c('id', 'segmentId', 'name', 'definition', 'created', 'updated')));
			}
		)
	);
}