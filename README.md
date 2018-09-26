# csye6225-fall2018-repo-template
# Team Members: 
# Deepak Padhi - padhi.d@husky.neu.edu
# Gaurang Deshmukh - deshmukh.g@husky.neu.edu
# Shreyas Kalyanaraman - kalyanaraman.s@husky.neu.edu
# Hardik Chalke - chalke.h@husky.neu.edu

#Prerequisites for building and deploying application locally
#1.Software Requirements: Intellij / Eclipse, MY SQL, Postman

#Build and Deploy instructions for Web Application:

Step 1: Setting up the environment
#1. Create a connection with username as 'root' and password as 'admin' 
#2. Create database with name 'user_cloud' in your mysql workbench 
#3. Import the user_login.jar file in Itellij / Eclipse IDE
#4. Build the project and Run the application from intellij / eclipse
#5. Tomcat server should start on port 8080

Step2: Using the application
#1. Open Postman
#2. Enter localhost:8080/ in the URL section. Keep method as GET and hit 'Send' button
#3. Expected result: {Data: You are not logged in, Response code: NOT_FOUND}
#4. Enter localhost:8080/register in the URL section. Change the method to POST and hit 'Send' button
#5. Expected result: {Data: Your account has been registered, Response code: OK}
#6. Enter localhost:8080/. CHange method to GET and hit 'Send' button
#7. Expected result: {Data: Current Time: <current time will be displayed>, Response Code: OK}


