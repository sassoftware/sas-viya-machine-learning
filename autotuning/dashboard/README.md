# Autotune Execution Monitoring Web-app

This web-app provides basic monitoring capabilities for an Autotune execution process within a Viya server. The web-app can be used both for live monitoring and for post-process viewing of the Autotune results. The web-app uses the (global) history table created and updated by the Autotune process during its execution. The app configures and displays a *live* [SAS Visual Analytics (VA)](https://www.sas.com/en_us/software/visual-analytics.html) report that is *connected* to the history table.

## Underlying technologies

This web-app is built using [Node.js](https://nodejs.org/en/ "Node.js") and [React](https://reactjs.org/ "React") framework.
It uses [Material UI](https://material-ui.com/ "Material UI") for themes and styling.
The app relies heavily on the [RestAF framework](https://github.com/sassoftware/restaf "RestAF framework") for authentication and communication with the Viya server and making various RestAPI calls.

## Installation

Install Node.js and Node Package Manager (NPM) from this [website](https://nodejs.org/en/ "download node.js and npm").
(NPM is distributed and installed together with Node.js.)

Obtain the code in this repository by cloning the master branch.
You should see a directory called `autotune-webapp` created in your current directory.

```
  git clone git@gitlab.sas.com:olgolo/autotune-webapp.git
  cd autotune-webapp
```

Run the installation command to install all required 3-rd party packages in your local directory.
Run the build script to create run-time code for the app.

```
  npm install
  npm run build
```

## app.env file

The [app.env](https://gitlab.sas.com/olgolo/autotune-webapp/blob/master/app.env) file in your installation directory contains various configuration options used by the web-app. You must edit this file and set the values of the options to match your Viya server location and other settings. The comments inside the file explain the meaning of the various fields.

## Viya server configuration

To allow the web-app to connect to your Viya server, and to create and then display a VA report, a number of configuration changes must be done on the Viya server as described in the following sections. All of these steps require administration privileges.

## Registering the web-app client with your Viya server

Download and install the [registerclient utility](https://github.com/sassoftware/restaf/wiki/Managing-clientids).
Use the instructions that come with the utility to create a *register.env* file that points to your Viya server; then launch the utility.
Issue the **logon** command, and use an administrator account to authenticate to your Viya server.
Issue the **list** command to see the current list of all registered clients if desired.
Choose a unique *ClientID*, and a *Secret* token for your web-app. They will be used to identify the web-app client with your Viya server. These tokens are specified in your [app.env](https://gitlab.sas.com/olgolo/autotune-webapp/blob/master/app.env) file.

    >npx @sassoftware/registerclient --env registerclient.env
    ...
    >> logon
    Enter your userid> ****
    Enter your password> ********
    Logon Successful
    >> list
    clientid  : appc
                    grantTypes: authorization_code,refresh_token
                    redirect  : http://localhost:5001/callback
    clientid  : autotune
                    grantTypes: authorization_code,refresh_token
                    redirect  : http://viya353.na.sas.com:5001/callback
    >>

Use the **new** command of the utility to register your client with the Viya server.
The redirect URL for the app client must be of the form `http://<apphost>:<appport>/callback`.
Here are two examples, for a web-app running on either the *localhost* or *viya353* machine, at port 5001, with *ClientID*=`my_client` and *Secret*=`my_secret` use this command:

    >> new -t authorization_code -s my_secret -r http://localhost:5001/callback my_client
    >> new -t authorization_code -s my_secret -r http://viya353.na.sas.com:5001/callback my_client

## Configuring CORS, CSRF, and security options on the Viya server

Login to your Viya server using an administrator account.
Open the **SAS Environment Manager** application (top left menu -> **ADMINSTRATION** -> **Manage Environment**).
Select **Configuration** item on the left tools ribbon (the wrench icon).
Select **View: Definitions** on the top menu.

Select **sas.commons.web.security.cors** from the list on the left pane.
If there are no confgurations displayed on the right-hand pane, click **New Configuration** button.
If a configuration is already displayed click **Edit** button to edit it (the pencil icon in the top right corner).
Set the **Allowed Origins** field to `*` (asterisk -> allow all origins). Optionally, set this field to allow your specific domain name that the web-app will be using.
Do not change the other fields in the CORS configuration.
Save the CORS configuration.

Select **sas.commons.web.security** from the list on the left pane.
On the right pane find the configuration named **SAS Visual Analytics**.
Click **Edit** button to edit the configuration (the pencil icon in the top right corner).
Set the **x-frame-options-enabled** option to `off`.
Save the security configuration.
If there is a configuration named **SAS Report Viewer**, repeat the above steps for this configuration.


Select **sas.commons.web.security.csrf** from the list on the left pane.
On the right pane, click **Edit** button to edit the configuration.
Set the **allowedUris** field to the name of the domain used by your web-app client. The value must be a regular expression, and can contain multiple domains, separated by commas. For example, this value will allow both `localhost` clients, and clients connecting from `*.sas.com` domains: `http:\/\/localhost:*, http:\/\/([^\.]+\.)*sas\.com`

After making the environment changes, restart all services on your Viya server and wait about 15 minutes for the changes to propagate and take effect. Note, it usually takes a few start attempts before all services come back to life. Use the following commands (you must have `root` privileges):
- To check status of all servers and services:
`sudo /etc/init.d/sas-viya-all-services status`
- To stop all servers and services:
`sudo /etc/init.d/sas-viya-all-services stop`
- To start all servers and services:
`sudo /etc/init.d/sas-viya-all-services start`

The following link will take you to the [SAS Viya 3.4 Administration: General Servers and Services](https://go.documentation.sas.com/api/docsets/calchkadm/3.4/content/calchkadm.pdf "SAS® Viya® 3.4 Administration: General Servers and Services - PDF book") guide where you can find more information about restarting Viya services.

# Using the web-app

To start the web-app server, execute the following command from the installation directory:

    npm run start

Open a browser (only Chrome browser is currently supported), and enter the URL of the web-app. The URL should be printed to the command line window where you started the web-app server.
The app contains only one page, although provisions exist for adding more pages, and the fly-out menu on the left hand side can be extended with links to these pages.
The default names of the CASLIB and the DATA TABLE as configured in your [app.env](https://gitlab.sas.com/olgolo/autotune-webapp/blob/master/app.env) will be displayed at the top of the [page](https://gitlab.sas.com/olgolo/autotune-webapp/blob/master/front-page-at-startup.jpg). Edit the names to point to the actual Autotune history table and click **Load** button. The web-app will examine the data table, figure out what hyperparameters were used by the Autotune process, create a new VA report with these hypermarameters, and then display the report. If the Autotune process is running while the web-app is displaying the VA report, it will be continuously updated as new points are appended to the history data table by the Autotune process. Navigate through [the tabs of the VA](https://gitlab.sas.com/olgolo/autotune-webapp/blob/master/web-app-va-report.jpg) report to monitor or examine the results of the Autotune process.
