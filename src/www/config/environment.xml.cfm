<?xml version="1.0" encoding="UTF-8"?>
<environments>
	<default>
        <config>
				<!-- *default vars* -->
				<!-- EC default configuration -->
			<property name="EC"> 
				<map>
					<entry key="bCreateBeanFile"><value>true</value></entry>
					<entry key="bCreateColdSpringFile"><value>false</value></entry>
					<entry key="bUseFlattenedStruct"><value>false</value></entry>
					<entry key="sConfigBeanObjPath"><value>cc.rolando.Config</value></entry>
					<entry key="sColdSpringDefFilePath"><value>/config/GlobalConfigColdspring.xml.cfm</value></entry>
					<entry key="sECDefinitionFilePath"><value>/config/environment.xml.cfm</value></entry>
					<entry key="bEmbedECIntoProperties"><value>false</value></entry>
				</map>
			</property>
			
				<!-- for ANT script -->
			<property name="buildNo">@buildNo@</property>
			<property name="lastmodified">@modified@</property>
			<property name="versionNumber">@version@</property>
			<property name="gitCommit">@gitCommit@</property>
			<property name="gitBranch">@gitBranch@</property>
			
				<!-- Absolute Paths -->
			<property name="cfLogPath">#server.coldfusion.rootdir#/logs</property>
			<property name="siteRootPath">#replace(expandPath('/'),'\','/',"all")#</property>
			<property name="libPath">#replace(expandPath('/devLib'),'\','/',"all")#</property>
			<property name="solrLib">c:/_dev/apps/solr-4.5.0/src/solr/dist</property>
			

			<property name="isDev">false</property>
			<property name="recordsPerIndex">500</property>
			
				<!-- URL paths -->
			<property name="solrServiceUrl">http://localhost:8983/solr/sakila</property>
			<!-- <property name="solrServiceUrl">http://localhost:8985/solr/sakila</property> -->
			<!-- <property name="solrServiceUrl">http://localhost:8985/solr/sakila_simple</property> -->
			<property name="javaJarPaths">
            	<map>
            		<entry key="urlValidatorPath"><value>${libPath}/url-validator-1.4.jar</value></entry>
            		<entry key="heroUtilities"><value>${libPath}/hero-utilities.jar</value></entry>
            		<entry key="heroUtilities"><value>${libPath}/utilities.jar</value></entry>
            		<entry key="apacheTika"><value>${libPath}/tika-app-1.2.jar</value></entry>
            		<entry key="solrSearcher"><value>${libPath}/solr-searcher.jar</value></entry>
            		<!-- <entry key="solrJ"><value>#Server.ColdFusion.rootdir#/lib/apache-solr-solrj.jar</value></entry> -->
					<entry key="commons-io"><value>${solrLib}/solrj-lib/commons-io-2.1.jar</value></entry>
					<entry key="httpclient"><value>${solrLib}/solrj-lib/httpclient-4.2.3.jar</value></entry>
					<entry key="httpcore"><value>${solrLib}/solrj-lib/httpcore-4.2.2.jar</value></entry>
					<entry key="httpmime-"><value>${solrLib}/solrj-lib/httpmime-4.2.3.jar</value></entry>
					<entry key="jcl-over-slf"><value>${solrLib}/solrj-lib/jcl-over-slf4j-1.6.6.jar</value></entry>
					<entry key="jul-to-slf"><value>${solrLib}/solrj-lib/jul-to-slf4j-1.6.6.jar</value></entry>
					<entry key="log"><value>${solrLib}/solrj-lib/log4j-1.2.16.jar</value></entry>
					<entry key="noggit"><value>${solrLib}/solrj-lib/noggit-0.5.jar</value></entry>
					<entry key="slf4j-api"><value>${solrLib}/solrj-lib/slf4j-api-1.6.6.jar</value></entry>
					<entry key="slf4j-log4j12"><value>${solrLib}/solrj-lib/slf4j-log4j12-1.6.6.jar</value></entry>
					<entry key="wstx-asl"><value>${solrLib}/solrj-lib/wstx-asl-3.2.7.jar</value></entry>
					<entry key="zookeeper"><value>${solrLib}/solrj-lib/zookeeper-3.4.5.jar</value></entry>
					<entry key="solr-core"><value>${solrLib}/solr-core-4.5.1-SNAPSHOT.jar</value></entry>
					<entry key="solr-solrj"><value>${solrLib}/solr-solrj-4.5.1-SNAPSHOT.jar</value></entry>
					<entry key="cfcDynamicProxy"><value>${libPath}/JavaLoader/javaloader/support/cfcdynamicproxy/lib/cfcdynamicproxy.jar</value></entry>
            	</map>
            </property>
        </config>
	</default>
	
		<!-- local environment -->
	<environment id="local">
        <patterns>
            <pattern>^.*.local</pattern>
            <pattern>^localhost</pattern>
        </patterns>
        <config>
			<property name="dsn">ticketmob_admin</property>
			<property name="enableDebugOutput">true</property>

			<property name="isDev">true</property>
		</config>
	</environment>

		<!-- Dev-->
	<environment id="dev">
        <patterns>
            <pattern>^.*.dev</pattern>
        </patterns>
        <config>
			<property name="isDev">true</property>
			<property name="enableDebugOutput">true</property>
		</config>
	</environment>
	
		<!-- staging -->
	<environment id="staging">
        <patterns>
            <pattern>^.*\.staging</pattern>
        </patterns>
        <config>
			<property name="enableDebugOutput">true</property>
			<property name="isDev">false</property>
			<property name="dsn"></property>
        </config>
	</environment>

		<!-- production -->
	<environment id="production">
        <patterns>
            <pattern>.*</pattern>
        </patterns>
        <config>
        	<property name="isDev">false</property>
        	<property name="dsn">ticketmob_admin</property>
        	<property name="enableDebugOutput">false</property>
        </config>
	</environment>
</environments>		