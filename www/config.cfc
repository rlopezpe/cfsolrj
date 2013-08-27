<!--- ****************************************************
This file was autogenerated by EnvironmentConfig on: {ts '2013-07-23 00:17:10'}

Copyright 2007 Rolando Lopez (www.rolando-lopez.com) 
Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except 
in compliance with the License.You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0 
Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, 
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
See the License for the specific language governing permissions and limitations under the License. 
***************************************************** --->

<cfcomponent displayname="Config" hint="Application properties bean" output="false">
	<cfproperty name="isDev" type="boolean" required="false" default=""  />
	<cfproperty name="versionNumber" type="string" required="false" default=""  />
	<cfproperty name="lastmodified" type="string" required="false" default=""  />
	<cfproperty name="dsn" type="string" required="false" default=""  />
	<cfproperty name="cfLogPath" type="string" required="false" default=""  />
	<cfproperty name="revision" type="string" required="false" default=""  />
	<cfproperty name="siteRootPath" type="string" required="false" default=""  />
	<cfproperty name="libPath" type="string" required="false" default=""  />
	<cfproperty name="enableDebugOutput" type="boolean" required="false" default=""  />
	<cfproperty name="javaJarPaths" type="struct" required="false" default=""  />
	<cfproperty name="environmentID" type="string" required="false" default=""  />

		<!---
		*************************************************************************
		init()
		************************************************************************
		--->
	<cffunction name="init" returntype="Config" output="false" hint="I initialize the bean">
		<cfargument name="isDev" type="boolean" required="false" default=""  />
		<cfargument name="versionNumber" type="string" required="false" default=""  />
		<cfargument name="lastmodified" type="string" required="false" default=""  />
		<cfargument name="dsn" type="string" required="false" default=""  />
		<cfargument name="cfLogPath" type="string" required="false" default=""  />
		<cfargument name="revision" type="string" required="false" default=""  />
		<cfargument name="siteRootPath" type="string" required="false" default=""  />
		<cfargument name="libPath" type="string" required="false" default=""  />
		<cfargument name="enableDebugOutput" type="boolean" required="false" default=""  />
		<cfargument name="javaJarPaths" type="struct" required="false" default=""  />
		<cfargument name="environmentID" type="string" required="false" default=""  />

			<!--- initialize variables --->
		<cfscript>
			setIsDev(arguments.isDev);
			setVersionNumber(arguments.versionNumber);
			setLastmodified(arguments.lastmodified);
			setDsn(arguments.dsn);
			setCfLogPath(arguments.cfLogPath);
			setRevision(arguments.revision);
			setSiteRootPath(arguments.siteRootPath);
			setLibPath(arguments.libPath);
			setEnableDebugOutput(arguments.enableDebugOutput);
			setJavaJarPaths(arguments.javaJarPaths);
			setEnvironmentID(arguments.environmentID);
		</cfscript>
		<cfreturn this />
	</cffunction>
		<!--- setters --->

		<!--- setIsDev(boolean) --->
	<cffunction name="setIsDev" access="private" returntype="void" hint="I set isDev variable" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset variables.inst.isDev = arguments.value />
	</cffunction>

		<!--- getIsDev() --->
	<cffunction name="getIsDev" access="public" returntype="boolean" hint="I get isDev variable" output="false">
		<cfreturn variables.inst.isDev  />
	</cffunction>

		<!--- setVersionNumber(string) --->
	<cffunction name="setVersionNumber" access="private" returntype="void" hint="I set versionNumber variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.inst.versionNumber = arguments.value />
	</cffunction>

		<!--- getVersionNumber() --->
	<cffunction name="getVersionNumber" access="public" returntype="string" hint="I get versionNumber variable" output="false">
		<cfreturn variables.inst.versionNumber  />
	</cffunction>

		<!--- setLastmodified(string) --->
	<cffunction name="setLastmodified" access="private" returntype="void" hint="I set lastmodified variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.inst.lastmodified = arguments.value />
	</cffunction>

		<!--- getLastmodified() --->
	<cffunction name="getLastmodified" access="public" returntype="string" hint="I get lastmodified variable" output="false">
		<cfreturn variables.inst.lastmodified  />
	</cffunction>

		<!--- setDsn(string) --->
	<cffunction name="setDsn" access="private" returntype="void" hint="I set dsn variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.inst.dsn = arguments.value />
	</cffunction>

		<!--- getDsn() --->
	<cffunction name="getDsn" access="public" returntype="string" hint="I get dsn variable" output="false">
		<cfreturn variables.inst.dsn  />
	</cffunction>

		<!--- setCfLogPath(string) --->
	<cffunction name="setCfLogPath" access="private" returntype="void" hint="I set cfLogPath variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.inst.cfLogPath = arguments.value />
	</cffunction>

		<!--- getCfLogPath() --->
	<cffunction name="getCfLogPath" access="public" returntype="string" hint="I get cfLogPath variable" output="false">
		<cfreturn variables.inst.cfLogPath  />
	</cffunction>

		<!--- setRevision(string) --->
	<cffunction name="setRevision" access="private" returntype="void" hint="I set revision variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.inst.revision = arguments.value />
	</cffunction>

		<!--- getRevision() --->
	<cffunction name="getRevision" access="public" returntype="string" hint="I get revision variable" output="false">
		<cfreturn variables.inst.revision  />
	</cffunction>

		<!--- setSiteRootPath(string) --->
	<cffunction name="setSiteRootPath" access="private" returntype="void" hint="I set siteRootPath variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.inst.siteRootPath = arguments.value />
	</cffunction>

		<!--- getSiteRootPath() --->
	<cffunction name="getSiteRootPath" access="public" returntype="string" hint="I get siteRootPath variable" output="false">
		<cfreturn variables.inst.siteRootPath  />
	</cffunction>

		<!--- setLibPath(string) --->
	<cffunction name="setLibPath" access="private" returntype="void" hint="I set libPath variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.inst.libPath = arguments.value />
	</cffunction>

		<!--- getLibPath() --->
	<cffunction name="getLibPath" access="public" returntype="string" hint="I get libPath variable" output="false">
		<cfreturn variables.inst.libPath  />
	</cffunction>

		<!--- setEnableDebugOutput(boolean) --->
	<cffunction name="setEnableDebugOutput" access="private" returntype="void" hint="I set enableDebugOutput variable" output="false">
		<cfargument name="value" type="boolean" required="true" />
		<cfset variables.inst.enableDebugOutput = arguments.value />
	</cffunction>

		<!--- getEnableDebugOutput() --->
	<cffunction name="getEnableDebugOutput" access="public" returntype="boolean" hint="I get enableDebugOutput variable" output="false">
		<cfreturn variables.inst.enableDebugOutput  />
	</cffunction>

		<!--- setJavaJarPaths(struct) --->
	<cffunction name="setJavaJarPaths" access="private" returntype="void" hint="I set javaJarPaths variable" output="false">
		<cfargument name="value" type="struct" required="true" />
		<cfset variables.inst.javaJarPaths = arguments.value />
	</cffunction>

		<!--- getJavaJarPaths() --->
	<cffunction name="getJavaJarPaths" access="public" returntype="struct" hint="I get javaJarPaths variable" output="false">
		<cfreturn variables.inst.javaJarPaths  />
	</cffunction>

		<!--- setEnvironmentID(string) --->
	<cffunction name="setEnvironmentID" access="private" returntype="void" hint="I set environmentID variable" output="false">
		<cfargument name="value" type="string" required="true" />
		<cfset variables.inst.environmentID = arguments.value />
	</cffunction>

		<!--- getEnvironmentID() --->
	<cffunction name="getEnvironmentID" access="public" returntype="string" hint="I get environmentID variable" output="false">
		<cfreturn variables.inst.environmentID  />
	</cffunction>

		<!--- getMemento() --->
	<cffunction name="getMemento" access="public" returntype="struct" hint="I get Memento" output="false">
		<cfreturn variables.inst />
	</cffunction>
</cfcomponent>
