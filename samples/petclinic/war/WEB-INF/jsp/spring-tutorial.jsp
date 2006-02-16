<%@ include file="/WEB-INF/jsp/includes.jsp" %>
<%@ include file="/WEB-INF/jsp/header.jsp" %>

<h1 style="text-align: center;">The Spring PetClinic Application</h1>
<big><span style="font-weight: bold;">Updated : <br>
&nbsp;&nbsp;&nbsp; </span>01-DEC-2004 - Ken Krebs<span
 style="font-weight: bold;"><br>
</span>&nbsp;&nbsp;&nbsp; 16-AUG-2003</big><big> - Ken Krebs</big><br>
<br>
<h2>Introduction</h2>
Spring is a collection of small, well-focused, loosely coupled Java
frameworks that can be used independently or collectively to build
industrial strength applications of many different types. The PetClinic
sample application is designed to show how the Spring
application frameworks can be used to build simple, but powerful
database-oriented applications. It will demonstrate the use
of Spring's core functionality:<br>
<ul>
  <li>JavaBeans based application configuration using
Inversion-Of-Control<br>
  </li>
  <li>Model-View-Controller web Presentation Layer</li>
  <li>Practical database access through JDBC, Hibernate, or Apache OJB</li>
  <li>Declarative Transaction Management using AOP<br>
  </li>
  <li>Data Validation that supports but is not dependent on the
Presentation Layer</li>
</ul>
The Spring frameworks provide a great deal of useful infrastructure to
simplify the tasks faced by application developers. This infrastructure
helps developers to create applications that are :<br>
<ul>
  <li><span style="font-weight: bold; text-decoration: underline;">concise</span>
by handling a lot of the complex control flow that is needed to use the
Java API's, such as JDBC, JNDI, JTA, RMI, and EJB.</li>
  <li><span style="font-weight: bold; text-decoration: underline;">flexible</span>
by simplifying the process of external application configuration
through
the use of Reflection and JavaBeans. This allows the developer to
achieve a clean separation of configuration data from application code.
All application and web application objects, including validators,
workflow controllers, and views, are JavaBeans that can be configured
externally.</li>
  <li><span style="font-weight: bold; text-decoration: underline;">testable</span>
by supplying an interface based design to maximize pluggability. This
facilitates unit testing of Business Logic without requiring the
presence
of application or live database servers.</li>
  <li><span style="font-weight: bold; text-decoration: underline;">maintainable</span>
by facilitating a clean separation of the application layers. It most
importantly helps maintain the independence of the Business Layer
from the Presentation layer. PetClinic demonstrates the use of a
Model-View-Controller
based web presentation framework that can work seamlessly with many
different types of view technologies. The Spring web application
framework helps developers to implement their Presentation as a clean
and thin layer focused on its main missions of translating user actions
into application events and rendering model data.</li>
</ul>
It is assumed that users of this tutorial will have a basic knowledge
of object-oriented design, Java, Servlets, JSP, and relational
databases. It also assumes a basic knowledge of the use of a J2EE web
application container.<br>
<br>
Since the purpose of the sample application is tutorial in nature, the
implementation presented here will of course provide only a small
subset
of the functionality that would be needed by a real world version of a
PetClinic application.<br>
<br>
<h2>PetClinic Sample Application Requirements</h2>
The application requirement is for an information system that is
accessible through a web browser. The users of the application are
employees of the clinic who in the course of their work need to view
and
manage information regarding the veterinarians, the clients, and their
pets. The sample application supports the following:<br>
<br>
<span style="font-weight: bold;">Use Cases:</span><br>
<ul>
  <li>View a list of veterinarians and their specialties</li>
  <li>View information pertaining to a pet owner</li>
  <li>Update the information pertaining to a pet owner</li>
  <li>Add a new pet owner to the system</li>
  <li>View information pertaining to a pet</li>
  <li>Update the information pertaining to a pet</li>
  <li>Add a new pet to the system</li>
  <li>View information pertaining to a pet's visitation history</li>
  <li>Add information pertaining to a visit to the pet's visitation
history</li>
</ul>
<span style="font-weight: bold;">Business Rules:</span><br>
<ol>
  <li>An owner may not have multiple pets with the same
case-insensitive name.</li>
</ol>
<br>
<ul>
</ul>
<h2>PetClinic Sample Application Design &amp; Implementation</h2>
<span style="font-weight: bold; text-decoration: underline;">Server
Technology</span><br>
The sample application should be usable with any J2EE web application
container that is compatible with the Servet 2.3 and JSP 1.2
specifications. Some of the deployment files provided are designed
specifically for Apache Tomcat. These files specify container-supplied
connection-pooled data sources. It is not necessary to use these files.
The application has been configured by default to use a data source
without connection pooling to simplify usage. Configuration details are
provided in the Developer Instructions section. The view technologies
that are to be used for rendering the application are Java Server Pages
(JSP) along with the Java Standard Tag Library (JSTL).<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">Database
Technology</span><br>
The sample application uses a relational database for data storage.
Support has been provided for a choice of 1 of 2 database selections,
MySql or HypersonicSQL. HypersonicSQL version 1.7.2 is the default
choice and a copy is provided with the application. It is possible to
easily configure the application to use either database. Configuration
details are provided in the Developer Instructions section.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">Development
Environment</span><br>
A copy of the Spring runtime library jar file is provided with the
sample application along with some of the other required jar files. The
developer will need to obtain the following tools externally, all of
which are freely available:<br>
<ul>
  <li>Java SDK 1.4.x</li>
  <li>Ant 1.5.x</li>
  <li>Tomcat 4.1.x, or some other web application container</li>
  <li>JUnit 3.8.1 - needed to run the tests</li>
  <li>(Optional) MySQL 3.23.53 with MySQL Connector 3.x</li>
</ul>
<span style="font-weight: bold;">NOTE:</span> The version numbers
listed
are those that were used in the development of the PetClinic
application. Other versions of the same tools may or may not work.<br>
<br>
Download links for the various tools needed are provided in the
Developer Instructions section.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">PetClinic
Database</span><br>
The following is an overview of the database schema used in PetClinic.
Detailed field descriptions can be found in the <span
 style="font-weight: bold; font-style: italic;">"initDB.txt"</span> SQL
script
files in the database-specific "db" sub-directories. All "id" key
fields
are of Java type <span style="font-weight: bold; font-style: italic;">int</span>.<br>
<br>
TABLE: <span style="font-weight: bold; font-style: italic;">owners</span><br>
&nbsp;&nbsp;&nbsp; PRIMARY KEY <span style="font-weight: bold;">id<br>
<br>
</span>TABLE: <span style="font-weight: bold; font-style: italic;">types</span><br>
&nbsp;&nbsp;&nbsp; PRIMARY KEY <span style="font-weight: bold;">id</span><br>
<br>
TABLE: <span style="font-weight: bold; font-style: italic;">pets</span><br>
&nbsp;&nbsp;&nbsp; PRIMARY KEY <span style="font-weight: bold;">id</span><br>
&nbsp;&nbsp;&nbsp; FOREIGN KEY <span style="font-weight: bold;">type_id</span>
references the <span style="font-weight: bold; font-style: italic;">types</span>
table<span style="font-weight: bold;"> id </span>field<br>
&nbsp;&nbsp;&nbsp; FOREIGN KEY <span style="font-weight: bold;">owner_id</span>
references the <span style="font-weight: bold; font-style: italic;">owners</span>
table <span style="font-weight: bold;">id </span>field<br>
<br>
TABLE: <span style="font-weight: bold; font-style: italic;">vets</span><br>
&nbsp;&nbsp;&nbsp; PRIMARY KEY <span style="font-weight: bold;">id</span><br>
<br>
TABLE: <span style="font-weight: bold; font-style: italic;">specialties</span><br>
&nbsp;&nbsp;&nbsp; PRIMARY KEY <span style="font-weight: bold;">id</span><br
 style="font-weight: bold;">
<br>
TABLE: <span style="font-weight: bold; font-style: italic;">vet_specialties</span>-
a link table for <span style="font-weight: bold; font-style: italic;">vets</span>
and their <span style="font-weight: bold; font-style: italic;">specialties</span><br>
&nbsp;&nbsp;&nbsp; FOREIGN KEY <span style="font-weight: bold;">vet_id</span>
references the <span style="font-weight: bold; font-style: italic;">vets</span>
table<span style="font-weight: bold;"> id</span> field<br>
&nbsp;&nbsp;&nbsp; FOREIGN KEY <span style="font-weight: bold;">specialty_id</span>
references the <span style="font-weight: bold; font-style: italic;">specialties</span>
table <span style="font-weight: bold;">id </span>field<br>
<br>
TABLE: <span style="font-weight: bold; font-style: italic;">visits</span><br>
&nbsp;&nbsp;&nbsp; PRIMARY KEY <span style="font-weight: bold;">id</span><br>
&nbsp;&nbsp;&nbsp; FOREIGN KEY <span style="font-weight: bold;">pet_id</span>
references the <span style="font-weight: bold; font-style: italic;">pets
</span>table<span style="font-weight: bold;"> id </span>field<br>
<br>
<span style="font-weight: bold; text-decoration: underline;"></span><span
 style="font-weight: bold;"><br>
</span><span style="font-weight: bold;"></span><span
 style="font-weight: bold; text-decoration: underline;"></span><span
 style="font-weight: bold; text-decoration: underline;">Directory
Structure</span><br>
d-- indicates a directory holding source code, configuration files, etc.<br>
D-- indicates a directory that is created by the build script<br>
<br>
d-- <span style="font-weight: bold; font-style: italic;">petclinic </span>:
the root directory of the project contains build related files<br>
&nbsp;&nbsp;&nbsp; d-- <span
 style="font-weight: bold; font-style: italic;">src </span>: contains
Java source code files and ORM configuration files<br>
&nbsp;&nbsp;&nbsp; d-- <span
 style="font-weight: bold; font-style: italic;">war </span>: contains
the web application resource files<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; d-- <span
 style="font-weight: bold; font-style: italic;">html </span>: contains
tutorial files<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; D-- <span
 style="font-weight: bold; font-style: italic;">docs </span>: contains
Javadoc files<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; d-- <span
 style="font-weight: bold; font-style: italic;">web-inf </span>:
contains web application configuration files and application context
files<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
d-- <span style="font-weight: bold; font-style: italic;">jsp</span>:
contains Java Server Page files<br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
D--<span style="font-weight: bold;"> <span style="font-style: italic;">lib</span></span>:
contains application dependencies<br>
&nbsp;&nbsp;&nbsp; d-- <span
 style="font-weight: bold; font-style: italic;">test </span>: contains
testing related <span style="font-weight: bold; font-style: italic;"></span>
Java source code files<br>
&nbsp;&nbsp;&nbsp; d-- <span
 style="font-weight: bold; font-style: italic;">db </span>: contains
database sql scripts and other related files/directories<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; d-- <span
 style="font-weight: bold; font-style: italic;">hsqldb </span>:
contains files related to HSQL, contains scripts and a&nbsp;Tomcat
context definition file<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; d-- <span
 style="font-weight: bold; font-style: italic;">mysql </span>:
contains files related to MySQL, contains scripts and a Tomcat context
definition file<br>
&nbsp;&nbsp;&nbsp; D-- .<span
 style="font-weight: bold; font-style: italic;">classes </span>:
contains compiled Java class files<br>
&nbsp;&nbsp;&nbsp; D-- .test<span
 style="font-weight: bold; font-style: italic;">classes </span>:
contains compiled testing related Java class files<br>
&nbsp;&nbsp;&nbsp; D-- <span
 style="font-weight: bold; font-style: italic;">junit-reports </span>:
contains generated xml-formatted test reports<br>
&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;&nbsp; D-- <span
 style="font-weight: bold; font-style: italic;">reports/html </span>:
contains generated html-formatted test reports<br>
&nbsp;&nbsp;&nbsp; D-- <span
 style="font-weight: bold; font-style: italic;">dist </span>: contains
packaged archives of files<br>
<br>
<h2>PetClinic Application Design</h2>
<h3><span style="font-weight: bold; text-decoration: underline;"><span
 style="font-weight: bold; text-decoration: underline;"><span
 style="font-weight: bold; text-decoration: underline;">Logging</span></span></span></h3>
<h3><span style="font-weight: bold; text-decoration: underline;"><span
 style="font-weight: bold; text-decoration: underline;"></span></span></h3>
Spring supports the use of the Apache
Commons Logging API.This API provides the ability to use Java 1.4
loggers, the simple Commons loggers, and&nbsp;Apache Log4J loggers.
PetClinic uses&nbsp;Log4J
to provide sophisticated and configurable logging capabilities. The
file, <span style="font-weight: bold; font-style: italic;">war/WEB-INF/log4j.properties</span>
configures the definition of <span style="font-weight: bold;">Log4j </span>loggers.
<span style="text-decoration: underline;"><span
 style="font-weight: bold;"><br>
</span></span><br>
<h3><span style="font-weight: bold; text-decoration: underline;">BusinessLayer</span></h3>
<h3><span style="font-weight: bold; text-decoration: underline;"></span></h3>
<span style="font-weight: bold; text-decoration: underline;"> </span>The
Business Layer consists of a number of basic JavaBean classes
representing the application domain objects and associated validation
objects that are used by the
Presentation Layer.The&nbsp; validation objects used in PetClinic are
all implementations of&nbsp; the <span style="font-weight: bold;">org.springframework.validation.Validator
</span>interface.
<ul>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples.</span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.Entity</span>
is a simple JavaBean superclass used for all persistable objects.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.NamedEntity</span>
is an extension of&nbsp;<span style="font-weight: bold;">Entity </span>that
adds a name property.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.petclinic.Specialty</span>
is an extension of <span style="font-weight: bold;"><span
 style="font-weight: bold;">Named</span></span><span
 style="font-weight: bold;">Entity</span>.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.petclinic.PetType</span>
is an extension of <span style="font-weight: bold;"><span
 style="font-weight: bold;">Named</span></span><span
 style="font-weight: bold;">Entity</span>.<span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;"></span></span></span></li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.petclinic.Person&nbsp;</span>is
an extension of <span style="font-weight: bold;">Entity </span>that
&nbsp;provides a superclass for all objects that implement the notion
of
a person.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.Vet</span>&nbsp;is
an extension of <span style="font-weight: bold;"></span><span
 style="font-weight: bold;">Person</span> that implements a
veterinarian. It holds a <span style="font-weight: bold;">List </span>of
specialties that the <span style="font-weight: bold;">Vet </span>is
capable of.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.petclinic.Owner</span>
is
an extension of <span style="font-weight: bold;"></span><span
 style="font-weight: bold;">Person</span> that implements a pet owner.
It holds a <span style="font-weight: bold;">List </span>of pets
owned.&nbsp;</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.petclinic.Pet</span>
is an extension of <span style="font-weight: bold;"></span>
&nbsp;<span style="font-weight: bold;">NamedEntity</span> that
implements a pet. It holds a <span style="font-weight: bold;">List </span>of
visits made concerning the
pet.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.petclinic.Visit</span>
is a simple JavaBean&nbsp;that implements the notion of a clinic visit
for a pet. </li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.petclinic.util.Entity</span><span
 style="font-weight: bold;"></span><span style="font-weight: bold;">Utils
    </span>provides utility methods for handling enitites.</li>
</ul>
<br>
<ul>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.validation.FindOwnerValidator</span>
is
a Spring <span style="font-weight: bold;">Validator </span>that
verifies correct data entry for the FindOwner form.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.petclinic.validation.OwnerValidator</span>
is a Spring <span style="font-weight: bold;">Validator </span>that
verifies correct data entry for the Add and Edit Owner forms.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.validation.PetValidator</span>
is a Spring <span style="font-weight: bold;">Validator </span>that
verifies correct data entry for the Add and Edit Pet forms.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.petclinic.validation.VisitValidator</span>
is a Spring <span style="font-weight: bold;">Validator </span>that
verifies correct data entry for the AddVisit form.</li>
</ul>
<h3><br>
<span style="font-weight: bold; text-decoration: underline;"></span></h3>
<h3><span style="font-weight: bold; text-decoration: underline;">Business/Persistence
Layer</span></h3>
<h3><span style="font-weight: bold; text-decoration: underline;"></span></h3>
<span style="font-weight: bold; text-decoration: underline;"> </span>Since
the PetClinic application is all about database access and there is
very little business logic in the application outside of that, there is
no separation of the primary Business and Persistence Layer API's.
While
this design technique should not be used for an application with more
complex business logic, it is acceptable here because all of the
non-persistence related business rules have been implemented in
business
objects and have not leaked into the Persistence Layer. The most
important facet of the design is that the Business and Persistence
Layers are <span style="font-weight: bold;">COMPLETELY </span>independent
of the Presentation Layer.<br>
<br>
The Persistence Layer can be configured to use either HSQL or MySQL
with any one of three strategies aided by infrastructure
provided by Spring:<br>
<ol>
  <li>JDBC</li>
  <li>Hibernate</li>
  <li>Apache OJB</li>
</ol>
<span style="font-weight: bold;">NOTE:</span> Spring also provides
infrastructure for using other <span style="font-weight: bold;">O</span>bject-<span
 style="font-weight: bold;">R</span>elational-<span
 style="font-weight: bold;">M</span>apping frameworks such as&nbsp; JDO
and iBATIS SqlMaps but these are not demonstrated in PetClinic.<br>
<br>
One of the key elements provided by Spring is the use of a common set
of meaningful data access exceptions that can be used regardless of
which database or access strategy is used. All of these exceptions
derive from <span style="font-weight: bold;">org.springframework.dao.DataAccessException</span>.
Since most exceptions encountered during database access are indicative
of programming errors, <span style="font-weight: bold;">DataAccessException</span>
is an abstract <span style="font-weight: bold;"><span
 style="font-weight: bold;">RuntimeException </span></span>whose
derivatives only need to be caught by application code to handle
recoverable errors when it makes sense to do so. This greatly
simplifies application code&nbsp; compared to, for example, code
using&nbsp; JDBC directly where <span style="font-weight: bold;">SqlExceptions
</span>must be caught and database specific error codes must be
decoded. Examination of the PetClinic source code will show that the
persistence-oriented code is completely focused on the relevant
transfer of data to/from the referenced objects without extraneous
error handling.<br>
<br>
The high-level business/persistence API for PetClinic is the&nbsp; <span
 style="font-weight: bold;">org.springframework.samples.petclinic.Clinic
</span>interface. Spring provides several convenient abstract
DaoSupport classes for each of the persistence strategies. Each
persistence strategy in PetClinic is a different implementation of the <span
 style="font-weight: bold;">Clinic </span>interface that extends the
respective DaoSupport class. In each case, the <span
 style="font-weight: bold;">Clinic </span>implementation is fronted by
a transactional proxy that also implements <span
 style="font-weight: bold;">Clinic</span>. These objects are standard
Java dynamic proxies which are created by an instance of&nbsp; <span
 style="font-weight: bold;">org.springframework.transaction.interceptor.TransactionProxyFactoryBean</span>.
These proxies are configured in the respective application context file
and specify that all <span style="font-weight: bold;">Clinic </span>methods
are run in a transactional context.The transaction managers used in
PetClinic are all implementations of&nbsp; the <span
 style="font-weight: bold;">org.springframework.transaction.PlatformTransactionManager
</span>interface. All of the implementations are by default configured
to use a local <span style="font-weight: bold;">DataSource </span>that
will work in any environment through the use of an instance of&nbsp; <span
 style="font-weight: bold;">org.springframework.jdbc.datasource.DriverManagerDataSource</span>.
While this is appropriate for use in a demo or single user
program,&nbsp; a connection pooling <span style="font-weight: bold;">DataSource</span>,
such as an instance of <span style="font-weight: bold;">org.apache.commons.dbcp.BasicDataSource</span>,
is more appropriate for use in a multi-user application. Another
alternative is to obtain one through the J2EE environment&nbsp;
using&nbsp; an instance of<span style="font-weight: bold;"> </span><span
 style="font-weight: bold;">org.springframework.jndi.JndiObjectFactoryBean</span>.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">JDBC
Clinic Implementation</span><br>
Spring provides a number of high-level database
access convenience classes in the package <span
 style="font-weight: bold;">org.springframework.jdcb.object</span>.
These
classes and the lower-level Spring classes that they use in the <span
 style="font-weight: bold;">org.springframework.jdcb.core </span>package
provide a
higher level of abstraction for using JDBC that keeps the developer
from having to correctly implement the handling of the checked <span
 style="font-weight: bold;">SqlExceptions </span>with ugly error-prone
nested try-catch-finally blocks. Using the classes in this package
allows the developer to focus efforts on the functionality being
implemented rather than the mechanics of error handling. When using
these classes, it is the responsibility of the developer to provide the
SQL needed and to map the parameters to/from the repective domain
object. This typically is done by extending one of the <span
 style="font-weight: bold;">org.springframework.jdcb.object </span>classes,
initializing its SQL,&nbsp; and overriding a method that takes care of
the mapping. In this way, the developer gets to focus on implementing
functionality rather than application plumbing. These classes also
take care of closing connections to prevent hard to find resource
leakage problems. It should be noted that instances of these classes
are
lightweight, reusable, and threadsafe.
<br>
<br>
All of these objects in PetClinic initialize the SQL in their
constructors. SQL "Select" type
queries are implemented by subclassing <span style="font-weight: bold;">org.springframework.jdcb.object.MappingSqlQuery</span>.
These subclasses override the <span style="font-style: italic;">mapRow(ResultSet,
int rowNum)</span> method to extract data from the <span
 style="font-weight: bold;">ResultSet </span>returned to the framework
by execution of the query. The framework calls this method once for
every row in the <span style="font-weight: bold;">ResultSet</span>.
SQL "Update" and "Insert" type queries are implemented&nbsp;by
subclassing <span style="font-weight: bold;">org.springframework.jdcb.object.SqlUpdate</span>.
These subclasses override or call an update(Object[]) method that
places the
domain object data into an Object array which is substituted into the
appropriate <span style="font-weight: bold;">SqlParameters </span>of
a <span style="font-weight: bold;">PreparedStatement</span>.<br>
<span style="font-weight: bold; text-decoration: underline;"></span><br>
The primary JDBC implementation of the Clinic
interface is <span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.</span></span><span
 style="font-weight: bold; font-style: italic;"></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.jdbc.AbstractJdbcClinic</span>.
It defines and uses the following inner classes:
<ul>
  <ul>
    <li><span style="font-weight: bold; font-style: italic;">VetsQuery </span>is
the base class for any <span style="font-weight: bold;">Vet </span>Query
Objects. It provides an "All Vets" query as a convenience.</li>
    <li><span style="font-weight: bold; font-style: italic;">SpecialtiesQuery</span>
is the "All <span style="font-weight: bold;">Vet's </span>Specialties"
Query Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">VetSpecialtiesQuery</span>
is a particular <span style="font-weight: bold;">Vet's </span>specialties
Query Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">OwnersQuery</span>
is an abstract base class for all <span style="font-weight: bold;">Owner</span>
Query Objects.</li>
    <li><span style="font-weight: bold; font-style: italic;">OwnerQuery</span>
is an <span style="font-weight: bold;">Owner </span>by id Query
Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">OwnersByNameQuery</span>
is an <span style="font-weight: bold;">Owners </span>by last name
Query Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">OwnerUpdate</span>
is an <span style="font-weight: bold;">Owner </span>Update Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">OwnerInsert</span>
is an <span style="font-weight: bold;">Owner </span>Insert Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">TypesQuery
      </span>is
an "All <span style="font-weight: bold;">Pet </span>types" Query
Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">Pets</span><span
 style="font-weight: bold; font-style: italic;">Query</span><span
 style="font-weight: bold; font-style: italic;"> </span>is an abstract
base class for all <span style="font-weight: bold;">Pet </span>Query
Objects.</li>
    <li><span style="font-weight: bold; font-style: italic;">Pet</span><span
 style="font-weight: bold; font-style: italic;">Query</span><span
 style="font-weight: bold; font-style: italic;"> </span>is a <span
 style="font-weight: bold;">Pet </span>by id Query Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">PetsByOwnerQuery</span>
is a <span style="font-weight: bold;">Pets </span>by <span
 style="font-weight: bold;">Owner </span>Query Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">PetUpdate </span>is
a <span style="font-weight: bold;">Pet </span>Update Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">PetInsert </span>is
a <span style="font-weight: bold;">Pet </span>Insert Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">VisitsQuery</span>
is a <span style="font-weight: bold;">Visits </span>by <span
 style="font-weight: bold;">Pet </span>Query Object.</li>
    <li><span style="font-weight: bold; font-style: italic;">VisitInsert</span>
is a <span style="font-weight: bold;">Visit </span>Insert Object.</li>
  </ul>
</ul>
The HSQL specific extension of&nbsp;<span style="font-weight: bold;">AbstractJdbcClinic</span>
is <span style="font-weight: bold;"><span style="font-weight: bold;"><span
 style="font-weight: bold;"><span style="font-weight: bold;"><span
 style="font-weight: bold;"><span style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold;">.</span></span><span
 style="font-weight: bold;"></span></span><span
 style="font-weight: bold;">petclinic.</span></span><span
 style="font-weight: bold;">petclinic.</span><span
 style="font-weight: bold;">jdbc</span><span style="font-weight: bold;">.HsqlClinic</span><span
 style="font-weight: bold; font-style: italic;">. </span>It provides
an HSQL implementation of the getIdentityQuery() method. <br>
<br>
The MySQL specific extension <span style="font-weight: bold;">of&nbsp;AbstractJdbcClinic
</span>is <span style="font-weight: bold;">org.springframework.samples.petclinic.petclinic.jdbc.MysqlClinic</span>.
It provides an MySQL implementation of the getIdentityQuery() method. <br>
<span style="font-weight: bold;"><span style="font-weight: bold;"><span
 style="font-weight: bold;"><span style="font-weight: bold;"><span
 style="font-weight: bold;"><span style="font-weight: bold;"></span></span></span></span></span></span><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;"></span></span></span></span></span></span><br>
The transaction manager used in the JDBC Clinic Implementation is an
instance of&nbsp; <span style="font-weight: bold;">org.springframework.jdbc.datasource.DataSourceTransactionManager</span>
that can be used for local transactions.<br>
&nbsp;<br>
<span style="font-weight: bold; text-decoration: underline;">Hibernate
Clinic Implementation</span><br>
The Hibernate implementation of the <span style="font-weight: bold;">Clinic
</span>interface is <span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.</span></span><span
 style="font-weight: bold; font-style: italic;"></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.hibernate.HibernateClinic</span>.
To simplify using Hibernate, Spring provides the <span
 style="font-weight: bold;">org.springframework.orm.hibernate.LocalSessionFactoryBean</span>.
The Hibernate configuration is provided by the file&nbsp; <span
 style="font-style: italic;">src/petclinic.hbm.xml</span>.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">Apache OJB
Clinic Implementation</span><br>
The Apache OJB implementation of the <span style="font-weight: bold;">Clinic
</span>interface is <span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.samples</span></span></span><span
 style="font-weight: bold; font-style: italic;">.</span></span><span
 style="font-weight: bold; font-style: italic;"></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.ojb.PersistenceBrokerClinic</span>.
To simplify using OJB, Spring provides the <span
 style="font-weight: bold;">org.springframework.orm.ojb.PersistenceBrokerTransactionManager</span>.
The Apache OJB configuration is provided by the files&nbsp; <span
 style="font-style: italic;">src/OJB-repository.xml </span>and <span
 style="font-style: italic;">src/OJB</span>.<span
 style="font-style: italic;">properties</span>.
<h3><br>
<span style="font-weight: bold; text-decoration: underline;"><span
 style="font-weight: bold; text-decoration: underline;"></span></span></h3>
<h3><span style="font-weight: bold; text-decoration: underline;"><span
 style="font-weight: bold; text-decoration: underline;">ApplicationContext</span></span></h3>
<h3><span style="font-weight: bold; text-decoration: underline;"></span></h3>
A Spring <span style="font-weight: bold;"><span
 style="font-weight: bold;"><span style="font-weight: bold;">org.springframework.context</span></span><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">.</span></span></span><span
 style="font-weight: bold;">ApplicationContext </span>object
provides a map of user-defined JavaBeans that specify either a
singleton object or the initial construction of prototype instances.
These beans constitute the <span style="font-weight: bold;">Business/Persistence
Layer</span> of PetClinic.The
following&nbsp; beans are defined in all of the 3 versions (1 per
access strategy) of the PetClinic <span style="font-style: italic;">applicationContext-???.xml</span>
file:<span style="font-weight: bold; text-decoration: underline;"><br>
</span>
<ol>
  <li><span style="font-weight: bold; font-style: italic;">propertyConfigurer
    </span>is
a singleton bean that replaces ${...} placeholders with values from a
properties file, in this case, JDBC-related settings for the <span
 style="font-weight: bold; font-style: italic;">dataSource </span>bean
described below (see<span style="font-weight: bold; font-style: italic;">
war/WEB-INF/jdbc.properties</span>).<br>
    <span style="font-weight: bold; font-style: italic;"></span></li>
  <li><span style="font-weight: bold; font-style: italic;">dataSource </span>is
a singleton bean that defines the implementation of the source of
database connections used by the application.</li>
  <li><span style="font-weight: bold; font-style: italic;">clinicTarget
    </span>is
a singleton bean that defines the implementation of the <span
 style="font-weight: bold;">Clinic </span>interface that provides the
primary Business Layer API of the application.</li>
  <li><span style="font-weight: bold; font-style: italic;">transactionManager&nbsp;
    </span><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"></span></span>is
a singleton bean that defines the implementation of the transaction
management strategy for the application.</li>
  <li><span style="font-weight: bold; font-style: italic;">clinic</span><span
 style="font-weight: bold;"></span> is
a singleton bean that provides the transactional proxy for the <span
 style="font-weight: bold; font-style: italic;">clinicTarget</span>
bean.<span style="font-weight: bold; font-style: italic;"> </span><span
 style="font-weight: bold; font-style: italic;"> <span
 style="font-weight: bold;"></span></span></li>
</ol>
<span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;"><br>
</span></span>
<h3><span style="font-weight: bold; text-decoration: underline;">Presentation
Layer</span></h3>
<h3><span style="font-weight: bold; text-decoration: underline;"></span></h3>
<span style="font-weight: bold; text-decoration: underline;"> </span>The
Presentation Layer is implemented as a J2EE Web Application and
provides a very thin and concise Model-View-Controller type user
interface to the Business and Persistence Layers. <br>
<br>
The PetClinic web application is configured via the following files:<br>
<ul>
  <li><span style="font-weight: bold; font-style: italic;">war/WEB-INF/web.xml</span>
is the web application configuration file.</li>
  <li><span style="font-weight: bold; font-style: italic;">war/WEB-INF/petclinic-servlet.xml</span>
configures the petclinic dispatcher servlet and the other controllers
and forms that it uses. The beans defined in this file reference the
Business/Persistence Layer beans defined in <span
 style="font-style: italic;">applicationContext-???.xml.</span></li>
  <li><span style="font-weight: bold; font-style: italic;">war/WEB-INF/classes/views*.properties</span>
configures the definition of internationalizable Spring views.</li>
  <li><span style="font-weight: bold; font-style: italic;">war/WEB-INF/classes/messages*.properties</span>
configures the definition of internationalizable message resources.</li>
</ul>
Examine the comments provided in each of these files for a more
in-depth understanding of the details of how the application is
configured.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">General</span><br>
<ul>
  <li>In <span style="font-weight: bold; font-style: italic;">web.xml</span>,
a context-param, "<span style="font-weight: bold;">webAppRootkey</span>",
provides the key for a system property that specifies the root
directory for the web application. This parameter,&nbsp; <span
 style="font-weight: bold;">"petclinic.root"</span>, can be used to aid
in configuring the application.</li>
  <li>In <span style="font-weight: bold; font-style: italic;">web.xml</span>,
a <span style="font-weight: bold;">org.springframework.web.context.ContextLoaderListener
    </span>is
defined that loads the root <span style="font-weight: bold;">ApplicationContext</span>
object of this webapp at startup, by default from the designated <span
 style="font-weight: bold; font-style: italic;">/WEB-INF/applicationContext-???.xml</span>.
The
root <span style="font-weight: bold;">org.springframework.web.context.WebApplicationContext
    </span>of
PetClinic is an instance of <span style="font-weight: bold;">org.springframework.web.context.support.XmlWebApplicationContext</span>
and
is the parent of all servlet-specific <span style="font-weight: bold;">ApplicationContexts</span>.
The Spring root <span style="font-weight: bold;">ApplicationContext </span>object
provides a map of user-defined JavaBeans that can be used in any and
all layers of the application. Beans defined in the root <span
 style="font-weight: bold;">ApplicationContext</span> are automatically
available in all child&nbsp;<span style="font-weight: bold;">ApplicationContext</span>
objects
as (external) bean references. Beans defined in an <span
 style="font-weight: bold;">ApplicationContext </span>can also be
accessed directly by Java code through <span
 style="font-style: italic;">getBean(name)</span>
method calls.</li>
  <li>In <span style="font-weight: bold; font-style: italic;">web.xml</span>,
a <span style="font-weight: bold;">Servlet </span>named <span
 style="font-weight: bold;">"petclinic" </span>is specified to act as
a dispatcher for the entire application. This <span
 style="font-weight: bold;">org.springframework.web.servlet.DispatcherServlet</span>
is used to handle all URL's matching the pattern <span
 style="font-weight: bold;">"*.htm"</span>. As with any <span
 style="font-weight: bold;">Servlet</span>, multiple URL mappings may
be defined. It is also possible to define multiple instances of <span
 style="font-weight: bold;">DispatcherServlet</span>. Each <span
 style="font-weight: bold;">DispatcherServlet </span>dispatches
requests to registered handlers (<span style="font-weight: bold;">Controller</span>
interface implementations) indirectly through a <span
 style="font-weight: bold;">org.springframework.web.servlet.handler.HandlerMapping</span>
implementation. Each <span style="font-weight: bold;">DispatcherServlet</span>
has its own <span style="font-weight: bold;">ApplicationContext</span>,
by default defined in <span style="font-weight: bold;">"{servlet-name}-servlet.xml"</span>.
In this case, it is in the file <span style="font-weight: bold;">"petclinic-servlet.xml"</span>.
This <span style="font-weight: bold;">ApplicationContext </span>is
used to specify the various web application user interface beans and
the
URL mappings that are used by the <span style="font-weight: bold;">DispatcherServlet</span>
to control the handling of requests.</li>
</ul>
The
files <span style="font-weight: bold; font-style: italic;">web.xml </span>and<span
 style="font-weight: bold; font-style: italic;"> log4j.properties </span>specify
the configuration of logging in the system:<br>
<ul>
  <li>In <span style="font-weight: bold; font-style: italic;">web.xml</span>,
a <span style="font-weight: bold;">"log4jConfigLocation" </span>context-param
is specified that sets the location of the <span
 style="font-weight: bold;">Log4j </span>configuration file. The
default location for this file is <span
 style="font-weight: bold; font-style: italic;">/WEB-INF/classes/log4j.properties</span>.
Specifying this parameter explicitly allows the location to be changed
from the default and is also used to cause periodic <span
 style="font-weight: bold;">Log4j </span>configuration refresh checks.</li>
  <li>In <span style="font-weight: bold; font-style: italic;">web.xml</span>,
a <span style="font-weight: bold;">Log4jConfigListener </span>is
specified that will initialize <span style="font-weight: bold;">Log4j </span>using
the specified configuration file when the web app starts. The <span
 style="font-weight: bold;">Log4jConfigListener</span> is commented out
in the file because of a conflict when using JBoss. It should also be
noted that if the container initializes Servlets before Listeners as
some pre-Servlet 2.4 containers do, a <b>Log4jConfigServlet</b> should
be used instead.<span style="font-weight: bold;"> </span></li>
  <li>In <span style="font-weight: bold; font-style: italic;">log4j.properties</span>,
the following loggers are specified:</li>
  <ul>
    <li><span style="font-weight: bold; font-style: italic;">"stdout" </span>provides
logging messages to the container's log file.</li>
    <li><span style="font-weight: bold; font-style: italic;">"logfile" </span>provides
logging messages to a rolling file that is specifed using the
previously defined "petclinic.root".</li>
  </ul>
</ul>
Examination and study of these logging files will provide insight into
the operation of the Spring framework and the application as well as
valuable troubleshooting information should something not work
correctly.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">DispatcherServlet</span><br>
The following beans are accessible to the <span
 style="font-weight: bold;"></span><span style="font-weight: bold;">DispatcherServlet
</span>and are defined
in the PetClinic <span style="font-weight: bold; font-style: italic;">petclinic-servlet.xml</span>
file. This dispatcher uses these defintions to delegate actual display
and form processing tasks to implementations of the Spring <span
 style="font-weight: bold;">org.springframework.web.servlet.mvc.Controller
</span>interface. The <span style="font-weight: bold;"></span><span
 style="font-weight: bold;">DispatcherServlet</span>
acts as the main application <span style="font-weight: bold;">Front
Controller</span> and is responsible for
dispatching all requests to the appropriate <span
 style="font-weight: bold;">Controller</span> indirectly through a URL
mapping handler. These <span style="font-weight: bold;">Controllers </span>are
responsible for the
mechanics of interaction with the user and ultimately delegate action
to the Business/Persistence Layers.
<ul>
  <li><span style="font-weight: bold; font-style: italic;">messageSource</span>
is a singleton bean that defines a message source for this <span
 style="font-weight: bold;">ApplicationContext</span>. Messages are
loaded from localized <span style="font-weight: bold;">"messages_xx"</span>
files in the classpath, such as <span
 style="font-weight: bold; font-style: italic;">"/WEB-INF/classes/messages.properties"</span>
or <span style="font-weight: bold; font-style: italic;">"/WEB-INF/classes/messages_de.properties"</span>.<span
 style="font-weight: bold;"> </span><span style="font-style: italic;">getMessage()</span><span
 style="font-weight: bold;"> </span>calls to this context will use
this
source. Child contexts can have their own message sources, which will
inherit all messages from this source and are able to define new
messages and override ones defined in the primary message source.</li>
  <li><span style="font-weight: bold; font-style: italic;">viewResolver
    </span>is
a singleton bean that defines the view mappings used by the dispatcher.
This definition specifies explicit view mappings in a resource bundle
(properties file) instead of using the default <span
 style="font-weight: bold;">InternalResourceViewResolver</span>. It
fetches the view mappings from localized <span
 style="font-style: italic; font-weight: bold;">"views_xx</span><span
 style="font-style: italic; font-weight: bold;">.properties</span><span
 style="font-style: italic; font-weight: bold;">"</span><span
 style="font-weight: bold; font-style: italic;"> </span><span
 style="font-style: italic;"></span> files, i.e. <span
 style="font-weight: bold; font-style: italic;">"/WEB-INF/classes/views.properties"</span>
or <span style="font-weight: bold; font-style: italic;">"/WEB-INF/classes/views_de.properties"</span>
that are loaded from the classpath. Symbolic view names returned by
controllers will be resolved in the respective properties file,
allowing
for arbitrary mappings between view names and resources.</li>
  <li><span style="font-weight: bold; font-style: italic;">exceptionResolver</span>
is
a singleton bean that defines how exceptions are propogated. Exceptions
encountered that are not specified are propogated to the servlet
container.<br>
  </li>
  <li><span style="font-weight: bold; font-style: italic;">urlMapping </span>is
a singleton bean that defines the URL mapping handler that is to be
used by the dispatcher. The definition specifies the use of a <span
 style="font-weight: bold;">SimpleUrlHandlerMapping </span>instead of
the default <span style="font-weight: bold;">BeanNameUrlHandlerMapping.</span>
This allows specific URL's to be mapped directly to display or<span
 style="font-weight: bold;"> </span>form<span
 style="font-weight: bold;">
Controllers</span>.</li>
  <li><span style="font-weight: bold; font-style: italic;">clinicController</span>
is a singleton bean that defines the <span style="font-weight: bold;">Controller</span>
that is used by the dispatcher to handle non-form based display tasks.
This bean is a <b>org.springframework.web.servlet.mvc.multiaction.MultiActionController</b><span
 style="font-weight: bold;"> </span>that
can handle multiple request URLs. A method is provided to handle each
type of request that is supported.</li>
  <li><span style="font-weight: bold; font-style: italic;">clinicControllerMethodnameResolver</span>
is a singleton bean that defines a mapping of URL's to method names for
the <span style="font-weight: bold; font-style: italic;">clinicController</span>
bean.</li>
  <li>6&nbsp;singleton Form beans are defined that are extensions of
the PetClinic class <span style="font-weight: bold;">AbstractClinicForm
    </span>which
is itself an extension of the Spring class <span
 style="font-weight: bold;">SimpleFormController</span>. These beans
are used to handle the various Search, Add and Edit form processing
tasks for the dispatcher.</li>
  <li>3 singleton beans are defined that are implementations of the <span
 style="font-weight: bold;">org.springframework.validation.Validator </span>interface.
These beans are used by the Form beans to validate their input
parameters and to bind localizable error messages for display should a
processing error occur on submission.</li>
</ul>
<span style="font-weight: bold; text-decoration: underline;">Controllers<br>
<span style="text-decoration: underline;"><span
 style="font-weight: bold;"></span></span></span>Spring provides a
number of useful MVC abstractions to developers of &nbsp;J2EE web
applications. The <span style="font-weight: bold;">Controller </span>interface
specifies a single method, <span style="font-style: italic;">handleRequest(</span><span
 style="font-style: italic;">HttpServletRequest</span><span
 style="font-style: italic;">, </span><span style="font-style: italic;">HttpServletResponse</span><span
 style="font-style: italic;">)</span> that must be provided by
implementing classes to handle request processing. This method returns
a <span style="font-weight: bold;">org.springframework.web.servlet.mvc.ModelAndView</span>
to the <span style="font-weight: bold;">DispatcherServlet </span>for
rendering. Spring provides several convenient implementations of the <span
 style="font-weight: bold;">Controller </span>interface that
developers can use to simplify their task, the most significant of
which
are <span style="font-weight: bold;">MultiActionController,</span> <span
 style="font-weight: bold;">SimpleFormController</span>, and <span
 style="font-weight: bold;">AbstractWizardFormController</span>. <span
 style="font-weight: bold;">AbstractWizardFormController </span>is not
used in PetClinic and is not discussed here. A <span
 style="font-weight: bold;">MultiActionController </span>is used to
define a <span style="font-weight: bold;">Controller </span>with
multiple handling methods the selection of which can be configured
using
a separate <span style="font-weight: bold;">MethodNameResolver </span>object.
"FormControllers", including <span style="font-weight: bold;">SimpleFormController</span>,<span
 style="font-weight: bold;"> </span>are used to process html forms and
can automatically populate "command" objects with data supplied via
request parameters and vice versa. <span style="font-weight: bold;">SimpleFormController</span>
is part of a deep hierarchy of objects which is discussed here.
Additional detail is avaliable in the Spring API Javadoc.<br>
<ul>
  <li><span style="font-weight: bold;">org.springframework.context.support.ApplicationObjectSupport</span>
is an implementation of &nbsp;<span style="font-weight: bold;">org.springframework.context.ApplicationContextAware</span>
which provides its subclasses with a method, <span
 style="font-style: italic;">initApplicationContext()</span>, which can
be overridden to provide custom initialization behavior.</li>
  <li><span style="font-weight: bold;">org.springframework.web.servlet.support.WebContentGenerator</span>is
an <span style="font-weight: bold;">ApplicationObjectSupport</span>
extension that is a convenient superclass for any kind of web content
generator, like AbstractController and MultiActionController. It
supports HTTP cache control options.</li>
  <li><span style="font-weight: bold;">org.springframework.web.servlet.mvc.</span><span
 style="font-weight: bold;">AbstractController</span> <span
 style="font-weight: bold;"></span>is a <span
 style="font-weight: bold;">WebContentGenerator</span> extension that
is
a convenient superclass for controller implementations. It provides
several properties that can be set by users, <span
 style="font-style: italic;">supportedMethods</span> i.e. "GET",
"POST",
etc., <span style="font-style: italic;">requireSession</span>, and <span
 style="font-style: italic;">cacheSeconds</span>. It uses the Template
Method design pattern in its <span style="font-weight: bold;">final</span>
implementation of &nbsp;<span style="font-style: italic;">handleRequest()</span>whichcoordinates
how these properties are used and calls a similar <span
 style="font-style: italic;">handleRequestInternal() </span>method
that subclasses must override to provide their own processing of
request
handling.</li>
  <li><span style="font-weight: bold;">org.springframework.web.servlet.mvc.BaseCommandController
    </span>is
an <span style="font-weight: bold;">Abstract</span><span
 style="font-weight: bold;">Controller</span> extension that provides
infrastructure to its subclasses to support the binding and validating
process. This infrastructure creates a "command" object on receipt of a
request, and attempts to populate the command's JavaBean properties
with
request attributes. Once created, commands can be validated using a
Validator associated with this class. Type mismatches populating a
command are treated as validation errors, but are caught by the
framework, not application code. Users can directly set the <span
 style="font-style: italic;">commandClass </span>and <span
 style="font-style: italic;">validator </span>properties to specify
the objects of interest. It also provides default implementations of
several methods that can be overridden to further customize the binding
and validation process. Some of these methods are:</li>
  <ul>
    <li><span style="font-style: italic;">userObject(HttpServletRequest
request)</span> is used to create the command object.</li>
    <li><span style="font-style: italic;"></span><span
 style="font-style: italic;">initBinder(HttpServletRequest request</span>,<span
 style="font-style: italic;"> ServletRequestDataBinder binder)</span>
is
used to initialize the binder instance and is typically overridden to
specify a custom <span style="font-weight: bold;">PropertyEditor</span>.</li>
    <li><span style="font-style: italic;"></span><span
 style="font-style: italic;">onBindAndValidate(HttpServletRequest
request, Object command, BindException errors)</span> is used to
provide
custom post-processing for the binding and validation process. It is
called after standard binding and validation and before error
evaluation.</li>
  </ul>
  <li style="font-weight: bold;">org.springframework.web.servlet.mvc.AbstractFormController&nbsp;<span
 style="font-weight: normal;">is a&nbsp;</span><span
 style="font-weight: bold;">BaseCommandController&nbsp;</span><span
 style="font-weight: normal;">extension that&nbsp;</span><span
 style="font-weight: normal;">provides infrastructure</span> <span
 style="font-weight: normal;">to its subclasses </span><span
 style="font-weight: normal;"> </span><span
 style="font-weight: normal;">to
support html forms. It controls the form display and submission process
in its <span style="font-weight: bold;">final </span>implementation
of </span><span style="font-style: italic; font-weight: normal;">handleRequestInternal()</span><span
 style="font-weight: normal;">.</span></li>
  <ul>
    <li style="font-weight: bold;"><span style="font-weight: normal;">The<span
 style="font-style: italic;"> sessionForm </span>property, when true,
forces the creation of an HttpSession to hold the command object so
that
it is retained between requests.<span style="font-weight: bold;"></span></span></li>
    <li style="font-weight: bold;"><span style="font-weight: normal;"></span><span
 style="font-weight: normal;">The <span style="font-style: italic;">bindOnNewForm</span>property,
when true, forces population of the form from data provided by the
command object. This is particularly useful for forms that are used to
edit an existing object.</span></li>
    <li style="font-weight: bold;"><span style="font-weight: normal;"></span><span
 style="font-weight: normal;"> It &nbsp;provides an &nbsp;</span><span
 style="font-weight: normal; font-style: italic;">isFormSubmission(HttpServletRequest)</span><span
 style="font-weight: normal;">method </span><span
 style="font-weight: normal;">that subclasses can override to</span> <span
 style="font-weight: bold;"></span> <span style="font-weight: normal;">determine
if a given request represents a form submission. The default </span><span
 style="font-weight: normal;">implementation treats a POST request as
form submission. </span><span style="font-weight: normal;">If the form
session attribute doesn't exist when using session form </span><span
 style="font-weight: normal;">mode, the request is always treated as
new form by <span style="font-style: italic;">handleRequestInternal()</span>.</span><span
 style="font-weight: normal;"> Subclasses can override this to
implement
a custom strategy. PetClinic uses the default implementation.</span></li>
    <li style="font-weight: bold;"><span style="font-weight: normal;"></span><span
 style="font-weight: normal;">It provides a</span> final <span
 style="font-weight: normal;">method <span style="font-style: italic;">showNewForm(HttpServletRequest,
HttpServletResponse)</span></span><span style="font-weight: normal;">
to
handle display and data binding of a new form.</span></li>
    <li style="font-weight: bold;"><span style="font-weight: normal;"></span><span
 style="font-weight: normal;">It provides a method </span><span
 style="font-weight: normal; font-style: italic;">formBackingObject(HttpServletRequest)</span><span
 style="font-weight: normal;"> that subclasses can override to provide
a </span><span style="font-weight: normal;">preinitialized backing
object.</span></li>
    <li style="font-weight: bold;"><span style="font-weight: normal;"></span><span
 style="font-weight: normal;">It provides a method </span><span
 style="font-weight: normal; font-style: italic;">referenceData(HttpServletRequest,
Object, Errors)&nbsp;</span><span style="font-weight: normal;">that
subclasses can override to provide </span><span
 style="font-weight: normal;">reference data to be used in rendering
the view.</span></li>
    <li style="font-weight: bold;"><span style="font-weight: normal;"></span><span
 style="font-weight: normal;">It provides a method </span><span
 style="font-weight: normal; font-style: italic;"></span><span
 style="font-weight: normal;"><span style="font-style: italic;">handleInvalidSubmit(HttpServletRequest,
HttpServletResponse)</span> to handle an invalid form submission.
Subclasses should override this method to disallow duplicate form
submission. The default implementation simply resubmits the form.</span></li>
    <li style="font-weight: bold;"><span style="font-weight: normal;"></span><span
 style="font-weight: normal;">It provides a method </span><span
 style="font-weight: normal; font-style: italic;">processSubmit(HttpServletRequest,
HttpServletResponse, </span><span style="font-weight: normal;"><span
 style="font-style: italic;">Object, BindException)</span> that
subclasses must override </span><span style="font-weight: normal;">to
provide custom submission handling.</span></li>
    <li style="font-weight: bold;"><span style="font-weight: normal;"></span><span
 style="font-weight: normal;">It provides several <span
 style="font-style: italic;">showForm() </span>methods that are used
to display the form.</span></li>
  </ul>
  <li style="font-weight: bold;"><span style="font-weight: normal;">&nbsp;</span>org.springframework.web.servlet.mvc.SimpleFormController&nbsp;<span
 style="font-weight: normal;">is a concrete extension of&nbsp;</span>AbstractFormController<span
 style="font-weight: normal;"> that provides configurable</span><br
 style="font-weight: normal;">
    <span style="font-weight: normal;">&nbsp;form and success views,
and an onSubmit chain for convenient overriding.</span><span
 style="font-weight: normal;">&nbsp;</span><span
 style="font-weight: normal;"></span><span
 style="font-weight: normal; font-style: italic;"></span></li>
</ul>
&nbsp;<span style="font-style: italic;"></span><br>
<span style="font-weight: bold; text-decoration: underline;"><br>
Views</span><br>
The <span style="font-weight: bold;">Controllers </span>used by the
dispatcher handle the work flow of the application. The actual display
tasks are delegated by the <span style="font-weight: bold;">Controllers</span>
to implementations of the Spring <span style="font-weight: bold;">View
</span>interface.
These <span style="font-weight: bold;">View </span>objects are
themselves beans that can render a particular type of view. The
handling <span style="font-weight: bold;">Controller </span>supplies
the <span style="font-weight: bold;">View </span>with a data model to
render.
The data model is provided to the <span style="font-weight: bold;">View</span>
as
a <span style="font-weight: bold;">Map</span> of objects. <span
 style="font-weight: bold;">Views </span>are only responsible for
rendering a display of the data model and performing any display logic
that is particular to the type of <span style="font-weight: bold;">View
</span>being
rendered. Spring provides support for rendering many different types of
views: JSP, XSLT, PDF, Velocity templates, Excel files, and others. By
using a <span style="font-weight: bold;">View </span>mapping
strategy,
Spring supplies the developer with a great deal of flexibility in
supporting easily configurable view substitution. PetClinic defines a
number of
View beans in the file, <span
 style="font-weight: bold; font-style: italic;">views.properties</span>.
2 of these beans are instances of <span style="font-weight: bold;">RedirectView</span>
which simply redirects to another URL. The other <span
 style="font-weight: bold;">View </span>beans are instances of <span
 style="font-weight: bold;">JstlView </span>which provides some handy
support for supporting internationalization/localization in JSP pages
that use JSTL.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">Messages</span><br>
The <span style="font-weight: bold; font-style: italic;">messages*.properties</span>
files are loaded from the classpath to provide localized messages for
the supported languages. PetClinic supplies only a single localized
message, <span style="font-weight: bold;">"welcome"</span> in the
default, English, and German properties files respectively. See the
"countries" sample application for a more detailed example of Spring's
support for internationalization.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">Presentation
Layer classes</span>
<h3><span style="font-weight: bold; text-decoration: underline;"></span></h3>
<span style="font-weight: bold; text-decoration: underline;"> </span>
<ul>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.web.ClinicController</span>
is an extension of <span style="font-weight: bold;">MultiactionController</span>
that is used to handle simple display oriented URLs.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.web.AbstractClinicForm</span>
is an extension of <span style="font-weight: bold;">SimpleFormController</span>
that is the superclass of PetClinic's form objects. It provides its
subclasses with a some commonly needed form behavior:</li>
  <ul>
    <li>It provides a <span style="font-style: italic;">clinic </span>property
that gives access to the <span style="font-weight: bold;">Clinic </span>implementation
that is used to access the Business/Persistence Layer.</li>
    <li>It overrides <span style="font-style: italic;">initBinder() </span>to
provide a <span style="font-weight: bold;">DateFormat </span><span
 style="font-weight: bold;">PropertyEditor </span>to handle the
specialized binding of request parameters to <span
 style="font-weight: bold;">Date </span>fields.</li>
    <li>It provides a <span style="font-style: italic;">disallowDuplicateFormSubmission()</span>
method to enure correct handling of form submission initiated through
use of
the browser "Back" button:</li>
    <ul>
      <li>It disallows duplicate form submission for "Add" forms by
overriding <span style="font-weight: normal;"><span
 style="font-style: italic;">handleInvalidSubmit()</span></span>.</li>
    </ul>
  </ul>
  <ul>
    <ul>
      <li>It allows duplicate form submission for "Edit" forms by <span
 style="text-decoration: underline;">not</span> overriding <span
 style="font-weight: normal;"><span style="font-style: italic;">handleInvalidSubmit()</span></span>.</li>
    </ul>
  </ul>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.web.FindOwnersForm</span><span
 style="font-weight: bold; font-style: italic;"> </span>is an
extension
of <span style="font-weight: bold;"></span><span
 style="font-weight: bold; font-style: italic;">AbstractClinicForm </span>that
is used to find owners by last name.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.web.AddOwnerForm</span><span
 style="font-weight: bold; font-style: italic;"> </span>is an
extension
of <span style="font-weight: bold;"></span><span
 style="font-weight: bold; font-style: italic;">AbstractClinicForm </span>that
is used to add a new <span style="font-weight: bold;">Owner.&nbsp;</span></li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.web.EditOwnerForm</span><span
 style="font-weight: bold; font-style: italic;"> </span>is an
extension
of <span style="font-weight: bold;"></span><span
 style="font-weight: bold; font-style: italic;">AbstractClinicForm </span>that
is used to edit an existing <span style="font-weight: bold;">Owner. </span>A
copy of the&nbsp;existing <span style="font-weight: bold;">Owner </span>is
used for editing.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.web.AddPetForm</span>
    <span style="font-weight: bold; font-style: italic;"></span>is an
extension
of <span style="font-weight: bold;"></span><span
 style="font-weight: bold; font-style: italic;">AbstractClinicForm </span>that
is used to add a new <span style="font-weight: bold;">Pet </span>to
an existing <span style="font-weight: bold;">Owner</span>.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.web.EditPetForm</span><span
 style="font-weight: bold; font-style: italic;"> </span>is an
extension
of <span style="font-weight: bold;"></span><span
 style="font-weight: bold; font-style: italic;">AbstractClinicForm </span>that
is used to edit an existing <span style="font-weight: bold;">Pet</span>.
A copy of the&nbsp;existing <span style="font-weight: bold;">Pet </span>is
used for editing.</li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.web.AddVisitForm</span>
    <span style="font-weight: bold; font-style: italic;"> </span>is an
extension
of <span style="font-weight: bold;"></span><span
 style="font-weight: bold; font-style: italic;">AbstractClinicForm </span>that
is used to add a new <span style="font-weight: bold;">Visit </span>to
an existing <span style="font-weight: bold;">Pet</span>.</li>
  <ul>
    <ul>
    </ul>
  </ul>
</ul>
<span style="font-weight: bold; text-decoration: underline;"></span><span
 style="font-weight: bold; text-decoration: underline;">View Beans
&amp; Implemented Use Cases</span><br>
<ul>
  <li><span style="font-weight: bold; font-style: italic;">welcomeView </span>is
the "home" screen. It provides links to display a list of all vets,
find an owner, or view documentation.</li>
  <li><span style="font-weight: bold; font-style: italic;">vetsView </span>displays
all vets and their specialties.</li>
  <li><span style="font-weight: bold; font-style: italic;">findOwnersForm</span>
is used to find owners by last name.</li>
  <li><span style="font-weight: bold; font-style: italic;">findOwnersRedirectView</span>
redirects to findOwnerForm.</li>
  <li><span style="font-weight: bold; font-style: italic;">selectOwnerView</span>
allows user to select from a list of multiple owners with the same last
name.</li>
  <li><span style="font-weight: bold; font-style: italic;">ownerView </span>displays
a owner's data and a list of the owner's pets and their data.</li>
  <li><span style="font-weight: bold; font-style: italic;">ownerRedirect</span>
redirects to ownerView.</li>
  <li><span style="font-weight: bold; font-style: italic;">ownerForm </span>supports
    <span style="font-weight: bold; font-style: italic;">AddOwnerForm</span>
and<span style="font-weight: bold; font-style: italic;"> EditOwnerForm</span></li>
  <li><span style="font-weight: bold; font-style: italic;">petForm </span>supports<span
 style="font-style: italic;"><span style="font-weight: bold;"> </span></span><span
 style="font-weight: bold; font-style: italic;">AddPetForm</span>
and <span style="font-weight: bold; font-style: italic;">web.EditPetForm</span></li>
  <li><span style="font-weight: bold; font-style: italic;">visitForm </span>supports<span
 style="font-weight: bold; font-style: italic;"> AddVisitForm</span></li>
  <li><span style="font-weight: bold; font-style: italic;">dataAccessFailure</span>
displays a stacktrace<br>
  </li>
</ul>
<span style="font-weight: bold; text-decoration: underline;">JSP Pages</span>
<ul>
  <li><span style="font-weight: bold; font-style: italic;">index.jsp </span>redirects
to the "welcome" page.</li>
  <li><span style="font-weight: bold; font-style: italic;">includes.jsp
    </span>is
statically included in <span style="text-decoration: underline;">all</span>
JSP's used in the application. It sets session="false" to prevent
inappropriate session creation and specifies the taglibs that are in
use.</li>
  <li><span style="font-weight: bold; font-style: italic;">uncaughtException.jsp</span>
is the <span style="font-weight: bold; font-style: italic;">web.xml </span>configured
"error-page". It displays a stack trace and normally wouldn't be used
in a production version of an application. It can be seen in action by
entering a URL of "editOwner.htm" or "editpet.htm". The handlers for
these URLs normally expect to see a respective "ownerId" or "petId"
request parameter and throw a <span style="font-weight: bold;">ServletException</span>when
it isn't found.</li>
  <li><span style="font-weight: bold; font-style: italic;">welcome.jsp </span>implements<span
 style="font-weight: bold; font-style: italic;"> welcomeView</span>.</li>
  <li><span style="font-weight: bold; font-style: italic;">vets.jsp</span><span
 style="font-weight: bold; font-style: italic;"> </span>implements<span
 style="font-weight: bold; font-style: italic;"> vetsView</span>.<span
 style="font-weight: bold; font-style: italic;"></span></li>
  <li><span style="font-weight: bold; font-style: italic;">findOwners.jsp</span>
    <span style="font-weight: bold; font-style: italic;"> </span>implements
    <span style="font-weight: bold; font-style: italic;">findOwnersForm</span>.</li>
  <li><span style="font-weight: bold; font-style: italic;">owners.jsp</span>
    <span style="font-weight: bold; font-style: italic;"> </span>implements<span
 style="font-weight: bold; font-style: italic;"> selectOwnerView</span>.</li>
  <li><span style="font-weight: bold; font-style: italic;">owner.jsp</span>
    <span style="font-weight: bold; font-style: italic;"> </span>implements
    <span style="font-weight: bold; font-style: italic;">ownerView</span><span
 style="font-weight: bold; font-style: italic;"></span>.</li>
  <li><span style="font-weight: bold; font-style: italic;">ownerForm.jsp</span>
    <span style="font-weight: bold; font-style: italic;"> </span>implements<span
 style="font-weight: bold; font-style: italic;"> </span><span
 style="font-weight: bold; font-style: italic;">ownerForm</span>.</li>
  <li><span style="font-weight: bold; font-style: italic;">petForm.jsp</span>
    <span style="font-weight: bold; font-style: italic;"> </span>implements<span
 style="font-weight: bold; font-style: italic;"> </span><span
 style="font-weight: bold; font-style: italic;">petForm</span>.</li>
  <li><span style="font-weight: bold; font-style: italic;">visitForm.jsp</span>
    <span style="font-weight: bold; font-style: italic;"> </span>implements
    <span style="font-weight: bold; font-style: italic;">visitForm</span>.</li>
  <li><span style="font-weight: bold; font-style: italic;">dataAccessFailure.jsp
    </span>displays a stacktrace</li>
  <li><span style="font-weight: bold; font-style: italic;">header.jsp</span>
and <span style="font-style: italic; font-weight: bold;">footer.jsp</span>
display info common to virtually all pages. Spring also supplies
support for the integration of <a
 href="http://www.lifl.fr/%7Edumoulin/tiles">Tiles</a>
(included in Struts) but this is not used in PetClinic.</li>
</ul>
<br>
The following JSP's each display a form field and the bound error data
for that field:<br>
<ul>
  <li style="font-weight: bold; font-style: italic;">address.jsp</li>
  <li style="font-weight: bold; font-style: italic;">city.jsp</li>
  <li style="font-weight: bold; font-style: italic;">telephone.jsp</li>
  <li style="font-weight: bold; font-style: italic;">lastName.jsp</li>
  <li style="font-weight: bold; font-style: italic;">firstName.jsp</li>
</ul>
<br>
The following items should be noted regarding the web application
implementation design:<br>
<ol>
  <li>all JSP's are stored under <span
 style="font-weight: bold; font-style: italic;">/WEB-INF/jsp </span>except
for <span style="font-weight: bold; font-style: italic;">index.jsp </span>which
is the configured "welcome-file"</li>
  <li>The use of JSP technology in the appplication is not exposed to
the user, i.e., the end user never sees a URL ending in <span
 style="font-weight: bold; font-style: italic;">".jsp".</span></li>
  <li>By convention, all URL's in the application ending in <span
 style="font-weight: bold; font-style: italic;">".htm" </span>are
handled by web application controllers. Static html pages ending in <span
 style="font-weight: bold; font-style: italic;">".html"</span>, such as
Javadocs, will be directly served to the end user.</li>
  <li>The results of all form entries are handled using browser round
trip redirection to minimize possible end user confusion.</li>
  <li>All pages are extremely simple JSP implementations that focus
only on providing the necessary functionality.</li>
  <li>References to <span style="font-weight: bold;">Entity </span>objects
are passed around in the application by supplying the object's Id as a
request parameter.<br>
  </li>
</ol>
<span style="font-weight: bold; text-decoration: underline;"><br>
</span>
<h3><span style="font-weight: bold; text-decoration: underline;"> </span><span
 style="font-weight: bold; text-decoration: underline;">Testing</span></h3>
<ul>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;"></span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.</span><span
 style="font-weight: bold; font-style: italic;">Owner</span><span
 style="font-weight: bold; font-style: italic;">Test</span>s is a JUnit
TestCase that supports Business Rule #1.<span
 style="font-weight: bold; font-style: italic;"></span></li>
  <li><span style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold; font-style: italic;"><span
 style="font-weight: bold;">org.springframework.</span></span></span><span
 style="font-weight: bold; font-style: italic;"></span></span><span
 style="font-weight: bold; font-style: italic;">.</span></span><span
 style="font-weight: bold; font-style: italic;">petclinic.</span><span
 style="font-weight: bold; font-style: italic;">Abstract</span><span
 style="font-weight: bold; font-style: italic;">JdbcClinicTests</span>
is a JUnit TestCase requiring a live database connection that is used
to
confirm correct operation of the database access objects implemented in
    <span style="font-weight: bold;">AbstractJdbcClinic </span>and its
subclasses.<span style="font-weight: bold;"> </span>Subclasses of<span
 style="font-weight: bold;"><span style="font-weight: bold;">&nbsp; </span></span><span
 style="font-weight: bold;"><span style="font-weight: bold;"><span
 style="font-weight: bold;">Abstract</span><span
 style="font-weight: bold;">JdbcClinicTests </span></span></span>provide
the location of the application context file to use for the tests to be
run<span style="font-weight: bold;"><span style="font-weight: bold;"><span
 style="font-weight: bold;">.</span></span></span><span
 style="font-weight: bold;"><span style="font-weight: bold;"> <span
 style="font-weight: bold;"></span></span></span><span
 style="text-decoration: underline; font-weight: bold;"></span></li>
</ul>
<span style="text-decoration: underline; font-weight: bold;"></span><br
 style="font-weight: bold;">
<ul>
  <li>Download and install the <a
 href="http://sourceforge.net/projects/springframework/">Spring
Framework</a> (examples, including PetClinic are provided)</li>
  <li>Download and install a <a href="http://java.sun.com/">Java</a>
Software Developer Kit, preferably version 1.4 or later</li>
  <li>Download and install <a href="http://ant.apache.org">Apache Ant</a>,
preferably version 1.5.1 or later</li>
  <li>Download and install <a href="http://www.junit.org/index.htm">JUnit</a>,
preferably version 3.8.1 or later</li>
  <li>Download and install <a
 href="http://jakarta.apache.org/tomcat/index.html">Apache Tomcat</a>,
preferably version 4.1.18 or later</li>
  <li>Download and install <a href="http://www.mysql.com/">Mysql</a>,
(optional)</li>
  <li><a href="http://hsqldb.sourceforge.net/">Hypersonic SQL</a> , <a
 href="http://hibernate.org/">Hibernate</a>, and <a
 href="http://db.apache.org/ojb/">Apache OJB</a> are provided with the
application.</li>
  <li>PetClinic and Spring use the <a href="http://www.apache.org/">Apache</a>
    <a href="http://jakarta.apache.org/commons/logging/">Commons Logging</a>
and <a href="http://jakarta.apache.org/log4j/docs/index.html">Log4J</a>
packages</li>
</ul>
<span style="font-weight: bold; text-decoration: underline;">Ant Setup</span><br>
Make sure that the Ant executable is in your command shell path. Ant
will need to reference classes from <span style="font-weight: bold;">JUnit</span>
and
the database(s) of interest. Place a copy of any needed jar files in
Ant's <span style="font-weight: bold; font-style: italic;">/lib </span>directory,
i.e.:<br>
<ul>
  <li>JUnit - <span style="font-weight: bold; font-style: italic;">junit.jar</span></li>
  <li>HSQL - <span style="font-weight: bold; font-style: italic;">hsqldb.jar</span></li>
  <li>MYSQL - <span style="font-weight: bold; font-style: italic;">mysql-connector-java-3.x-bin.jar</span>
or other</li>
</ul>
<span style="font-weight: bold; text-decoration: underline;">HSQL Setup</span><br>
Create a new directory containing the a copy of the entire contents of
the directory <span style="font-weight: bold; font-style: italic;">petclinic/db/hsqldb</span>.
The file <span style="font-weight: bold; font-style: italic;">petclinic.script</span>
is the data file that will be used by the server. It has been
initialized with some sample data. Start a server on the standard port
by executing <span style="font-weight: bold; font-style: italic;">server.sh</span>(Unix)
or <span style="font-weight: bold; font-style: italic;">server.bat </span>(Windows)
or alterrnatively edit the file to select a port of your choosing.
A useful database manager can be started by&nbsp; by executing <span
 style="font-weight: bold; font-style: italic;">manager.sh </span>(Unix)
or <span style="font-weight: bold; font-style: italic;">manager.bat </span>(Windows).
When the application opens, connect to the "HSQL Database Engine
Server" using the default parameters. This tool can also be used to
manage other databases. To use a different port, it will be necessary
to
change the PetClinic Database Setup. It may also be necessary to
consult
the HSQL documentation for instructions on to change the port the
server
uses.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">MYSQL
Setup (optional)</span><br>
Add the PetClinic database to a running server by running the SQL
script <span style="font-weight: bold; font-style: italic;">db/mysql/initDB.txt</span>.
PetClinic expects, by default to be able to access the server via the
standard port 3306. To use a different port, it will be necessary to
change the PetClinic Database Setup.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">PetClinic
Database Setup</span><br>
To use a J2EE server supplied connection-pooled data source with
Tomcat, it will be
necessary to use and possibly edit the appropriate context definition
file for the petclinic webapp. To use it, deploy a copy of the
appropriate context definition file in Tomcat's webapps directory and
restart the server. Consult the Tomcat log files if something goes
wrong when starting either Tomcat or the PetClinic application. The
context files are named <span
 style="font-weight: bold; font-style: italic;">petclinic_tomcat_*.xml</span>,
where <span style="font-weight: bold; font-style: italic;">*</span> is
a codename for the database. There is a context file supplied for each
database in its respective directory. There is also a context file <span
 style="font-weight: bold; font-style: italic;">db/petclinic_tomcat_all.xml</span>
that will provide a JNDI connection-pooled datasource for all supported
databases<span style="font-weight: bold; font-style: italic;"></span>.
Should you use this file, you must of course make sure that all the
database servers are running when you restart Tomcat.<br>
<br>
<span style="font-weight: bold;"><a name="dbNotes"></a>NOTES:</span> <br>
<ol>
  <li>Should you deploy one of the context files or define a context in
Tomcat's <span style="font-weight: bold; font-style: italic;">server.xml</span>,
Tomcat will not automatically deploy the webapp from the <span
 style="font-weight: bold; font-style: italic;">petclinic.war </span>file.
The webapp will then need to be manually extracted to the target
directory.</li>
  <li>The context files will also configure logging to supply a
separate log file for the petclinic context. This will separate the
container logging for petclinic from that of the other webapps. This
should not be confused with the application log file provided through <span
 style="font-weight: bold;">Log4j.</span></li>
  <li><span style="font-weight: bold;"></span>An Ant script (<span
 style="font-weight: bold; font-style: italic;">db/build.xml </span>)
has been provided that can be used to re-initialize either database. To
select or configure the data source used for the webapp and for
testing,
you will need to edit the files:<br>
  </li>
</ol>
<ul style="margin-left: 40px;">
  <li style="font-weight: bold;"><span style="font-weight: normal;"><span
 style="font-weight: bold; font-style: italic;">war/WEB-INF/applicationContext.xml</span>
(for the webapp)</span> <span style="font-weight: normal;"></span></li>
  <li><span style="font-weight: bold; font-style: italic;">build.properties</span>
(for testing)</li>
  <li style="font-weight: bold;"><span style="font-style: italic;">test/src/testContext.xml</span>&nbsp;<span
 style="font-weight: normal;"> (for testing)</span></li>
</ul>
<span style="font-weight: bold; text-decoration: underline;">Building
the PetClinic Application</span><br>
Open a command line shell and navigate to the directory containing
PetClinic and execute "ant". This will display a list of the Ant
targets
that are available. Make sure the database is running and execute "ant
all". This will run the Ant "all" target which will clean and compile
everything, produce Javadocs, and execute the tests, including a
live test using the database. The other Ant targets provide subsets of
this functionality.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">Deploying
the PetClinic Application</span><br>
Deploy the web application to the server in the usual way (see <a
 href="#dbNotes">notes</a> regarding database setup). If you need
instructions for web application deployment, see the Tomcat
documentation for details. The Web ARchive file is <span
 style="font-weight: bold; font-style: italic;">petclinic.war</span>
and
can be found in the <span
 style="font-weight: bold; font-style: italic;">dist</span> directory.<br>
<br>
<span style="font-weight: bold; text-decoration: underline;">Using the
PetClinic Application</span><br>
Make sure the PetClinic web application is running and browse to <a
 href="http://localhost:8080/petclinic">http://localhost:8080/petclinic</a>
or <a href="http://www.springframework.org/webapps/petclinic">check it
out online</a>.<br>
<br>
<br>

<%@ include file="/WEB-INF/jsp/footer.jsp" %>

