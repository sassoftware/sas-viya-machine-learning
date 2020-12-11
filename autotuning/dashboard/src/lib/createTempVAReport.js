/*
 * ------------------------------------------------------------------------------------
 *   Copyright (c) SAS Institute Inc.
 *   Licensed under the Apache License, Version 2.0 (the "License");
 *   you may not use this file except in compliance with the License.
 *   You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 *   Unless required by applicable law or agreed to in writing, software
 *   distributed under the License is distributed on an "AS IS" BASIS,
 *   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *   See the License for the specific language governing permissions and
 *   limitations under the License.
 * ---------------------------------------------------------------------------------------
 *
 */

async function createTempVAReport ( store, services, folderName, reportName, newContent ) {

  let { reports, folders } = services;

  // check if this report already exists; delete if found
  let oldReport = await findReport( store, reports, reportName );
  if ( oldReport !== null ) {
    await store.apiCall( oldReport.itemsCmd( oldReport.itemsList(0), 'delete' ) );
  };

  // find (root) folder named 'folderName'
  let payload = {  qs: { filter: `eq(name,'${folderName}')` } };
  debugger;
  let foldersList = await store.apiCall( folders.links("rootFolders"), payload );
  debugger;
  if(foldersList.itemsList().size === 0) {
    return null;
  }
  debugger;
  let id = foldersList.items( folderName, 'data', 'id' );
  let URI = `/folders/folders/${id}`;
  debugger;
  console.log( 'Folder =', folderName, '; id =', id, '; URI =', URI);

  // create a new (empty) report, name='reportName'
  payload = {
    qs   : { parentFolderUri: URI },
    data : {
      name        : reportName,
      description : 'Temporary VA Report for Autotune monitoring webtop'
    },
  };
  debugger;
  let newreport = await store.apiCall(reports.links('createReport'), payload);
  debugger;
  id = newreport.items( 'id' );
  let reportUri = `/reports/reports/${id}`;
  console.log( 'Report =', reportName, '; id =', id, '; URI =', reportUri );
  debugger;

  // send JSON content to the newly created VA report
  payload = {
    data    : newContent,
    headers : {
      'Content-Type' : 'application/vnd.sas.report.content+json',
      'Accept'       : '*/*',
    },
  };
  newreport = await store.apiCall( newreport.links('updateContent'), payload );
  debugger;
  return reportUri;
}

async function findReport( store, reports, name ) {
    let payload  = { qs : { filter : `eq(name,'${name}')` } }
    let reportsList = await store.apiCall(reports.links('reports'), payload);
    return ( reportsList.itemsList().size === 0 ) ? null : reportsList;
}

// function loadFile(filePath) {
//   var result = null;
//   var xmlhttp = new XMLHttpRequest();
//   xmlhttp.open("GET", filePath, false);
//   xmlhttp.send();
//   if (xmlhttp.status === 200) {
//     result = xmlhttp.responseText;
//   }
//   return result;
// }

export default createTempVAReport;
