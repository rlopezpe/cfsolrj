component hint="facade or cc.rolando.validation.JavaObjectTypeValidator" accessors="true"{
	property name="javaValidator" type="any" setter="false" getter="true" hint="cc.rolando.validation.JavaObjectTypeValidator";

	public JavaTypeValidator function init(required any javaValidator){
		local.javaClassName = 'cc.rolando.validation.JavaObjectTypeValidator';
		if(!arguments.javaValidator.getClass().getCanonicalName() == local.javaClassName)
			throw("Argument javaValidator of type '#arguments.javaValidator.getClass().getCanonicalName()#' is not of type '#local.javaClassName#'");

		variables.javaValidator = arguments.javaValidator;
		return this;
	}
	/**
	 * @param obj
	 * @param dataType
	 * @param debug
	 * @param throwOnMismatch
	 * @return boolean
	 * @throws TypeMissmatch
	 * @throws ClassNotFoundException
	 **/
	public boolean function isOfType(required any obj, required String dataType, boolean debug=false){
		return getJavaValidator().isOfType(arguments.obj, "#arguments.dataType#", javaCast("boolean",arguments.debug));

	}

	/**
	 * @param obj
	 * @param dataType
	 * @param debug
	 * @return boolean
	 * @throws TypeMissmatch
	 * @throws ClassNotFoundException
	 */
	public void function validate(required any obj, required String dataType, boolean debug=false){
		getJavaValidator().validate(arguments.obj, javaCast("string",trim(arguments.dataType)), javaCast("boolean",arguments.debug));
	}

	/**
	 * 
	 */
	public boolean function isNull(any obj){
		if(structKeyExists(arguments,"obj")){
			return getJavaValidator().isNull(arguments.obj);
		}else{
			return true;
		}
	}
}