/*
 * Copyright (c) SAS Institute Inc.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 *
 */

'use strict';

let rafserver = require ('restaf-server');
let rafEnv    = (process.argv.length === 3) ? process.argv [ 2 ] : null ;
console.log(
  (rafEnv === null) ?
  'NOTE: Using settings from environment variables' :
  `NOTE: env file is: ${rafEnv}`
);
rafserver.UIapp ( getCustomHandler(), null, rafEnv );

function getCustomHandler() {
  let handler =
  [
    {
      method    : [ 'GET' ],
      path      : `/appenv`,
      config    : {
        auth    : false,
        cors    : true,
        handler : getAppEnv
      }
    }
  ];
  return handler;
}

async function getAppEnv (req, h) {

  debugger;

  let env = `
  let APPENV = {
    WORK_LIB_NAME        : '${process.env.WORK_LIB_NAME}',
    DATA_TABLE_NAME      : '${process.env.DATA_TABLE_NAME}',
    host                 : '${process.env.VIYA_SERVER}',
    WORK_FOLDER_NAME     : '${process.env.WORK_FOLDER_NAME}',
    TEMP_REPORT_NAME     : '${process.env.TEMP_REPORT_NAME}',
  }
  let serverMode = 'app';

  let LOGONPAYLOAD = {
    authType: '${process.env.AUTHFLOW}',
    host    : '${process.env.VIYA_SERVER}',
    clientID: '${process.env.CLIENTID}',
    redirect: '${process.env.APPNAME}/${process.env.REDIRECT}'
  };
  `;
  console.log( env );
  return env;
}
