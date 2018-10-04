# CSYE6225-Fall2018
-------------------------------------------------------------------------------------------------------------------------------------------
## Team Members: 
* Deepak Padhi - padhi.d@husky.neu.edu
* Gaurang Deshmukh - deshmukh.g@husky.neu.edu
* Shreyas Kalyanaraman - kalyanaraman.s@husky.neu.edu
* Hardik Chalke - chalke.h@husky.neu.edu
-------------------------------------------------------------------------------------------------------------------------------------------
## Prerequisites for building and deploying locally

### Software Requirements 
* Intellij / Eclipse
* MY SQL Workbench & MariaDb server  
* Postman
* Java JDK
-------------------------------------------------------------------------------------------------------------------------------------------
## Build and Deploy instructions for Web Application:

### Step 1: Setting up the environment
* Create a connection with username as 'root' and password as **your mariadb password**
* Create database with name 'user_cloud' in your mysql workbench 
* Import the WebApp folder in Itellij / Eclipse IDE
* Select maven as default build
* Add JDK path (mostly found in /usr/java/jdk_1.8.0) as default SDK  
* Build the project and Run the application from intellij / eclipse
* Tomcat server should start on port 8080

### Step2: Using the application
* Start mariadb server. Run systemctl start mariadb.service
* Open Postman

#### Creating account and viewing current time
* Enter localhost:8080/time in the URL section. Keep method as GET and hit 'Send' button
* Expected result: {Respone: You are not logged in}. Error code - 401:Unauthorized
* Select BasicAuth from Authorization tab. Enter username and password in the input box
* Enter localhost:8080/user/register in the URL section. Change the method to POST and hit 'Send' button
* Expected result: {Response: Your account has been registered}. Response Code - 200:Success
* Enter localhost:8080/time. Change method to GET and hit 'Send' button
* Expected result: {Current Time: **current time will be displayed**}. Response Code - 200:OK

**Note: All the below steps require username and password to be passed in Header for authenticating the user**
#### Creating, Updating, Deleting and get all transactions
* Enter localhost:8080/transact/ in the URL section. Keep method as GET and hit 'Send' button
* Expected result: []. Error code - 200:OK
##### Creating transaction
* Enter localhost:8080/transact/create in the URL section. Keep method as POST
* Select body tab. Select 'raw' radio button and change text to JSON(application/json)
* In the input box below, enter any json file according to below format 
{
    "description": "Coffee",
    "merchant": "Startbucks",
    "amount": 5.00,
    "date": "08/12/2018",
    "category": "food"
}
* Press 'Send' button
* Expected response: 200:Created

##### Get all transaction
* Enter localhost:8080/transact/ in the URL section. Keep method as GET and hit 'Send' button
* Expected Result (dummy value):
{
  "uuid":"$2a$04$9S1YyzCM4NRiMDqaV8s9ZeoNe6eCEV3Rn1-THLTqJeSKX02cicjN2"
  "description": "Coffee",
  "merchant": "Startbucks",
  "amount": 5.00,
  "date": "08/12/2018",
  "category": "food"
}
* Response code: 200:OK

##### Update transaction
* Enter localhost:8080/transact/update/**UUID** in the URL section. Keep method as PUT. 
  For eg: 8080/transact/update/$2a$04$9S1YyzCM4NRiMDqaV8s9ZeoNe6eCEV3Rn1-THLTqJeSKX02cicjN2  
* Select body tab. Select 'raw' radio button and change text to JSON(application/json)
* In the input box below, enter any json file according to below format 
{
    "description": "Hashbrowns",
    "merchant": "Dunkin",
    "amount": 3.00,
    "date": "08/12/2018",
    "category": "food"
}
* Press 'Send' button
* Expected response: 201:Created
{
   "uuid":"$2a$04$9S1YyzCM4NRiMDqaV8s9ZeoNe6eCEV3Rn1-THLTqJeSKX02cicjN2"
   "description": "Hashbrowns",
   "merchant": "Dunkin",
   "amount": 3.00,
   "date": "08/12/2018",
   "category": "food"
}

##### Deleting a transaction
* Enter localhost:8080/transact/delete/**UUID** in the URL section. Keep method as DELETE. 
  For eg: 8080/transact/delete/$2a$04$9S1YyzCM4NRiMDqaV8s9ZeoNe6eCEV3Rn1-THLTqJeSKX02cicjN2
* Press 'Send' button
* Expected response: 204:No Content
----------------------------------------------------------------------------------------------------------------------------------------

### Step 3: Steps to Run Integration Tests

* Run UserLoginApplicationTests,java from Intellij / Eclipse IDE
* Both the test cases should pass
