(function(root){
/**
 * @namespace HaveAPI
 * @author Jakub Skokan <jakub.skokan@vpsfree.cz>
 */


/********************************************************************************/
/*******************************  HAVEAPI.CLIENT  *******************************/
/********************************************************************************/


root.HaveAPI = {
	/**
	 * Create a new client for the API.
	 * @class Client
	 * @memberof HaveAPI
	 * @param {string} url base URL to the API
	 * @param {Object} opts
	 */
	Client: function(url, opts) {
		this.url = url;
		
		while (this.url.length > 0) {
			if (this.url[ this.url.length - 1 ] == '/')
				this.url = this.url.substr(0, this.url.length - 1);
			
			else break;
		}
		
		this.http = new root.HaveAPI.Client.Http();
		this.version = (opts !== undefined && opts.version !== undefined) ? opts.version : null;
		
		/**
		 * @member {Object} HaveAPI.Client#description Description received from the API.
		 */
		this.description = null;
		
		/**
		 * @member {Array} HaveAPI.Client#resources A list of top-level resources attached to the client.
		 */
		this.resources = [];
		
		/**
		 * @member {Object} HaveAPI.Client#authProvider Selected authentication provider.
		 */
		this.authProvider = new root.HaveAPI.Client.Authentication.Base();
	}
};

var c = root.HaveAPI.Client;

/** @constant HaveAPI.Client.Version */
c.Version = '0.4.0-dev';

/**
 * @callback HaveAPI.Client~doneCallback
 * @param {HaveAPI.Client} client
 * @param {Boolean} status true if the task was successful
 */

/**
 * @callback HaveAPI.Client~replyCallback
 * @param {HaveAPI.Client} client
 * @param {HaveAPI.Client.Response} response
 */

/**
 * @callback HaveAPI.Client~versionsCallback
 * @param {HaveAPI.Client} client
 * @param {Boolean} status
 * @param {Object} versions
 */

/**
 * Setup resources and actions as properties and functions.
 * @method HaveAPI.Client#setup
 * @param {HaveAPI.Client~doneCallback} callback
 */
c.prototype.setup = function(callback) {
	var that = this;
	
	this.fetchDescription(function(status, response) {
		that.description = response.response;
		that.attachResources();
		
		callback(that, true);
	});
};

/**
 * Provide the description and setup the client without asking the API.
 * @method HaveAPI.Client#useDescription
 * @param {Object} description
 */
c.prototype.useDescription = function(description) {
	this.description = description;
	this.attachResources();
};

/**
 * Call a callback with an object with list of available versions
 * and the default one.
 * @method HaveAPI.Client#availableVersions
 * @param {HaveAPI.Client~versionsCallback} callback
 */
c.prototype.availableVersions = function(callback) {
	var that = this;
	
	this.http.request({
		method: 'OPTIONS',
		url: this.url + '/?describe=versions',
		callback: function(status, response) {
			var r = new root.HaveAPI.Client.Response(null, response);
			var ok = r.isOk();
			
			callback(that, ok, ok ? r.response() : r.message());
		}
	});
};

/**
 * Fetch the description from the API.
 * @method HaveAPI.Client#fetchDescription
 * @private
 * @param {HaveAPI.Client.Http~replyCallback} callback
 */
c.prototype.fetchDescription = function(callback) {
	this.http.request({
		method: 'OPTIONS',
		url: this.url + (this.version ? "/v"+ this.version +"/" : "/?describe=default"),
		callback: callback
	});
};

/**
 * Attach API resources from the description to the client.
 * @method HaveAPI.Client#attachResources
 * @private
 */
c.prototype.attachResources = function() {
	// Detach existing resources
	if (this.resources.length > 0) {
		this.destroyResources();
	}
	
	for(var r in this.description.resources) {
		console.log("Attach resource", r);
		this.resources.push(r);
		
		this[r] = new root.HaveAPI.Client.Resource(this, r, this.description.resources[r], []);
	}
};

/**
 * Authenticate using selected authentication method.
 * It is possible to avoid calling {@link HaveAPI.Client#setup} before authenticate completely,
 * when it's certain that the client will be used only after it is authenticated. The client
 * will be then set up more efficiently.
 * @method HaveAPI.Client#authenticate
 * @param {string} method name of authentication provider
 * @param {Object} opts a hash of options that is passed to the authentication provider
 * @param {HaveAPI.Client~doneCallback} callback called when the authentication is finished
 * @param {Boolean} reset if false, the client will not be set up again, defaults to true
 */
c.prototype.authenticate = function(method, opts, callback, reset) {
	var that = this;
	
	if (reset === undefined) reset = true;
	
	if (!this.description) {
		// The client has not yet been setup.
		// Fetch the description, do NOT attach the resources, use it only to authenticate.
		
		this.fetchDescription(function(status, response) {
			that.description = response.response;
			that.authenticate(method, opts, callback);
		});
		
		return;
	}
	
	this.authProvider = new c.Authentication.providers[method](this, opts, this.description.authentication[method]);
	
	this.authProvider.setup(function() {
		// Fetch new description, which may be different when authenticated
		if (reset)
			that.setup(callback);
		else
			callback(that, true);
	});
};

/**
 * Logout, destroy the authentication provider.
 * {@link HaveAPI.Client#setup} must be called if you want to use
 * the client again.
 * @method HaveAPI.Client#logout
 * @param {HaveAPI.Client~doneCallback} callback
 */
c.prototype.logout = function(callback) {
	var that = this;
	
	this.authProvider.logout(function() {
		that.authProvider = new root.HaveAPI.Client.Authentication.Base();
		that.destroyResources();
		that.description = null;
		
		if (callback !== undefined)
			callback(that, true);
	});
};

/**
 * Always calls the callback with {@link HaveAPI.Client.Response} object. It does
 * not interpret the response.
 * @method HaveAPI.Client#directInvoke
 * @param {HaveAPI.Client~replyCallback} callback
 */
c.prototype.directInvoke = function(action, params, callback) {
	console.log("executing", action, "with params", params, "at", action.preparedUrl);
	var that = this;
	
	var opts = {
		method: action.httpMethod(),
		url: this.url + action.preparedUrl,
		credentials: this.authProvider.credentials(),
		headers: this.authProvider.headers(),
		queryParameters: this.authProvider.queryParameters(),
		callback: function(status, response) {
			if(callback !== undefined) {
				callback(that, new root.HaveAPI.Client.Response(action, response));
			}
		}
	}
	
	var paramsInQuery = this.sendAsQueryParams(opts.method);
	
	if (paramsInQuery) {
		opts.url = this.addParamsToQuery(opts.url, action.namespace('input'), params);
		
	} else {
		var scopedParams = {};
		scopedParams[ action.namespace('input') ] = params;
		
		opts.params = scopedParams;
	}
	
	this.http.request(opts);
};

/**
 * The response is interpreted and if the layout is object or object_list, ResourceInstance
 * or ResourceInstanceList is returned with the callback.
 * @method HaveAPI.Client#invoke
 * @param {HaveAPI.Client~replyCallback} callback
 */
c.prototype.invoke = function(action, params, callback) {
	var that = this;
	
	this.directInvoke(action, params, function(status, response) {
		if (callback === undefined)
			return;
		
		switch (action.layout('output')) {
			case 'object':
				callback(that, new root.HaveAPI.Client.ResourceInstance(that, action, response));
				break;
				
			case 'object_list':
				callback(that, new root.HaveAPI.Client.ResourceInstanceList(that, action, response));
				break;
			
			default:
				callback(that, response);
		}
	});
};

/**
 * Detach resources from the client.
 * @method HaveAPI.Client#destroyResources
 * @private
 */
c.prototype.destroyResources = function() {
	while (this.resources.length < 0) {
		delete this[ that.resources.shift() ];
	}
};

/**
 * Return true if the parameters should be sent as a query parameters,
 * which is the case for GET and OPTIONS methods.
 * @method HaveAPI.Client#sendAsQueryParams
 * @param {String} method HTTP method
 * @return {Boolean}
 * @private
 */
c.prototype.sendAsQueryParams = function(method) {
	return ['GET', 'OPTIONS'].indexOf(method) != -1;
};

/**
 * Add URL encoded parameters to URL.
 * Note that this method does not support object_list or hash_list layouts.
 * @method HaveAPI.Client#addParamsToQuery
 * @param {String} url
 * @param {String} namespace
 * @param {Object} params
 * @private
 */
c.prototype.addParamsToQuery = function(url, namespace, params) {
	var first = true;
	
	for (var key in params) {
		if (first) {
			if (url.indexOf('?') == -1)
				url += '?';
				
			else if (url[ url.length - 1 ] != '&')
				url += '&';
			
			first = false;
			
		} else url += '&';
		
		url += encodeURI(namespace) + '[' + encodeURI(key) + ']=' + encodeURI(params[key]);
	}
	
	return url;
};


/********************************************************************************/
/*************************  HAVEAPI.HTTP.CLIENT  ********************************/
/********************************************************************************/


/**
 * @class Http
 * @memberof HaveAPI.Client
 */
var http = c.Http = function() {};

/**
 * @callback HaveAPI.Client.Http~replyCallback
 * @param {Integer} status received HTTP status code
 * @param {Object} response received response
 */

/**
 * @method HaveAPI.Client.Http#request
 */
http.prototype.request = function(opts) {
	console.log("request to " + opts.method + " " + opts.url);
	var r = new XMLHttpRequest();
	
	if (opts.credentials === undefined)
		r.open(opts.method, opts.url);
	else
		r.open(opts.method, opts.url, true, opts.credentials.username, opts.credentials.password);
	
	for (var h in opts.headers) {
		r.setRequestHeader(h, opts.headers[h]);
	}
	
	if (opts.params !== undefined)
		r.setRequestHeader('Content-Type', 'application/json; charset=utf-8');
	
	r.onreadystatechange = function() {
		var state = r.readyState;
		console.log('state is ' + state);
		
		if (state == 4 && opts.callback !== undefined) {
			opts.callback(r.status, JSON.parse(r.responseText));
		}
	};
	
	if (opts.params !== undefined) {
		r.send(JSON.stringify( opts.params ));
		
	} else {
		r.send();
	}
};


/********************************************************************************/
/*********************  HAVEAPI.CLIENT.AUTHENTICATION  **************************/
/********************************************************************************/


/**
 * @namespace Authentication
 * @memberof HaveAPI.Client
 */
c.Authentication = {
	/**
	 * @member {Array} providers An array of registered authentication providers.
	 * @memberof HaveAPI.Client.Authentication
	 */
	providers: {},
	
	/**
	 * Register authentication providers using this function.
	 * @func registerProvider
	 * @memberof HaveAPI.Client.Authentication
	 * @param {string} name must be the same name as in announced by the API
	 * @param {Object} provider class
	 */
	registerProvider: function(name, obj) {
		c.Authentication.providers[name] = obj;
	}
};


/********************************************************************************/
/*******************  HAVEAPI.CLIENT.AUTHENTICATION.BASE  ***********************/
/********************************************************************************/


/**
 * @class Base
 * @classdesc Base class for all authentication providers. They do not have to inherit
 *            it directly, but must implement all necessary methods.
 * @memberof HaveAPI.Client.Authentication
 */
var base = c.Authentication.Base = function(client, opts, description){};

/**
 * Setup the authentication provider and call the callback.
 * @method HaveAPI.Client.Authentication.Base#setup
 * @param {HaveAPI.Client~doneCallback} callback
 */
base.prototype.setup = function(callback){};

/**
 * Logout, destroy all resources and call the callback.
 * @method HaveAPI.Client.Authentication.Base#logout
 * @param {HaveAPI.Client~doneCallback} callback
 */
base.prototype.logout = function(callback) {
	callback(this.client, true);
};

/**
 * Returns an object with keys 'user' and 'password' that are used
 * for HTTP basic auth.
 * @method HaveAPI.Client.Authentication.Base#credentials
 * @return {Object} credentials
 */
base.prototype.credentials = function(){};

/**
 * Returns an object with HTTP headers to be sent with the request.
 * @method HaveAPI.Client.Authentication.Base#headers
 * @return {Object} HTTP headers
 */
base.prototype.headers = function(){};

/**
 * Returns an object with query parameters to be sent with the request.
 * @method HaveAPI.Client.Authentication.Base#queryParameters
 * @return {Object} query parameters
 */
base.prototype.queryParameters = function(){};


/********************************************************************************/
/******************  HAVEAPI.CLIENT.AUTHENTICATION.BASIC  ***********************/
/********************************************************************************/


/**
 * @class Basic
 * @classdesc Authentication provider for HTTP basic auth.
 *            Unfortunately, this provider probably won't work in most browsers
 *            because of their security considerations.
 * @memberof HaveAPI.Client.Authentication
 */
var basic = c.Authentication.Basic = function(client, opts, description) {
	this.client = client;
	this.opts = opts;
};
basic.prototype = new base();

/**
 * @method HaveAPI.Client.Authentication.Basic#setup
 * @param {HaveAPI.Client~doneCallback} callback
 */
basic.prototype.setup = function(callback) {
	if(callback !== undefined)
		callback(this.client, true);
};

/**
 * Returns an object with keys 'user' and 'password' that are used
 * for HTTP basic auth.
 * @method HaveAPI.Client.Authentication.Basic#credentials
 * @return {Object} credentials
 */
basic.prototype.credentials = function() {
	return this.opts;
};


/********************************************************************************/
/*******************  HAVEAPI.CLIENT.AUTHENTICATION.TOKEN  **********************/
/********************************************************************************/


/**
 * @class Token
 * @classdesc Token authentication provider.
 * @memberof HaveAPI.Client.Authentication
 */
var token = c.Authentication.Token = function(client, opts, description) {
	this.client = client;
	this.opts = opts;
	this.description = description;
	this.configured = false;
	
	/**
	 * @member {String} HaveAPI.Client.Authentication.Token#token The token received from the API.
	 */
	this.token = null;
};
token.prototype = new base();

/**
 * @method HaveAPI.Client.Authentication.Token#setup
 * @param {HaveAPI.Client~doneCallback} callback
 */
token.prototype.setup = function(callback) {
	if (this.opts.hasOwnProperty('token')) {
		this.token = this.opts.token;
		this.configured = true;
		
		if(callback !== undefined)
			callback(this.client, true);
	
	} else {
		this.requestToken(callback);
	}
};

/**
 * @method HaveAPI.Client.Authentication.Token#requestToken
 * @param {HaveAPI.Client~doneCallback} callback
 */
token.prototype.requestToken = function(callback) {
	this.resource = new root.HaveAPI.Client.Resource(this.client, 'token', this.description.resources.token, []);
	
	var params = {
		login: this.opts.username,
		password: this.opts.password,
		lifetime: this.opts.lifetime || 'renewable_auto'
	};
	
	if(this.opts.interval !== undefined)
		params.interval = this.opts.interval;
	
	var that = this;
	
	this.resource.request(params, function(c, response) {
		if (response.isOk()) {
			var t = response.response();
			
			that.token = t.token;
			that.validTo = t.valid_to;
			that.configured = true;
			
			if(callback !== undefined)
				callback(that.client, true);
			
		} else {
			if(callback !== undefined)
				callback(that.client, false);
		}
	});
};

/**
 * @method HaveAPI.Client.Authentication.Token#headers
 */
token.prototype.headers = function(){
	if(!this.configured)
		return;
	
	var ret = {};
	ret[ this.description.http_header ] = this.token;
	
	return ret;
};

/**
 * @method HaveAPI.Client.Authentication.Token#logout
 * @param {HaveAPI.Client~doneCallback} callback
 */
token.prototype.logout = function(callback) {
	this.resource.revoke(null, function(c, reply) {
		callback(this.client, reply.isOk());
	});
};


/********************************************************************************/
/***************  HAVEAPI.CLIENT.AUTHENTICATION REGISTRATION  *******************/
/********************************************************************************/


// Register built-in providers
c.Authentication.registerProvider('basic', basic);
c.Authentication.registerProvider('token', token);


/********************************************************************************/
/**********************  HAVEAPI.CLIENT.BASERESOURCE  ***************************/
/********************************************************************************/


/**
 * @class BaseResource
 * @classdesc Base class for {@link HaveAPI.Client.Resource}
 * and {@link HaveAPI.Client.ResourceInstance}. Implements shared methods.
 * @memberof HaveAPI.Client
 */
var br = c.BaseResource = function(){};

/**
 * Attach child resources as properties.
 * @method HaveAPI.Client.BaseResource#attachResources
 * @protected
 * @param {Object} description
 * @param {Array} args
 */
br.prototype.attachResources = function(description, args) {
	this.resources = [];
	
	for(var r in description.resources) {
		this.resources.push(r);
		
		this[r] = new root.HaveAPI.Client.Resource(this.client, r, description.resources[r], args);
	}
};

/**
 * Attach child actions as properties.
 * @method HaveAPI.Client.BaseResource#attachActions
 * @protected
 * @param {Object} description
 * @param {Array} args
 */
br.prototype.attachActions = function(description, args) {
	this.actions = [];
	
	for(var a in description.actions) {
		var names = [a].concat(description.actions[a].aliases);
		var actionInstance = new root.HaveAPI.Client.Action(this.client, this, a, description.actions[a], args);
		
		for(var i = 0; i < names.length; i++) {
			if (names[i] == 'new')
				continue;
			
			this.actions.push(names[i]);
			this[names[i]] = actionInstance;
		}
	}
};

/**
 * Return default parameters that are to be sent to the API.
 * Default parameters are overriden by supplied parameters.
 * @method HaveAPI.Client.BaseResource#defaultParams
 * @protected
 * @param {HaveAPI.Client.Action} action
 */
br.prototype.defaultParams = function(action) {
	return {};
};


/********************************************************************************/
/************************  HAVEAPI.CLIENT.RESOURCE  *****************************/
/********************************************************************************/


/**
 * @class Resource
 * @memberof HaveAPI.Client
 */
var r = c.Resource = function(client, name, description, args){
	this.client = client;
	this.name = name;
	this.description = description;
	this.args = args;
	
	this.attachResources(description, args);
	this.attachActions(description, args);
	
	var that = this;
	var fn = function() {
		return new c.Resource(that.client, that.name, that.description, that.args.concat(Array.prototype.slice.call(arguments)));
	};
	fn.__proto__ = this;
	
	return fn;
};

r.prototype = new c.BaseResource();

// Unused
r.prototype.applyArguments = function(args) {
	for(var i = 0; i < args.length; i++) {
		this.args.push(args[i]);
	}
	
	return this;
};

/**
 * Return a new, empty resource instance.
 * @method HaveAPI.Client.Resource#new
 * @return {HaveAPI.Client.ResourceInstance} resource instance
 */
r.prototype.new = function() {
	return new root.HaveAPI.Client.ResourceInstance(this.client, this.create, null, false);
};


/********************************************************************************/
/*************************  HAVEAPI.CLIENT.ACTION  ******************************/
/********************************************************************************/


/**
 * @class Action
 * @memberof HaveAPI.Client
 */
var a = c.Action = function(client, resource, name, description, args) {
	console.log("Attach action", name, "to", resource.name);
	
	this.client = client;
	this.resource = resource;
	this.name = name;
	this.description = description;
	this.args = args;
	this.providedIdArgs = [];
	this.preparedUrl = null;
	
	var that = this;
	var fn = function() {
		var new_a = new c.Action(that.client, that.resource, that.name, that.description, that.args.concat(Array.prototype.slice.call(arguments)));
		return new_a.invoke();
	};
	fn.__proto__ = this;
	
	return fn;
};

/**
 * Returns action's HTTP method.
 * @method HaveAPI.Client.Action#httpMethod
 * @return {String}
 */
a.prototype.httpMethod = function() {
	return this.description.method;
};

/**
 * Returns action's namespace.
 * @method HaveAPI.Client.Action#namespace
 * @param {String} direction input/output
 * @return {String}
 */
a.prototype.namespace = function(direction) {
	return this.description[direction].namespace;
};

/**
 * Returns action's layout.
 * @method HaveAPI.Client.Action#layout
 * @param {String} direction input/output
 * @return {String}
 */
a.prototype.layout = function(direction) {
	return this.description[direction].layout;
};

/**
 * Set action URL. This method should be used to set fully resolved
 * URL.
 * @method HaveAPI.Client.Action#provideUrl
 */
a.prototype.provideUrl = function(url) {
	this.preparedUrl = url;
};

/**
 * Invoke the action.
 * This method has a variable number of arguments. Arguments are first applied
 * as object IDs in action URL. When there are no more URL parameters to fill,
 * the second last argument is an Object containing parameters to be sent.
 * The last argument is a {@link HaveAPI.Client~replyCallback} callback function.
 * 
 * The argument with parameters may be omitted, if the callback function
 * is in its place.
 * 
 * Arguments do not have to be passed to this method specifically. They may
 * be given to the resources above, the only thing that matters is their correct
 * order.
 * 
 * @example
 * // Call with parameters and a callback.
 * // The first argument '1' is a VPS ID.
 * api.vps.ip_address.list(1, {limit: 5}, function(c, reply) {
 * 		console.log("Got", reply.response());
 * });
 * 
 * @example
 * // Call only with a callback. 
 * api.vps.ip_address.list(1, function(c, reply) {
 * 		console.log("Got", reply.response());
 * });
 * 
 * @example
 * // Give parameters to resources.
 * api.vps(101).ip_address(33).delete();
 * 
 * @method HaveAPI.Client.Action#invoke
 */
a.prototype.invoke = function() {
	var prep = this.prepareInvoke(arguments);
	
	this.client.invoke(this, prep.params, prep.callback);
};

/**
 * Same use as {@link HaveAPI.Client.Action#invoke}, except that the callback
 * is always given a {@link HaveAPI.Client.Response} object.
 * @see HaveAPI.Client#directInvoke
 * @method HaveAPI.Client.Action#directInvoke
 */
a.prototype.directInvoke = function() {
	var prep = this.prepareInvoke(arguments);
	
	this.client.directInvoke(this, prep.params, prep.callback);
};

/**
 * Prepare action invocation.
 * @method HaveAPI.Client.Action#prepareInvoke
 * @private
 * @return {Object}
 */
a.prototype.prepareInvoke = function(arguments) {
	var args = this.args.concat(Array.prototype.slice.call(arguments));
	var rx = /(:[a-zA-Z\-_]+)/;
	
	if (!this.preparedUrl)
		this.preparedUrl = this.description.url;
	
	while (args.length > 0) {
		if (this.preparedUrl.search(rx) == -1)
			break;
		
		var arg = args.shift();
		this.providedIdArgs.push(arg);
	
		this.preparedUrl = this.preparedUrl.replace(rx, arg);
	}
	
	if (args.length == 0 && this.preparedUrl.search(rx) != -1) {
		throw {
			name:    'UnresolvedArguments',
			message: "Unable to execute action '"+ this.name +"': unresolved arguments"
		}
	}
	
	var that = this;
	var hasParams = args.length > 0;
	var isFn = hasParams && args.length == 1 && typeof(args[0]) == "function";
	var params = hasParams && !isFn ? args[0] : null;
	
	if (this.layout('input') == 'object') {
		var defaults = this.resource.defaultParams(this);
		
		for (var param in this.description.input.parameters) {
			if ( defaults.hasOwnProperty(param) && (!params || (params && !params.hasOwnProperty(param))) ) {
				if (!params)
					params = {};
				
				params[ param ] = defaults[ param ];
			}
		}
	}
	
	return {
		params: params,
		callback: function(c, response) {
			that.preparedUrl = null;
			
			if (args.length > 1) {
				args[1](c, response);
				
			} else if(isFn) {
				args[0](c, response);
			}
		}
	}
};


/********************************************************************************/
/************************  HAVEAPI.CLIENT.RESPONSE  *****************************/
/********************************************************************************/


/**
 * @class Response
 * @memberof HaveAPI.Client
 */
var r = c.Response = function(action, response) {
	this.action = action;
	this.envelope = response;
};

/**
 * Returns true if the request was successful.
 * @method HaveAPI.Client.Response#isOk
 * @return {Boolean}
 */
r.prototype.isOk = function() {
	return this.envelope.status;
};

/**
 * Returns the namespaced response if possible.
 * @method HaveAPI.Client.Response#response
 * @return {Object} response
 */
r.prototype.response = function() {
	if(!this.action)
		return this.envelope.response;
	
	switch (this.action.layout('output')) {
		case 'object':
		case 'object_list':
		case 'hash':
		case 'hash_list':
			return this.envelope.response[ this.action.namespace('output') ];
		
		default:
			return this.envelope.response;
	}
};

/**
 * Return the error message received from the API.
 * @method HaveAPI.Client.Response#message
 * @return {String}
 */
r.prototype.message = function() {
	return this.envelope.message;
};


/********************************************************************************/
/********************  HAVEAPI.CLIENT.RESOURCEINSTANCE  *************************/
/********************************************************************************/


/**
 * @class ResourceInstance
 * @classdesc Represents an instance of a resource from the API. Attributes
 *            are accessible as properties. Associations are directly accessible.
 * @param {HaveAPI.Client}          client
 * @param {HaveAPI.Client.Action}   action    Action that created this instance.
 * @param {HaveAPI.Client.Response} response  If not provided, the instance is either
 *                                            not resoved or not persistent.
 * @param {Boolean}                 shell     If true, the resource is just a shell,
 *                                            it is to be fetched from the API. Used
 *                                            when accessed as an association from another
 *                                            resource instance.
 * @param {Boolean}                 item      When true, this object was returned in a list,
 *                                            therefore response is not a Response instance,
 *                                            but just an object with parameters.
 * @memberof HaveAPI.Client
 */
var i = c.ResourceInstance = function(client, action, response, shell, item) {
	this.client = client;
	this.action = action;
	this.response = response;
	
	if (!response) {
		if (shell !== undefined && shell) { // association that is to be fetched
			this.resolved = false;
			this.persistent = true;
			
			var that = this;
			
			action.directInvoke(function(c, response) {
				that.attachResources(that.action.resource.description, action.providedIdArgs);
				that.attachActions(that.action.resource.description, action.providedIdArgs);
				that.attachAttributes(item ? response : response.response());
				
				that.resolved = true;
				
				if (that.resolveCallbacks !== undefined) {
					for (var i = 0; i < that.resolveCallbacks.length; i++)
						that.resolveCallbacks[i](that.client, that);
					
					delete that.resolveCallbacks;
				}
			});
			
		} else { // a new, empty instance
			this.resolved = true;
			this.persistent = false;
			
			this.attachResources(this.action.resource.description, action.providedIdArgs);
			this.attachActions(this.action.resource.description, action.providedIdArgs);
			this.attachStubAttributes();
		}
		
	} else if (item || response.isOk()) {
		this.resolved = true;
		this.persistent = true;
		
		this.attachResources(this.action.resource.description, action.providedIdArgs);
		this.attachActions(this.action.resource.description, action.providedIdArgs);
		this.attachAttributes(item ? response : response.response());
		
	} else {
		// FIXME
	}
};

i.prototype = new c.BaseResource();

/**
 * @callback HaveAPI.Client.ResourceInstance~resolveCallback
 * @param {HaveAPI.Client} client
 * @param {HaveAPI.Client.ResourceInstance} resource
 */

/**
 * A shortcut to {@link HaveAPI.Client.Response#isOk}.
 * @method HaveAPI.Client.ResourceInstance#isOk
 * @return {Boolean}
 */
i.prototype.isOk = function() {
	return this.response.isOk();
};

/**
 * Return the response that this instance is created from.
 * @method HaveAPI.Client.ResourceInstance#apiResponse
 * @return {HaveAPI.Client.Response}
 */
i.prototype.apiResponse = function() {
	return this.response;
};

/**
 * Save the instance. It calls either an update or a create action,
 * depending on whether the object is persistent or not.
 * @method HaveAPI.Client.ResourceInstance#save
 * @param {HaveAPI.Client~replyCallback} callback
 */
i.prototype.save = function(callback) {
	var that = this;
	
	function updateAttrs(attrs) {
		for (var attr in attrs) {
			that.attributes[ attr ] = attrs[ attr ];
		}
	};
	
	function replyCallback(c, reply) {
		that.response = reply;
		updateAttrs(reply);
		
		if (callback !== undefined)
			callback(c, that);
	}
	
	if (this.persistent) {
		this.update.directInvoke(replyCallback);
		
	} else {
		this.create.directInvoke(function(c, reply) {
			if (reply.isOk())
				that.persistent = true;
			
			replyCallback(c, reply);
		});
	}
};

i.prototype.defaultParams = function(action) {
	ret = {}
	
	for (var attr in this.attributes) {
		var desc = action.description.input.parameters[ attr ];
		
		if (desc === undefined)
			continue;
		
		switch (desc.type) {
			case 'Resource':
				ret[ attr ] = this.attributes[ attr ][ desc.value_id ];
				break;
			
			default:
				ret[ attr ] = this.attributes[ attr ];
		}
	}
	
	return ret;
};

/**
 * Resolve an associated resource.
 * A shell {@link HaveAPI.Client.ResourceInstance} instance is created
 * and is fetched asynchronously.
 * @method HaveAPI.Client.ResourceInstance#resolveAssociation
 * @private
 * @return {HaveAPI.Client.ResourceInstance}
 */
i.prototype.resolveAssociation = function(path, url) {
	var tmp = this.client;
	
	for(var i = 0; i < path.length; i++) {
		tmp = tmp[ path[i] ];
	}
	
	var action = tmp.show;
	action.provideUrl(url);
	
	return new root.HaveAPI.Client.ResourceInstance(this.client, action, null, true);
};

/**
 * Register a callback that will be called then this instance will
 * be fully resolved (fetched from the API).
 * @method HaveAPI.Client.ResourceInstance#whenResolved
 * @param {HaveAPI.Client.ResourceInstance~resolveCallback} callback
 */
i.prototype.whenResolved = function(callback) {
	if (this.resolved)
		callback(this.client, this);
	
	else {
		if (this.resolveCallbacks === undefined)
			this.resolveCallbacks = [];
		
		this.resolveCallbacks.push(callback);
	}
};

/**
 * Attach all attributes as properties.
 * @method HaveAPI.Client.ResourceInstance#attachAttributes
 * @private
 * @param {Object} attrs
 */
i.prototype.attachAttributes = function(attrs) {
	this.attributes = attrs;
	this.associations = {};
	
	for (var attr in attrs) {
		this.createAttribute(attr, this.action.description.output.parameters[ attr ]);
	}
};

/**
 * Attach all attributes as null properties. Used when creating a new, empty instance.
 * @method HaveAPI.Client.ResourceInstance#attachStubAttributes
 * @private
 */
i.prototype.attachStubAttributes = function() {
	var attrs = {};
	var params = this.action.description.input.parameters;
	
	for (var attr in params) {
		switch (params[ attr ].type) {
			case 'Resource':
				attrs[ attr ] = {};
				attrs[ attr ][ params[attr].value_id ] = null;
				attrs[ attr ][ params[attr].value_label ] = null;
				break;
			
			default:
				attrs[ attr ] = null;
		}
	}
	
	this.attachAttributes(attrs);
};

/**
 * Define getters and setters for an attribute.
 * @method HaveAPI.Client.ResourceInstance#createhAttribute
 * @private
 * @param {String} attr
 * @param {Object} desc
 */
i.prototype.createAttribute = function(attr, desc) {
	var that = this;
	
	switch (desc.type) {
		case 'Resource':
			Object.defineProperty(this, attr, {
				get: function() {
						if (that.associations.hasOwnProperty(attr))
							return that.associations[ attr ];
						
						return this.associations[ attr ] = that.resolveAssociation(desc.resource, that.attributes[ attr ].url);
					},
				set: function(v) {
						that.attributes[ attr ][ desc.value_id ]    = v.id;
						that.attributes[ attr ][ desc.value_label ] = v[ desc.value_label ];
					}
			});
			
			Object.defineProperty(this, attr + '_id', {
				get: function()  { return that.attributes[ attr ][ desc.value_id ];  },
				set: function(v) { that.attributes[ attr ][ desc.value_id ] = v;     }
			});
			
			break;
		
		default:
			Object.defineProperty(this, attr, {
				get: function()  { return that.attributes[ attr ];  },
				set: function(v) { that.attributes[ attr ] = v;     }
			});
	}
};


/********************************************************************************/
/******************  HAVEAPI.CLIENT.RESOURCEINSTANCELIST  ***********************/
/********************************************************************************/

/**
 * Arguments are the same as for {@link HaveAPI.Client.ResourceInstance}.
 * @class ResourceInstanceList
 * @classdesc Represents a list of {@link HaveAPI.Client.ResourceInstance} objects.
 * @see {@link HaveAPI.Client.ResourceInstance}
 * @memberof HaveAPI.Client
 */
var l = c.ResourceInstanceList = function(client, action, response) {
	this.response = response;
	
	/**
	 * @member {Array} HaveAPI.Client.ResourceInstanceList#items An array containg all items.
	 */
	this.items = [];
	
	var ret = response.response();
	
	/**
	 * @member {integer} HaveAPI.Client.ResourceInstanceList#length Number of items in the list.
	 */
	this.length = ret.length;
	
	for (var i = 0; i < this.length; i++)
		this.items.push(new root.HaveAPI.Client.ResourceInstance(client, action, ret[i], false, true));
};

/**
 * @callback HaveAPI.Client.ResourceInstanceList~iteratorCallback
 * @param {HaveAPI.Client.ResourceInstance} object
 */

/**
 * A shortcut to {@link HaveAPI.Client.Response#isOk}.
 * @method HaveAPI.Client.ResourceInstanceList#isOk
 * @return {Boolean}
 */
l.prototype.isOk = function() {
	return this.response.isOk();
};

/**
 * Return the response that this instance is created from.
 * @method HaveAPI.Client.ResourceInstanceList#apiResponse
 * @return {HaveAPI.Client.Response}
 */
l.prototype.apiResponse = function() {
	return this.response;
};

/**
 * Call fn for every item in the list.
 * @param {HaveAPI.Client.ResourceInstanceList~iteratorCallback} fn
 * @method HaveAPI.Client.ResourceInstanceList#each
 */
l.prototype.each = function(fn) {
	for (var i = 0; i < this.length; i++)
		fn( this.items[ i ] );
};

/**
 * Return item at index.
 * @method HaveAPI.Client.ResourceInstanceList#itemAt
 * @param {Integer} index
 * @return {HaveAPI.Client.ResourceInstance}
 */
l.prototype.itemAt = function(index) {
	return this.items[ index ];
};

/**
 * Return first item.
 * @method HaveAPI.Client.ResourceInstanceList#first
 * @return {HaveAPI.Client.ResourceInstance}
 */
l.prototype.first = function() {
	if (this.length == 0)
		return null;
	
	return this.items[0];
};

/**
 * Return last item.
 * @method HaveAPI.Client.ResourceInstanceList#last
 * @return {HaveAPI.Client.ResourceInstance}
 */
l.prototype.last = function() {
	if (this.length == 0)
		return null;
	
	return this.items[ this.length - 1 ]
};

})(window);